import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({Key? key}) : super(key: key);

  @override
  _SwapScreenState createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 15,
              )),
              // SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //     (context, index) {
              //       return const FeedTile(
              //         postdata: {},
              //       );
              //     },
              //     childCount: 10,
              //   ),
              // )
            ],
          ),
        ));
  }
}
