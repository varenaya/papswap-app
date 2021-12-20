// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  late String userName;
  late String userEmail;
  late String user_id;
  late String userImage;
  late String userBio;
  late String userGender;
  late String userWebsite;
  late int coinVal;
  late Timestamp dateJoined;
  late String userType;
  late Timestamp dailyrewardTimestamp;
  late Timestamp weeklyrewardTimestamp;

  UserData({
    required this.userEmail,
    required this.userName,
    required this.user_id,
    required this.userImage,
    required this.userBio,
    required this.userGender,
    required this.dateJoined,
    required this.userWebsite,
    required this.coinVal,
    required this.userType,
    required this.weeklyrewardTimestamp,
    required this.dailyrewardTimestamp,
  });
}
