import 'package:papswap/models/userdata.dart';

class PostDataList {
  late List postdata;
  late List<UserData> createrdatalist;
  late List<bool> ispostliked;

  PostDataList(
      {required this.postdata,
      required this.createrdatalist,
      required this.ispostliked});
}
