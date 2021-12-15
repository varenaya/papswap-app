import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Profile/reswap_feed_tile.dart';

class ReswapScreen extends StatefulWidget {
  const ReswapScreen({Key? key}) : super(key: key);

  @override
  _ReswapScreenState createState() => _ReswapScreenState();
}

class _ReswapScreenState extends State<ReswapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffColor,
        body: SafeArea(
          child: FutureBuilder<Map>(
              future: DataFetcher().getreswappostdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomProgressIndicator());
                }
                final Map? reswapostdata = snapshot.data;

                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 15,
                    )),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ReswapFeedTile(
                            commentdata: reswapostdata!['commentdata'][index],
                            postdata: reswapostdata['postdata'][index],
                          );
                        },
                        childCount: reswapostdata!['commentdata'].length,
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
