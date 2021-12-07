import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:papswap/models/userdata.dart';

class DataFetcher {
  final _firestore = FirebaseFirestore.instance;

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

      final createrdata = await getcraterdata(createrid);
      createrdatalist.add(createrdata);
    }
    return {'postdata': postdatalist, 'createrdata': createrdatalist};
  }

  Future<Map> individualpostdata(String postId) async {
    UserData? createrdata;
    final postdata = await _firestore.doc(postId).get();

    final createrid = postdata.data()!['createrid'];

    createrdata = await getcraterdata(createrid);

    return {'postdata': postdata, 'createrdata': createrdata};
  }
}
