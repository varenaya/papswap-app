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
    // for (var element in data.docs) {
    //   final postId = element.data()['postId'];
    //   final commentId = element.data()['comment_id'];
    //   final commentdata = await _firestore
    //       .collection('Posts')
    //       .doc(postId)
    //       .collection('comments')
    //       .doc(commentId)
    //       .get();
    //   commentdatalist.add(commentdata.data());
    //   final postdata = {};
    //   postdatalist.add(postdata);
    // }
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
        )
        .limit(limit);

    if (startAfter == null) {
      return refposts.get();
    } else {
      return refposts.startAfterDocument(startAfter).get();
    }
  }
}
