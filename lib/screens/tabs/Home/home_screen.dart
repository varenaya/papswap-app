import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/app/color_const.dart';

import 'package:papswap/models/userdata.dart';
import 'package:papswap/screens/tabs/Home/posting_screen.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/services/datarepo/providers/postprovider.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';

import 'package:papswap/widgets/tabs/Home/feed_tile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final PostData postData;
  const HomeScreen({Key? key, required this.postData}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataFetcher dataFetcher = DataFetcher();
  final scrollController = ScrollController();

  @override
  initState() {
    scrollController.addListener(scrollListener);
    widget.postData.fetchNextposts(false);
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
      if (widget.postData.hasNext) {
        widget.postData.fetchNextposts(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    Future<void> _refreshPostdata() async {
      widget.postData.fetchNextposts(true);
    }

    return Scaffold(
        backgroundColor: AppColors.scaffColor,
        floatingActionButton: userData.userType == 'viewer'
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  Navigator.of(context).push(PageTransition(
                      child: const PostingScreen(
                        type: 'Post',
                      ),
                      type: PageTransitionType.bottomToTop));
                },
                child: const Icon(
                  Icons.add,
                  size: 26,
                  color: Colors.white,
                ),
              ),
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: _refreshPostdata,
          child: CustomScrollView(
            key: const PageStorageKey('home'),
            controller: scrollController,
            slivers: [
              SliverAppBar(
                elevation: 0,
                stretch: true,
                floating: true,
                backgroundColor: AppColors.scaffColor,
                title: RichText(
                  text: const TextSpan(
                    text: 'PAP',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'S',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 7),
                          child: Image(
                            image: AssetImage('assets/images/W_tilted.png'),
                            height: 18,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: 'AP',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {
                        const _url = 'https://papswap.in/';
                        if (!await launch(_url)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Could not launch $_url',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.black,
                      )),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 4),
                      child: Text(
                        'trending',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return FeedTile(
                      type: 'feed', postdata: widget.postData.posts[index]);
                },
                childCount: widget.postData.posts.length,
              )),
              SliverToBoxAdapter(
                  child: (widget.postData.hasNext)
                      ? Column(
                          children: [
                            const SizedBox(height: 15),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  widget.postData.fetchNextposts(false);
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
        )));
  }
}
