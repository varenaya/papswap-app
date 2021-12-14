import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String feedtext;
  final String medialink;
  final String postId;
  final String createrId;
  final Timestamp createdAt;
  final String creatername;
  final String createrimg;
  final int likes;
  final int swaps;
  final int reports;

  const Post(
      {required this.feedtext,
      required this.medialink,
      required this.postId,
      required this.createdAt,
      required this.createrId,
      required this.reports,
      required this.likes,
      required this.createrimg,
      required this.creatername,
      required this.swaps});

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
        likes: doc.data()!['likes'],
        swaps: doc.data()!['swaps']);
  }
}
