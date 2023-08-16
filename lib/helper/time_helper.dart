import 'package:cloud_firestore/cloud_firestore.dart';

//returning a formated data as a string

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  DateTime now = DateTime.now();

  Duration difference = now.difference(dateTime);
  int minutes = difference.inMinutes;

  if (minutes < 1) {
    return "Just now";
  } else if (minutes < 60) {
    return "$minutes min ago";
  } else if (minutes < 1440) {
    int hours = (minutes / 60).floor();
    return "$hours ${hours == 1 ? 'hour' : 'hours'} ago";
  } else {
    int days = (minutes / 1440).floor();
    return "$days ${days == 1 ? 'day' : 'days'} ago";
  }
}
