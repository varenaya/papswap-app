import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:papswap/models/post.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';

class PostData extends ChangeNotifier {
  final DataFetcher _dataFetcher = DataFetcher();
  final _postsSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 7;
  bool _hasNext = true;
  bool _isFetchingposts = false;
  String get errorMessage => _errorMessage;
  String _selectedcategory = '';

  bool get hasNext => _hasNext;

  String get selectedcategory => _selectedcategory;

  List<Post> get posts =>
      _postsSnapshot.map((doc) => Post.fromDoc(doc)).toList();

  Future fetchpostedpost(String postid) async {
    final data = await _dataFetcher.getpost(postid);

    final post = Post.fromDoc(data);
    if (!posts.contains(post)) {
      _postsSnapshot.insert(0, data);
      posts.insert(0, post);
    }
    notifyListeners();
  }

  Future fetchNextposts(bool isrefresh) async {
    if (isrefresh) {
      final firstpostdata = await _dataFetcher.getfirstpost();
      final firstpost = Post.fromDoc(firstpostdata.docs.first);

      if (firstpost.postId != posts.first.postId) {
        _postsSnapshot.removeRange(0, _postsSnapshot.length);
        posts.clear();
        _hasNext = true;
      }
    }
    if (_isFetchingposts) return;

    _errorMessage = '';
    _isFetchingposts = true;

    try {
      final snap = await _dataFetcher.getFeed(
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

  Future selectedcategoryactions(
      String category, bool iselected, BuildContext context) async {
    if (iselected) {
      _selectedcategory = category;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Filter applied: Showing posts of $category',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      _selectedcategory = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Filter removed',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    notifyListeners();
  }
}
