import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papswap/models/post.dart';

class ReswapPost {
  final String comment;
  final String commentId;
  final String commenterId;
  final Post post;
  final String medialink;
  final Timestamp createdAt;
  final String postId;
  final bool isverified;
  final List superToken;

  const ReswapPost({
    required this.comment,
    required this.commentId,
    required this.createdAt,
    required this.post,
    required this.postId,
    required this.medialink,
    required this.isverified,
    required this.superToken,
    required this.commenterId,
  });

  factory ReswapPost.fromDoc(DocumentSnapshot<dynamic> doc, Post post) {
    return ReswapPost(
        comment: doc.data()!['feedtext'],
        medialink: doc.data()!['medialink'],
        postId: doc.data()!['post_id'],
        createdAt: doc.data()!['createdAt'],
        commenterId: doc.data()!['commenterid'],
        commentId: doc.data()!['comment_id'],
        isverified: doc.data()!['is_verified'],
        superToken: doc.data()!['supertoken'],
        post: post);
  }

  factory ReswapPost.empty() {
    return ReswapPost(
        comment: '',
        commentId: '',
        createdAt: Timestamp.now(),
        post: Post(
            feedtext: '',
            medialink: '',
            postId: '',
            createdAt: Timestamp.now(),
            createrId: '',
            reports: 0,
            flames: 0,
            createrimg: '',
            creatername: '',
            swaps: 0,
            category: ''),
        postId: '',
        medialink: '',
        isverified: false,
        superToken: [],
        commenterId: '');
  }
}
