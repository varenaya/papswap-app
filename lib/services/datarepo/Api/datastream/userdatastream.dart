import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:papswap/models/userdata.dart';

class Userdatastream {
  final _firestore = FirebaseFirestore.instance;

  Stream<UserData> userdata() {
    return _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) => UserData(
              userName: event.data()!['userName'],
              userEmail: event.data()!['userEmail'],
              user_id: event.data()!['user_id'],
              userImage: event.data()!['userImage'],
              dateJoined: event.data()!['dateJoined'],
              coinVal: event.data()!['coinVal'],
              userBio: event.data()!['userBio'],
              userGender: event.data()!['userGender'],
              userWebsite: event.data()!['userWebsite'],
              userType: event.data()!['userType'],
              dailyrewardTimestamp: event.data()!['dailyrewardTimestamp'],
              weeklyrewardTimestamp: event.data()!['weeklyrewardTimestamp'],
            ));
  }

  UserData get initialuserdata {
    return UserData(
      userName: '',
      userEmail: '',
      userGender: '',
      userBio: '',
      coinVal: 0,
      dateJoined: Timestamp.now(),
      userImage: '',
      user_id: '',
      userWebsite: '',
      userType: '',
      dailyrewardTimestamp: Timestamp.now(),
      weeklyrewardTimestamp: Timestamp.now(),
    );
  }
}
