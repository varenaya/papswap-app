import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:papswap/models/userdata.dart';
import 'package:path/path.dart';

class UploadData {
  final _firestore = FirebaseFirestore.instance;

  Future<String?> postData(
      String feedtext, UserData userData, BuildContext context) async {
    try {
      final DocumentReference docRef = _firestore.collection('Posts').doc();
      await docRef.set({
        'feedtext': feedtext,
        'post_id': docRef.id,
        'createdAt': DateTime.now(),
        'createrid': userData.user_id,
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

  Future<void> postlike(
      String postId, String currentuserdataid, bool isincrement) async {
    if (isincrement) {
      _firestore.collection('Posts').doc(postId).update({
        'likes': FieldValue.increment(1),
      });
    } else {
      _firestore.collection('Posts').doc(postId).update({
        'likes': FieldValue.increment(-1),
      });
    }

    _firestore
        .collection('users')
        .doc(currentuserdataid)
        .collection('likes')
        .add({
      'postId': postId,
      'likedAt': DateTime.now(),
    });
  }

  Future<void> postswap(String postId, String currentuserdataid) async {
    _firestore
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
      }
    });
  }

  Future<String?> reswappostData(String feedtext, UserData userData,
      BuildContext context, String postId) async {
    try {
      final DocumentReference docRef = _firestore
          .collection('Posts')
          .doc(postId)
          .collection('comments')
          .doc();
      await docRef.set({
        'feedtext': feedtext,
        'post_id': postId,
        'comment_id': docRef.id,
        'createdAt': DateTime.now(),
        'commenterid': userData.user_id,
        'medialink': '',
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
}
