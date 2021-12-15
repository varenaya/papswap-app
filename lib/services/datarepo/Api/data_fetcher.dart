import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataFetcher {
  final _firestore = FirebaseFirestore.instance;
  final currentusedId = FirebaseAuth.instance.currentUser!.uid;

  // Future<UserData> getcraterdata(String createrid) async {
  //   final data = await _firestore.collection('users').doc(createrid).get();
  //   return UserData(
  //     userName: data.data()!['userName'],
  //     userEmail: data.data()!['userEmail'],
  //     user_id: data.data()!['user_id'],
  //     userImage: data.data()!['userImage'],
  //     dateJoined: data.data()!['dateJoined'],
  //     coinVal: data.data()!['coinVal'],
  //     userBio: data.data()!['userBio'],
  //     userGender: data.data()!['userGender'],
  //     userWebsite: data.data()!['userWebsite'],
  //     userType: data.data()!['userType'],
  //   );
  // }

  Future<QuerySnapshot> getFeed(
    int limit, {
    DocumentSnapshot? startAfter,
  }) async {
    final refposts = _firestore
        .collection('Posts')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refposts.get();
    } else {
      return refposts.startAfterDocument(startAfter).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getfirstpost() {
    final ref = _firestore
        .collection('Posts')
        .orderBy('createdAt', descending: true)
        .limit(1);
    return ref.get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getpost(String postid) {
    final ref = _firestore.collection('Posts').doc(postid);
    return ref.get();
  }

  Future<QuerySnapshot<Map>> getprofilepostdata(
    String type,
    int limit, {
    DocumentSnapshot? startAfter,
  }) async {
    final refposts = _firestore
        .collection('users')
        .doc(currentusedId)
        .collection(type == 'swaps' ? 'swaps' : 'likes')
        .orderBy(
          type == 'swaps' ? 'swapedAt' : 'likedAt',
          descending: true,
        )
        .limit(limit);
    if (startAfter == null) {
      return refposts.get();
    } else {
      return refposts.startAfterDocument(startAfter).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getfirstlikepost() {
    final ref = _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('likes')
        .orderBy('likedAt', descending: true)
        .limit(1);
    return ref.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getfirstswappost() {
    final ref = _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('swaps')
        .orderBy('swapedAt', descending: true)
        .limit(1);
    return ref.get();
  }

  Future<Map> getreswappostdata() async {
    final List<Map> postdatalist = [];
    final List commentdatalist = [];
    final data = await _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('reswaps')
        .orderBy(
          'reswapedAt',
          descending: true,
        )
        .get();
    for (var element in data.docs) {
      final postId = element.data()['postId'];
      final commentId = element.data()['comment_id'];
      final commentdata = await _firestore
          .collection('Posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .get();
      commentdatalist.add(commentdata.data());
      final postdata = {};
      postdatalist.add(postdata);
    }
    return {'postdata': postdatalist, 'commentdata': commentdatalist};
  }

  Future<QuerySnapshot<Map<String, dynamic>>> gettransactiondata() async {
    final data = await _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('transactions')
        .orderBy(
          'trans_time',
          descending: true,
        )
        .limit(10)
        .get();

    return data;
  }
}
