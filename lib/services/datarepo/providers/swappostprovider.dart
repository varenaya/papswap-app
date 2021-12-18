import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:papswap/models/post.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';

class SwapPostData extends ChangeNotifier {
  final DataFetcher dataFetcher = DataFetcher();
  final _postsSnapshot = <DocumentSnapshot>[];
  final _swapSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 5;
  bool _hasNext = true;
  bool _isFetchingposts = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<Post> get swapposts =>
      _postsSnapshot.map((doc) => Post.fromDoc(doc)).toList();

  Future fetchswapposts(bool isrefresh) async {
    if (isrefresh) {
      final firstswapdata =
          await dataFetcher.getfirstprofilepost('swaps', 'swapedAt');
      if (firstswapdata.docs.first.data()['postId'] != swapposts.first.postId) {
        _postsSnapshot.removeRange(0, _postsSnapshot.length);
        _swapSnapshot.clear();
        swapposts.clear();
      }
    }
    if (_isFetchingposts) return;

    _errorMessage = '';
    _isFetchingposts = true;

    try {
      final snap = await dataFetcher.getprofilepostdata(
        'swaps',
        documentLimit,
        startAfter: _swapSnapshot.isNotEmpty ? _swapSnapshot.last : null,
      );
      _swapSnapshot.addAll(snap.docs);
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
