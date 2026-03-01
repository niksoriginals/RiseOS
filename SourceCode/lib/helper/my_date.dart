import 'package:flutter/material.dart';

class MydateUtil {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getMessageTime({
    required BuildContext context,
    required String time,
  }) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    final formattedtime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      // If the message was sent today, return the time
      return formattedtime;
    }
    return now.year == sent.year
        ? '$formattedtime - ${sent.day} ${_getMonth(sent)}'
        : '$formattedtime - ${sent.day} ${_getMonth(sent)}  ${sent.year}';
  }

  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool ShowYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      // If the message was sent today, return the time
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return ShowYear
        ? '${sent.day}  ${_getMonth(sent)}${sent.year}'
        : '${sent.day}  ${_getMonth(sent)}';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return ''; // In case the month is invalid
    }
  }

  static String getLastActiveTime({
    required BuildContext context,
    required String lastActive, // this is a timestamp string
  }) {
    // Parse the last active time into a DateTime object
    final int i = int.tryParse(lastActive) ?? -1;

    // Get the current time
    if (i == -1) return "Last Seen not available";

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return "Last seen today at $formattedTime";
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return "Last seen yesterday at $formattedTime";
    }
    String month = _getMonth(time);
    return "Last Seen on ${time.day} $month at $formattedTime";
  }
}
