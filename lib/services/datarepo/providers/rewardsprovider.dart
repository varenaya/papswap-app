import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';

class RewardData extends ChangeNotifier {
  final DataFetcher dataFetcher = DataFetcher();
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _rewarddata = [];
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _moviesdata = [];
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _vouchersdata = [];

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get rewarddata =>
      [..._rewarddata];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get moviesdata =>
      [..._moviesdata];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get vouchersdata =>
      [..._vouchersdata];

  Future loadrewards() async {
    if (_rewarddata.isEmpty) {
      final data = await dataFetcher.rewardlist();
      _rewarddata.addAll(data.docs);
      notifyListeners();
    }
  }

  Future loadmovies() async {
    if (_moviesdata.isEmpty) {
      final data = await dataFetcher.movieslist();
      _moviesdata.addAll(data.docs);
      notifyListeners();
    }
  }

  Future loadvouchers() async {
    if (_vouchersdata.isEmpty) {
      final data = await dataFetcher.voucherslist();
      _vouchersdata.addAll(data.docs);
      notifyListeners();
    }
  }
}
