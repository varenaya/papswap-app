import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/services/datarepo/data_fetcher.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';
import 'package:provider/provider.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Scaffold(
        backgroundColor: AppColors.scaffColor,
        body: SafeArea(
          child: FutureBuilder<List>(
              future:
                  DataFetcher().getprofilepostdata(userData.user_id, 'likes'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomProgressIndicator());
                }

                final List? swappostlist = snapshot.data;

                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 15,
                    )),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return FeedTile(
                            type: 'like',
                            postdata: swappostlist![index]['postdata'].data(),
                            createrdata: swappostlist[index]['createrdata'],
                          );
                        },
                        childCount: swappostlist!.length,
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
