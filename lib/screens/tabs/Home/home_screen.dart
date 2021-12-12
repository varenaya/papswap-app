import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/screens/tabs/Home/posting_screen.dart';
import 'package:papswap/services/datarepo/postData.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    Future<void> _refreshPostdata() async {
      Provider.of<PostDataListProvider>(context, listen: false).postData();
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
            child: Consumer<PostDataListProvider>(
              builder: (ctx, postdata, _) => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    floating: true,
                    backgroundColor: AppColors.scaffColor,
                    title: Text(
                      'papswap',
                      style: Theme.of(context).textTheme.headline1,
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
                          type: 'feed',
                          ispostliked: postdata.postdata?.ispostliked[index],
                          postdata: postdata.postdata?.postdata[index]?.data(),
                          createrdata:
                              postdata.postdata!.createrdatalist[index],
                        );
                      },
                      childCount: postdata.postdata?.postdata.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
