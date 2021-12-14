import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/services/datarepo/data_fetcher.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';
import 'package:provider/provider.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);

  @override
  _SwapScreenState createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Scaffold(
        backgroundColor: AppColors.scaffColor,
        body: SafeArea(
          child: FutureBuilder<List>(
              future:
                  DataFetcher().getprofilepostdata(userData.user_id, 'swaps'),
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
                            type: 'swap',
                            postdata: swappostlist![index]['postdata'].data(),
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
