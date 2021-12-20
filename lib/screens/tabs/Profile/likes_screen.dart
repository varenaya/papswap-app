import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/providers/likespostprovider.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';

class LikesScreen extends StatefulWidget {
  final LikesPostData likesPostData;
  const LikesScreen({Key? key, required this.likesPostData}) : super(key: key);

  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  final scrollController = ScrollController();

  @override
  initState() {
    scrollController.addListener(scrollListener);
    widget.likesPostData.fetchlikesposts(false);

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
      if (widget.likesPostData.hasNext) {
        widget.likesPostData.fetchlikesposts(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshdata() async {
      widget.likesPostData.fetchlikesposts(true);
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
                        type: 'like',
                        postdata: widget.likesPostData.likesposts[index],
                      );
                    },
                    childCount: widget.likesPostData.likesposts.length,
                  ),
                ),
                SliverToBoxAdapter(
                    child: (widget.likesPostData.hasNext)
                        ? Column(
                            children: [
                              const SizedBox(height: 15),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    widget.likesPostData.fetchlikesposts(false);
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
