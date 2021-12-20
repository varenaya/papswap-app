import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:papswap/models/post.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';

class FlamesPostData extends ChangeNotifier {
  final DataFetcher dataFetcher = DataFetcher();
  final _postsSnapshot = <DocumentSnapshot<Map>>[];
  final _flameSnapshot = <DocumentSnapshot<Map>>[];
  String _errorMessage = '';
  int documentLimit = 5;
  bool _hasNext = true;
  bool _isFetchingposts = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<Post> get flamesposts =>
      _postsSnapshot.map((doc) => Post.fromDoc(doc)).toList();

  Future fetchflamesposts(bool isrefresh) async {
    if (isrefresh) {
      final firstflamedata =
          await dataFetcher.getfirstprofilepost('flames', 'flamedAt');
      if (firstflamedata.docs.isNotEmpty) {
        if (firstflamedata.docs.first.data()['postId'] !=
            flamesposts.first.postId) {
          _postsSnapshot.removeRange(0, _postsSnapshot.length);
          _flameSnapshot.clear();
          flamesposts.clear();
        }
      }
    }

    if (_isFetchingposts) return;

    _errorMessage = '';
    _isFetchingposts = true;

    try {
      final snap = await dataFetcher.getprofilepostdata(
        'flames',
        documentLimit,
        startAfter: _flameSnapshot.isNotEmpty ? _flameSnapshot.last : null,
      );
      _flameSnapshot.addAll(snap.docs);
      for (var doc in snap.docs) {
        final postdata = await dataFetcher.getpost(doc.data()['postId']);
        _postsSnapshot.add(postdata);
      }

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } on FirebaseException catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingposts = false;
  }

  Future removeflame(String postId) async {
    if (flamesposts.isNotEmpty) {
      flamesposts.removeWhere((element) {
        return element.postId == postId;
      });
    }
    if (_postsSnapshot.isNotEmpty) {
      _postsSnapshot.removeWhere((element) {
        return element.data()!['post_id'] == postId;
      });
    }
    if (_flameSnapshot.isNotEmpty) {
      _flameSnapshot.removeWhere((element) {
        return element.data()!['postId'] == postId;
      });
    }
    notifyListeners();
  }
}
