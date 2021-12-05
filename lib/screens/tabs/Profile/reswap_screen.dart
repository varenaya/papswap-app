import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';

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
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 15,
              )),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return const FeedTile();
                  },
                  childCount: 10,
                ),
              )
            ],
          ),
        ));
  }
}
