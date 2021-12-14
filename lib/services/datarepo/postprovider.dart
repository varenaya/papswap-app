import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:papswap/models/post.dart';
import 'package:papswap/services/datarepo/data_fetcher.dart';

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

  Future fetchNextposts() async {
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
}
