import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/services/datarepo/providers/likespostprovider.dart';
import 'package:papswap/services/datarepo/providers/postprovider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UploadData {
  final _firestore = FirebaseFirestore.instance;
  final currentusedId = FirebaseAuth.instance.currentUser!.uid;

  Future<String?> postData(
      String feedtext, UserData userData, BuildContext context) async {
    try {
      final DocumentReference docRef = _firestore.collection('Posts').doc();
      await docRef.set({
        'feedtext': feedtext,
        'post_id': docRef.id,
        'createdAt': DateTime.now(),
        'createrid': userData.user_id,
        'creater_name': userData.userName,
        'creater_img': userData.userImage,
        'likes': 0,
        'swaps': 0,
        'reports': 0,
        'medialink': '',
      });
      _firestore
          .collection('users')
          .doc(userData.user_id)
          .collection('swaps')
          .add({
        'postId': docRef.id,
        'swapedAt': DateTime.now(),
      });
      Provider.of<PostData>(context, listen: false).fetchpostedpost(docRef.id);
      return docRef.id;
    } on FirebaseException catch (e) {
      var message = 'An error occured in uploading the post! Try again';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return null;
    }
  }

  Future<UploadTask?> postMedia(
      File? media, String docId, BuildContext context) async {
    try {
      final fileName = basename(media!.path);
      final destination = 'posts/$docId/postmedia/$fileName';
      final ref = FirebaseStorage.instance.ref(destination);
      final task = ref.putFile(media);

      return task;
    } on FirebaseException catch (e) {
      var message = 'An error occured in uploading the post! Try again';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return null;
    }
  }

  Future<void> updatepostmedialink(String docId, String url) async {
    _firestore.collection('Posts').doc(docId).update({
      'medialink': url,
    });
  }

  Future<void> postlike(String postId, String currentuserdataid,
      bool isincrement, BuildContext context) async {
    if (isincrement) {
      await _firestore.collection('Posts').doc(postId).update({
        'likes': FieldValue.increment(1),
      });
      await _firestore
          .collection('users')
          .doc(currentuserdataid)
          .collection('likes')
          .doc(postId)
          .set({
        'postId': postId,
        'likedAt': DateTime.now(),
      });
    } else {
      await _firestore.collection('Posts').doc(postId).update({
        'likes': FieldValue.increment(-1),
      });
      await _firestore
          .collection('users')
          .doc(currentuserdataid)
          .collection('likes')
          .doc(postId)
          .delete();
      Provider.of<LikesPostData>(context, listen: false).removelike(postId);
    }
  }

  Future<String> postswap(String postId, String currentuserdataid) async {
    String msg = '';
    await _firestore
        .collection('users')
        .doc(currentuserdataid)
        .collection('swaps')
        .where('postId', isEqualTo: postId)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        _firestore.collection('Posts').doc(postId).update({
          'swaps': FieldValue.increment(1),
        });
        _firestore
            .collection('users')
            .doc(currentuserdataid)
            .collection('swaps')
            .add({
          'postId': postId,
          'swapedAt': DateTime.now(),
        });
        msg = 'This post has been swapped to your profile!';
      } else {
        msg = 'You have already swapped this post!';
      }
    });

    return msg;
  }

  Future<String?> reswappostData(String feedtext, UserData userData,
      BuildContext context, String postId) async {
    try {
      final DocumentReference docRef = _firestore
          .collection('Posts')
          .doc(postId)
          .collection('comments')
          .doc();

      final transdocRef = _firestore
          .collection('users')
          .doc(userData.user_id)
          .collection('transactions')
          .doc();

      await docRef.set({
        'feedtext': feedtext,
        'post_id': postId,
        'comment_id': docRef.id,
        'createdAt': DateTime.now(),
        'commenterid': userData.user_id,
        'medialink': '',
        'is_verified': false,
        'supertoken': [],
      });

      _firestore.collection('Posts').doc(postId).update({
        'swaps': FieldValue.increment(1),
      });
      _firestore.collection('users').doc(userData.user_id).update({
        'coinVal': FieldValue.increment(2),
      });
      transdocRef.set({
        'transactionId': transdocRef.id,
        'transtext': 'Credited 2 PapTokens for reswapping.',
        'amount': 2,
        'trans_time': DateTime.now(),
        'details': '2 PapTokens for reswapping post with postId: $postId'
      });

      _firestore
          .collection('users')
          .doc(userData.user_id)
          .collection('reswaps')
          .add({
        'postId': postId,
        'comment_id': docRef.id,
        'reswapedAt': DateTime.now(),
      });

      return docRef.id;
    } on FirebaseException catch (e) {
      var message = 'An error occured in uploading the post! Try again';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return null;
    }
  }

  Future<UploadTask?> reswappostMedia(File? media, String commentId,
      BuildContext context, String postId) async {
    try {
      final fileName = basename(media!.path);
      final destination =
          'posts/$postId/comments/$commentId/commentsmedia/$fileName';
      final ref = FirebaseStorage.instance.ref(destination);
      final task = ref.putFile(media);

      return task;
    } on FirebaseException catch (e) {
      var message = 'An error occured in uploading the post! Try again';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return null;
    }
  }

  Future<void> updatereswappostmedialink(
      String docId, String url, String postId) async {
    _firestore
        .collection('Posts')
        .doc(postId)
        .collection('comments')
        .doc(docId)
        .update({
      'medialink': url,
    });
  }

  Future<void> updatevideobonus() async {
    final transdocRef = _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('transactions')
        .doc();
    _firestore.collection('users').doc(currentusedId).update({
      'coinVal': FieldValue.increment(1),
    });
    transdocRef.set({
      'transactionId': transdocRef.id,
      'transtext': 'You earned a PapToken from video bonus.',
      'amount': 1,
      'trans_time': DateTime.now(),
      'details': 'You earned 1 PapToken by watching a video Ad.'
    });
  }

  Future<String> updatedailybonus(Timestamp rewardTimestamp) async {
    if ((DateTime.now()).difference(rewardTimestamp.toDate()).inDays >= 1) {
      final transdocRef = _firestore
          .collection('users')
          .doc(currentusedId)
          .collection('transactions')
          .doc();
      _firestore.collection('users').doc(currentusedId).update({
        'coinVal': FieldValue.increment(1),
        'rewardTimestamp': DateTime.now(),
      });
      transdocRef.set({
        'transactionId': transdocRef.id,
        'transtext': 'You earned a PapToken by claiming daily bonus.',
        'amount': 1,
        'trans_time': DateTime.now(),
        'details':
            '1 PapToken credited to your wallet for claiming  daily bonus.'
      });
      return 'You claimed a daily bonus!';
    } else {
      return 'You have already claimed today\'s bonus!';
    }
  }

  Future<String> updateweeklybonus(Timestamp rewardTimestamp) async {
    final weekday = DateTime.now().weekday;
    if ((DateTime.now()).difference(rewardTimestamp.toDate()).inDays >= 1 &&
            weekday == 5 ||
        weekday == 7) {
      final transdocRef = _firestore
          .collection('users')
          .doc(currentusedId)
          .collection('transactions')
          .doc();
      _firestore.collection('users').doc(currentusedId).update({
        'coinVal':
            weekday == 5 ? FieldValue.increment(10) : FieldValue.increment(15),
        'rewardTimestamp': DateTime.now(),
      });
      transdocRef.set({
        'transactionId': transdocRef.id,
        'transtext': weekday == 5
            ? 'You earned 10 PapTokens from weekly bonus.'
            : 'You earned 15 PapTokens from weekly bonus.',
        'amount': weekday == 5 ? 10 : 15,
        'trans_time': DateTime.now(),
        'details': weekday == 5
            ? '10 PapTokens credited to your wallet for claiming  weekly bonus on Wednesday.'
            : '15 PapTokens credited to your wallet for claiming  weekly bonus on Sunday.'
      });
      return 'You claimed a weekly bonus!';
    } else {
      return 'You can only claim once every sunday and wednesday';
    }
  }
}
