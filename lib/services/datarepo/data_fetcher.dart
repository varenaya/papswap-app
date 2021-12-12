import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:papswap/models/userdata.dart';

class DataFetcher {
  final _firestore = FirebaseFirestore.instance;
  final currentusedId = FirebaseAuth.instance.currentUser!.uid;

  Future<UserData> getcraterdata(String createrid) async {
    final data = await _firestore.collection('users').doc(createrid).get();
    return UserData(
      userName: data.data()!['userName'],
      userEmail: data.data()!['userEmail'],
      user_id: data.data()!['user_id'],
      userImage: data.data()!['userImage'],
      dateJoined: data.data()!['dateJoined'],
      coinVal: data.data()!['coinVal'],
      userBio: data.data()!['userBio'],
      userGender: data.data()!['userGender'],
      userWebsite: data.data()!['userWebsite'],
      userType: data.data()!['userType'],
    );
  }

  Future<Map> postdata() async {
    final List<UserData> createrdatalist = [];
    final List<bool> ispostliked = [];
    final postdatalist = await _firestore
        .collection('Posts')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .limit(10)
        .get();
    for (var element in postdatalist.docs) {
      final createrid = element.data()['createrid'];
      await _firestore
          .collection('users')
          .doc(currentusedId)
          .collection('likes')
          .where('postId', isEqualTo: element.data()['post_id'])
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          ispostliked.add(true);
        } else {
          ispostliked.add(false);
        }
      });

      final createrdata = await getcraterdata(createrid);

      createrdatalist.add(createrdata);
    }
    return {
      'postdata': postdatalist,
      'createrdata': createrdatalist,
      'ispostliked': ispostliked
    };
  }

  Future<Map> individualpostdata(String postId, String type) async {
    UserData? createrdata;
    bool? ispostliked;
    final postdata = await _firestore.collection('Posts').doc(postId).get();

    final createrid = postdata.data()!['createrid'];
    if (type == 'swaps') {
      await _firestore
          .collection('users')
          .doc(currentusedId)
          .collection('likes')
          .where('postId', isEqualTo: postId)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          ispostliked = true;
        } else {
          ispostliked = false;
        }
      });
    }

    createrdata = await getcraterdata(createrid);

    return {
      'postdata': postdata,
      'createrdata': createrdata,
      'ispostliked': ispostliked
    };
  }

  Future<List<Map>> getprofilepostdata(String userId, String type) async {
    final List<Map> datalist = [];
    final data = await _firestore
        .collection('users')
        .doc(userId)
        .collection(type == 'swaps' ? 'swaps' : 'likes')
        .orderBy(
          type == 'swaps' ? 'swapedAt' : 'likedAt',
          descending: true,
        )
        .limit(10)
        .get();
    for (var element in data.docs) {
      final postId = element.data()['postId'];
      final postdata = await individualpostdata(postId, type);
      datalist.add(postdata);
    }
    return datalist;
  }

  Future<Map> getreswappostdata() async {
    final List<Map> postdatalist = [];
    final List commentdatalist = [];
    final data = await _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('reswaps')
        .orderBy(
          'reswapedAt',
          descending: true,
        )
        .get();
    for (var element in data.docs) {
      final postId = element.data()['postId'];
      final commentId = element.data()['comment_id'];
      final commentdata = await _firestore
          .collection('Posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .get();
      commentdatalist.add(commentdata.data());
      final postdata = await individualpostdata(postId, 'reswaps');
      postdatalist.add(postdata);
    }
    return {'postdata': postdatalist, 'commentdata': commentdatalist};
  }

  Future<QuerySnapshot<Map<String, dynamic>>> gettransactiondata() async {
    final data = await _firestore
        .collection('users')
        .doc(currentusedId)
        .collection('transactions')
        .orderBy(
          'trans_time',
          descending: true,
        )
        .limit(10)
        .get();

    return data;
  }
}
