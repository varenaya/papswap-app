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

  Query<Map<String, dynamic>> gettransactiondata() {
    return _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('transactions')
        .orderBy(
          'trans_time',
          descending: true,
        );
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

  Query<Map<String, dynamic>> allsuperTokens() {
    return _firestore
        .collection('superTokens')
        .orderBy('launchedOn', descending: true);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> rewardlist() {
    final data = _firestore.collection('rewards');
    return data.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> movieslist() {
    final data = _firestore.collection('movies');
    return data.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> voucherslist() {
    final data = _firestore.collection('vouchers');
    return data.get();
  }
}
