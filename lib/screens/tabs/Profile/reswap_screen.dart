import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/providers/reswappostprovider.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Profile/reswap_feed_tile.dart';

class ReswapScreen extends StatefulWidget {
  final ReswapPostData reswapPostData;
  const ReswapScreen({Key? key, required this.reswapPostData})
      : super(key: key);

  @override
  _ReswapScreenState createState() => _ReswapScreenState();
}

class _ReswapScreenState extends State<ReswapScreen> {
  final scrollController = ScrollController();

  @override
  initState() {
    scrollController.addListener(scrollListener);
    widget.reswapPostData.fetchreswapposts(false);

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
      if (widget.reswapPostData.hasNext) {
        widget.reswapPostData.fetchreswapposts(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshdata() async {
      widget.reswapPostData.fetchreswapposts(true);
    }

    return Scaffold(
        backgroundColor: AppColors.scaffColor,
        body: RefreshIndicator(
          onRefresh: _refreshdata,
          child: SafeArea(
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
                      return ReswapFeedTile(
                        reswapPost: widget.reswapPostData.reswapposts[index],
                      );
                    },
                    childCount: widget.reswapPostData.reswapposts.length,
                  ),
                ),
                SliverToBoxAdapter(
                    child: (widget.reswapPostData.hasNext)
                        ? Column(
                            children: [
                              const SizedBox(height: 15),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    widget.reswapPostData
                                        .fetchreswapposts(false);
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
