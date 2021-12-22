import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/providers/flamespostprovider.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';

class FlamesScreen extends StatefulWidget {
  final FlamesPostData flamesPostData;
  const FlamesScreen({Key? key, required this.flamesPostData})
      : super(key: key);

  @override
  _FlamesScreenState createState() => _FlamesScreenState();
}

class _FlamesScreenState extends State<FlamesScreen> {
  final scrollController = ScrollController();

  @override
  initState() {
    scrollController.addListener(scrollListener);
    widget.flamesPostData.fetchflamesposts(false);

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
      if (widget.flamesPostData.hasNext) {
        widget.flamesPostData.fetchflamesposts(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshdata() async {
      widget.flamesPostData.fetchflamesposts(true);
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
                      return FeedTile(
                        type: 'flame',
                        postdata: widget.flamesPostData.flamesposts[index],
                      );
                    },
                    childCount: widget.flamesPostData.flamesposts.length,
                  ),
                ),
                SliverToBoxAdapter(
                    child: (widget.flamesPostData.hasNext)
                        ? Column(
                            children: [
                              const SizedBox(height: 15),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    widget.flamesPostData
                                        .fetchflamesposts(false);
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
