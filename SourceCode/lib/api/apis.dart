import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

import 'package:xrisepvtz/modals/chatuser.dart';
import 'package:xrisepvtz/modals/message.dart';

import 'access_firebase_token.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fstore = FirebaseFirestore.instance;
  static FirebaseStorage fstorage = FirebaseStorage.instance;
  static User get ppl => auth.currentUser!;
  static late ChatUser me;

  static Future<void> getselfinfo() async {
    await fstore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((ppl) async {
      if (ppl.exists) {
        me = ChatUser.fromJson(ppl.data()!);
        getFirebaseMessagingToken();
        Apis.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getselfinfo());
      }
    });
  }

  static Future<bool> userExists() async {
    return (await fstore.collection("users").doc(auth.currentUser!.uid).get())
        .exists;
  }

  static Future<void> createUser() async {
    final time = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // Corrected time fetching

    final chatUser = ChatUser(
      // Renamed the variable to avoid conflict
      id: ppl.uid,
      name: ppl.displayName ?? 'Unknown', // Handling potential null value
      email: ppl.email ?? 'Unknown', // Handling potential null value
      about: "RiseUser",
      image: ppl.photoURL ?? '', // Handling potential null value
      createdAt: time,
      isOnline: false,
      lastActive: time,
      phone: ppl.phoneNumber ?? 'Unknown', // Handling potential null value
      pushToken: "",
    );

    return await fstore
        .collection("users")
        .doc(ppl.uid)
        .set(chatUser.toJson()); // Using toJson() on the object
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallusers() {
    return Apis.fstore
        .collection("users")
        .where("id", isNotEqualTo: ppl.uid)
        .snapshots();
  }

  static Future<void> updatedata() async {
    await fstore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> updatepic(File file) async {
    try {
      final ext = file.path.split(".").last;
      final ref = fstorage.ref().child('profile_pictures/${ppl.uid}');

      // Upload the file
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/$ext'),
      );
      log("Data Transferred: ${uploadTask.bytesTransferred / 1000}kb");

      // Get the download URL
      me.image = await ref.getDownloadURL();

      // Update Firestore document
      await fstore.collection("users").doc(auth.currentUser!.uid).update({
        'image': me.image,
      });

      log("Profile picture updated successfully.");
    } catch (e) {
      log("Failed to update profile picture: $e");
    }
  }

  static String getConversationId(String id) =>
      ppl.uid.hashCode <= id.hashCode ? '${ppl.uid}_$id' : '${id}_${ppl.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser ppl) {
    // Corrected the function name from getCoversationId to getConversationId
    return fstore
        .collection("chats/${getConversationId(ppl.id)}/message/")
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    fstore
        .collection('chats/${getConversationId(message.fromId)}/message/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser ppl) {
    return fstore
        .collection("chats/${getConversationId(ppl.id)}/message/")
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    try {
      final ext = file.path.split(".").last;
      final ref = fstorage.ref().child(
          'images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/$ext'),
      );
      log("Data Transferred: ${uploadTask.bytesTransferred / 1000}kb");

      // Get the download URL
      final imagURL = await ref.getDownloadURL();

      // Update Firestore document
      await sendMessage(chatUser, imagURL, Type.image);
      log("Profile picture updated successfully.");
    } catch (e) {
      log("Failed to update profile picture: $e");
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return fstore
        .collection("users")
        .where("id", isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    fstore.collection("users").doc(ppl.uid).update({
      "is_online": isOnline,
      "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
      "push_token": me.pushToken,
    });
  }

  static FirebaseMessaging fmsg = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await fmsg.requestPermission();

    fmsg.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log("push token: ${t}");
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Got Foreground");
      log("message data : ${message.data}");
      if (message.notification != null) {
        log("Message also contained a notification : ${message.notification}");
      }
    });
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        toId: chatUser.id,
        read: "",
        type: type,
        sent: time,
        fromId: ppl.uid);
    final ref =
        fstore.collection("chats/${getConversationId(chatUser.id)}/message/");
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : "Image"));
  }

  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    AccessFirebaseToken accessToken = AccessFirebaseToken();
    String bearerToken = await accessToken.getAccessToken();
    final body = {
      "message": {
        "token": chatUser.pushToken,
        "notification": {
          "title": me.name,
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "some_data": "User ID: ${me.id}",
        },
      }
    };
    try {
      var res = await post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/riseupgraded/messages:send'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $bearerToken'
        },
        body: jsonEncode(body),
      );
      print("Response statusCode: ${res.statusCode}");
      print("Response body: ${res.body}");
    } catch (e) {
      print("\nsendPushNotification: $e");
    }
  }

  static Future<void> deleteMessage(Message message) async {
    await fstore
        .collection('chats/${getConversationId(message.toId)}/message/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await fstorage.refFromURL(message.msg).delete();
    }
  }
}
