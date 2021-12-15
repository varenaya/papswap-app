import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:papswap/models/post.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';

class PostData extends ChangeNotifier {
  final DataFetcher dataFetcher = DataFetcher();
  final _postsSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 10;
  bool _hasNext = true;
  bool _isFetchingposts = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<Post> get posts =>
      _postsSnapshot.map((doc) => Post.fromDoc(doc)).toList();

  Future fetchpostedpost(String postid) async {
    final data = await dataFetcher.getpost(postid);
    _postsSnapshot.insert(0, data);
    final post = Post.fromDoc(data);
    if (!posts.contains(post)) {
      posts.insert(0, post);
    }
    notifyListeners();
  }

  Future fetchNextposts(bool isrefresh) async {
    if (isrefresh) {
      final firstpostdata = await dataFetcher.getfirstpost();
      final firstpost = Post.fromDoc(firstpostdata.docs.first);

      if (firstpost.postId != posts.first.postId) {
        _postsSnapshot.removeRange(0, _postsSnapshot.length);
        posts.clear();
      }
    }
    if (_isFetchingposts) return;

    _errorMessage = '';
    _isFetchingposts = true;

    try {
      final snap = await dataFetcher.getFeed(
        documentLimit,
        startAfter: _postsSnapshot.isNotEmpty ? _postsSnapshot.last : null,
      );

      _postsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } on FirebaseException catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingposts = false;
  }

  Future fetchprofileposts(String type) async {
    if (_isFetchingposts) return;

    _errorMessage = '';
    _isFetchingposts = true;

    try {
      final snap = await dataFetcher.getprofilepostdata(
        type,
        documentLimit,
        startAfter: _postsSnapshot.isNotEmpty ? _postsSnapshot.last : null,
      );
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
}
