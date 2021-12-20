import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/services/datarepo/providers/flamespostprovider.dart';
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
        'flames': 0,
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

  Future<void> updatepostmedialink(
      String docId, String url, BuildContext context) async {
    try {
      _firestore.collection('Posts').doc(docId).update({
        'medialink': url,
      });
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
    }
  }

  Future<void> postflame(String postId, String currentuserdataid,
      bool isincrement, BuildContext context) async {
    try {
      if (isincrement) {
        await _firestore.collection('Posts').doc(postId).update({
          'flames': FieldValue.increment(1),
        });
        await _firestore
            .collection('users')
            .doc(currentuserdataid)
            .collection('flames')
            .doc(postId)
            .set({
          'postId': postId,
          'flamedAt': DateTime.now(),
        });
      } else {
        await _firestore.collection('Posts').doc(postId).update({
          'flames': FieldValue.increment(-1),
        });
        await _firestore
            .collection('users')
            .doc(currentuserdataid)
            .collection('flames')
            .doc(postId)
            .delete();
        Provider.of<FlamesPostData>(context, listen: false).removeflame(postId);
      }
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
    }
  }

  Future<String> postswap(
      String postId, String currentuserdataid, BuildContext context) async {
    String msg = '';
    try {
      final post = await DataFetcher().getpost(postId);
      if (post.exists) {
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
      } else {
        msg = 'This post has been deleted.';
      }
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
    }

    return msg;
  }

  Future<String?> reswappostData(String feedtext, UserData userData,
      BuildContext context, String postId) async {
    try {
      final post = await DataFetcher().getpost(postId);
      if (post.exists) {
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'This post has been deleted.',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
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
      String docId, String url, String postId, BuildContext context) async {
    try {
      _firestore
          .collection('Posts')
          .doc(postId)
          .collection('comments')
          .doc(docId)
          .update({
        'medialink': url,
      });
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
    }
  }

  Future<void> updatevideobonus(BuildContext context) async {
    try {
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
    }
  }

  Future<String?> updatedailybonus(Timestamp dailyrewardTimestamp) async {
    try {
      if ((DateTime.now()).difference(dailyrewardTimestamp.toDate()).inDays >=
          1) {
        final transdocRef = _firestore
            .collection('users')
            .doc(currentusedId)
            .collection('transactions')
            .doc();
        _firestore.collection('users').doc(currentusedId).update({
          'coinVal': FieldValue.increment(1),
          'dailyrewardTimestamp': DateTime.now(),
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
    } on FirebaseException catch (e) {
      var message = 'An error occured in uploading the post! Try again';
      if (e.message != null) {
        message = e.message!;
      }

      return message;
    }
  }

  Future<String?> updateweeklybonus(Timestamp weeklyrewardTimestamp) async {
    try {
      final weekday = DateTime.now().weekday;
      if ((DateTime.now()).difference(weeklyrewardTimestamp.toDate()).inDays >=
              1 &&
          weekday == 7) {
        final transdocRef = _firestore
            .collection('users')
            .doc(currentusedId)
            .collection('transactions')
            .doc();
        _firestore.collection('users').doc(currentusedId).update({
          'coinVal': FieldValue.increment(5),
          'weeklyrewardTimestamp': DateTime.now(),
        });
        transdocRef.set({
          'transactionId': transdocRef.id,
          'transtext': 'You earned 5 PapTokens from weekly bonus.',
          'amount': 5,
          'trans_time': DateTime.now(),
          'details':
              '5 PapTokens credited to your wallet for claiming  weekly bonus on Sunday.'
        });
        return 'You claimed a weekly bonus!';
      } else {
        return 'You can only claim once every sunday.';
      }
    } on FirebaseException catch (e) {
      var message = 'An error occured in uploading the post! Try again';
      if (e.message != null) {
        message = e.message!;
      }

      return message;
    }
  }

  Future<void> uploadreport(String postId, String reporttext, UserData user,
      BuildContext context) async {
    try {
      _firestore.collection('Posts').doc(postId).update({
        'reports': FieldValue.increment(1),
      });
      final reportRef = _firestore
          .collection('Posts')
          .doc(postId)
          .collection('reports')
          .doc();
      reportRef.set({
        'reportId': reportRef.id,
        'postId': postId,
        'reporttext': reporttext,
        'userName': user.userName,
        'userId': user.user_id,
        'userEmail': user.userEmail,
        'reportedAt': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thanks! We have taken your feedback.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.blue,
        ),
      );
      Navigator.of(context).pop();
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
    }
  }
}
