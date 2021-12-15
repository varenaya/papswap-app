import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:papswap/models/post.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';

class LikesPostData extends ChangeNotifier {
  final DataFetcher dataFetcher = DataFetcher();
  final _postsSnapshot = <DocumentSnapshot<Map>>[];
  final _likeSnapshot = <DocumentSnapshot<Map>>[];
  String _errorMessage = '';
  int documentLimit = 5;
  bool _hasNext = true;
  bool _isFetchingposts = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<Post> get likesposts =>
      _postsSnapshot.map((doc) => Post.fromDoc(doc)).toList();

  Future fetchlikesposts(bool isrefresh) async {
    if (isrefresh) {
      final firstlikedata = await dataFetcher.getfirstlikepost();

      final postdata =
          await dataFetcher.getpost(firstlikedata.docs.first.data()['postId']);
      final likepost = Post.fromDoc(postdata);
      if (likepost.postId != likesposts.first.postId) {
        _postsSnapshot.removeRange(0, _postsSnapshot.length);
        _likeSnapshot.clear();
        likesposts.clear();
      }
    }

    if (_isFetchingposts) return;

    _errorMessage = '';
    _isFetchingposts = true;

    try {
      final snap = await dataFetcher.getprofilepostdata(
        'likes',
        documentLimit,
        startAfter: _likeSnapshot.isNotEmpty ? _likeSnapshot.last : null,
      );
      _likeSnapshot.addAll(snap.docs);
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

  Future removelike(String postId) async {
    if (likesposts.isNotEmpty) {
      likesposts.removeWhere((element) {
        return element.postId == postId;
      });
    }
    if (_postsSnapshot.isNotEmpty) {
      _postsSnapshot.removeWhere((element) {
        return element.data()!['post_id'] == postId;
      });
    }
    if (_likeSnapshot.isNotEmpty) {
      _likeSnapshot.removeWhere((element) {
        return element.data()!['postId'] == postId;
      });
    }
    notifyListeners();
  }
}
