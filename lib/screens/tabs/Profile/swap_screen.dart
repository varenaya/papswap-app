import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/providers/swappostprovider.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';

import 'package:papswap/widgets/tabs/Home/feed_tile.dart';

class SwapScreen extends StatefulWidget {
  final SwapPostData swapPostData;
  const SwapScreen({Key? key, required this.swapPostData}) : super(key: key);

  @override
  _SwapScreenState createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  final scrollController = ScrollController();

  @override
  initState() {
    scrollController.addListener(scrollListener);
    widget.swapPostData.fetchswapposts(false);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (widget.swapPostData.hasNext) {
        widget.swapPostData.fetchswapposts(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshdata() async {
      widget.swapPostData.fetchswapposts(true);
    }

    return Scaffold(
        backgroundColor: AppColors.scaffColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshdata,
            child: CustomScrollView(
              controller: scrollController,
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
                        postdata: widget.swapPostData.swapposts[index],
                      );
                    },
                    childCount: widget.swapPostData.swapposts.length,
                  ),
                ),
                SliverToBoxAdapter(
                    child: (widget.swapPostData.hasNext)
                        ? Column(
                            children: [
                              const SizedBox(height: 15),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    widget.swapPostData.fetchswapposts(false);
                                  },
                                  child: const CustomProgressIndicator(),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          )
                        : null),
              ],
            ),
          ),
        ));
  }
}
