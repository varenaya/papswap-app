import 'package:flutter/material.dart';
import 'package:papswap/models/postdata.dart';
import 'package:papswap/services/datarepo/data_fetcher.dart';

class PostDataListProvider extends ChangeNotifier {
  PostDataList? _postdata;

  PostDataList? get postdata {
    return _postdata;
  }

  Future<void> postData() async {
    final postlist = await DataFetcher().postdata();
    _postdata = PostDataList(
        postdata: postlist['postdata'].docs,
        createrdatalist: postlist['createrdata'],
        ispostliked: postlist['ispostliked']);

    notifyListeners();
  }
}
