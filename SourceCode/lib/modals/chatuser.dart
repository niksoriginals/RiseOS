class ChatUser {
  ChatUser({
    required this.id,
    required this.image,
    required this.phone,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.pushToken,
    required this.email,
  });
  late String id;
  late String image;
  late String phone;
  late String name;
  late String about;
  late String createdAt;
  late String lastActive;
  late bool isOnline;
  late String pushToken;
  late String email;

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    phone = json['phone'];
    name = json['name'];
    about = json['about'];
    createdAt = json['created_at'];
    lastActive = json['last_active'];
    isOnline = json['is_online'];
    pushToken = json['push_token'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['phone'] = phone;
    data['name'] = name;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }
}
