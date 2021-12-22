import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:papswap/models/post.dart';
import 'package:papswap/models/reswappost.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';

class ReswapPostData extends ChangeNotifier {
  final DataFetcher dataFetcher = DataFetcher();
  final _commentsSnapshot = <Map>[];
  final _reswapSnapshot = <DocumentSnapshot<Map>>[];
  String _errorMessage = '';
  int documentLimit = 5;
  bool _hasNext = true;
  bool _isFetchingposts = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<ReswapPost> get reswapposts => _commentsSnapshot.map((doc) {
        return ReswapPost.fromDoc(doc['commentdata'], doc['post']);
      }).toList();

  Future fetchreswapposts(bool isrefresh) async {
    if (isrefresh) {
      final firstflamedata =
          await dataFetcher.getfirstprofilepost('reswaps', 'reswapedAt');
      if (firstflamedata.docs.first.data()['comment_id'] !=
          reswapposts.first.commentId) {
        _commentsSnapshot.clear();
        _reswapSnapshot.clear();
        reswapposts.clear();
      }
    }
    if (_isFetchingposts) return;

    _errorMessage = '';
    _isFetchingposts = true;

    try {
      final snap = await dataFetcher.getreswappostdata(
        documentLimit,
        startAfter: _reswapSnapshot.isNotEmpty ? _reswapSnapshot.last : null,
      );
      _reswapSnapshot.addAll(snap.docs);
      for (var doc in snap.docs) {
        final commentdata = await dataFetcher.getcomment(
            doc.data()['comment_id'], doc.data()['postId']);
        final postdata = await dataFetcher.getpost(doc.data()['postId']);
        final Post post = Post.fromDoc(postdata);
        final map = {
          'post': post,
          'commentdata': commentdata,
        };
        _commentsSnapshot.add(map);
      }

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } on FirebaseException catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingposts = false;
  }

  Future removereswap(String commentId) async {
    if (reswapposts.isNotEmpty) {
      reswapposts.removeWhere((element) {
        return element.commentId == commentId;
      });
    }
    if (_commentsSnapshot.isNotEmpty) {
      _commentsSnapshot.removeWhere((element) {
        return element['commentdata'].data()['comment_id'] == commentId;
      });
    }
    if (_reswapSnapshot.isNotEmpty) {
      _reswapSnapshot.removeWhere((element) {
        return element.data()!['comment_id'] == commentId;
      });
    }
    notifyListeners();
  }
}
