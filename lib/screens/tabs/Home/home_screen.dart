import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/screens/tabs/Home/posting_screen.dart';
import 'package:papswap/services/datarepo/data_fetcher.dart';
import 'package:papswap/services/datarepo/userData.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Map? _postdata;
    final userData = Provider.of<UserData>(context);
    Provider.of<UserDataProvider>(context, listen: false).userData(userData);
    Future<void> _initPostdata() async {
      final postdata = await DataFetcher().postdata();
      _postdata = postdata;
    }

    Future<void> _refreshPostdata() async {
      final postdata = await DataFetcher().postdata();
      setState(() {
        _postdata = postdata;
      });
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
          child: FutureBuilder(
              future: _initPostdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomProgressIndicator());
                }

                final postdata = _postdata!['postdata'].docs;
                final createrdata = _postdata!['createrdata'];

                return RefreshIndicator(
                  onRefresh: _refreshPostdata,
                  child: CustomScrollView(
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
                              onPressed: () {},
                              icon: const Icon(
                                Icons.filter_list_outlined,
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
                              padding:
                                  const EdgeInsets.only(left: 15.0, bottom: 4),
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
                              postdata: postdata[index].data(),
                              createrdata: createrdata[index],
                            );
                          },
                          childCount: postdata.length,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
}
