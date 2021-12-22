import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataFetcher {
  final _firestore = FirebaseFirestore.instance;
  final currentusedId = FirebaseAuth.instance.currentUser!.uid;

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
        .collection(type == 'swaps' ? 'swaps' : 'flames')
        .orderBy(
          type == 'swaps' ? 'swapedAt' : 'flamedAt',
          descending: true,
        )
        .limit(limit);
    if (startAfter == null) {
      return refposts.get();
    } else {
      return refposts.startAfterDocument(startAfter).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getfirstprofilepost(
      String collection, String orderby) {
    final ref = _firestore
        .collection('users')
        .doc(currentusedId)
        .collection(collection)
        .orderBy(orderby, descending: true)
        .limit(1);
    return ref.get();
  }

  Future<QuerySnapshot<Map>> getreswappostdata(
    int limit, {
    DocumentSnapshot? startAfter,
  }) async {
    final refposts = _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('reswaps')
        .orderBy(
          'reswapedAt',
          descending: true,
        )
        .limit(limit);
    if (startAfter == null) {
      return refposts.get();
    } else {
      return refposts.startAfterDocument(startAfter).get();
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getcomment(
      String commentid, String postid) {
    final ref = _firestore
        .collection('Posts')
        .doc(postid)
        .collection('comments')
        .doc(commentid);
    return ref.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> gettransactiondata(
    int limit, {
    DocumentSnapshot? startAfter,
  }) async {
    final refposts = _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('transactions')
        .orderBy(
          'trans_time',
          descending: true,
        );
    // .limit(limit);

    if (startAfter == null) {
      return refposts.get();
    } else {
      return refposts.startAfterDocument(startAfter).get();
    }
  }

  Stream<DocumentSnapshot> myPostflameStream(String postId) {
    final ref = _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('flames')
        .doc(postId);
    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> mysuperTokens() {
    final ref = _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('superTokens')
        .orderBy('earnedOn', descending: true);
    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> allsuperTokens() {
    final ref = _firestore
        .collection('superTokens')
        .orderBy('launchedOn', descending: true);
    return ref.snapshots();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> rewardlist() async {
    final data = await _firestore.collection('rewards').get();
    return data.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> movieslist() async {
    final data = await _firestore.collection('movies').get();
    return data.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      voucherslist() async {
    final data = await _firestore.collection('vouchers').get();
    return data.docs;
  }
}
