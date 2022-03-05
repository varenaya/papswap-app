import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String feedtext;
  final String medialink;
  final String postId;
  final String createrId;
  final Timestamp createdAt;
  final String creatername;
  final String createrimg;
  final int flames;
  final int swaps;
  final int reports;
  final String category;
  final String posttag;

  const Post(
      {required this.feedtext,
      required this.medialink,
      required this.postId,
      required this.createdAt,
      required this.createrId,
      required this.reports,
      required this.flames,
      required this.createrimg,
      required this.creatername,
      required this.swaps,
      required this.category,
      required this.posttag});

  factory Post.fromDoc(DocumentSnapshot<dynamic> doc) {
    return Post(
        feedtext: doc.data()!['feedtext'],
        medialink: doc.data()!['medialink'],
        postId: doc.data()!['post_id'],
        createdAt: doc.data()!['createdAt'],
        createrId: doc.data()!['createrid'],
        createrimg: doc.data()!['creater_img'],
        creatername: doc.data()!['creater_name'],
        reports: doc.data()!['reports'],
        flames: doc.data()!['flames'],
        swaps: doc.data()!['swaps'],
        category: doc.data()!['category'],
        posttag: doc.data()!['posttag']);
  }
}
