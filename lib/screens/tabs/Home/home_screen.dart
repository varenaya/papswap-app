import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/models/post.dart';

import 'package:papswap/models/userdata.dart';
import 'package:papswap/screens/tabs/Home/posting_screen.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/services/datarepo/providers/postprovider.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';

import 'package:papswap/widgets/tabs/Home/feed_tile.dart';
import 'package:papswap/widgets/tabs/Home/filter_menu.dart';
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
  List categories = [];

  @override
  initState() {
    getcategories();
    scrollController.addListener(scrollListener);
    widget.postData.fetchNextposts(false);
    super.initState();
  }

  getcategories() async {
    final data = await DataFetcher().categories();
    categories = data.data()!['categories'];
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

    return widget.postData.selectedcategory == ''
        ? Scaffold(
            backgroundColor: AppColors.scaffColor,
            floatingActionButton: userData.userType == 'viewer'
                ? null
                : FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () {
                      Navigator.of(context).push(PageTransition(
                          child: PostingScreen(
                            type: 'Post',
                            categories: categories,
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
                                  image:
                                      AssetImage('assets/images/W_tilted.png'),
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
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                              ),
                              context: context,
                              builder: (context) {
                                return FilterMenu(
                                  categories: categories,
                                  selectedcategory:
                                      widget.postData.selectedcategory,
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () async {
                        //     await FirebaseFirestore.instance
                        //         .collection('users')
                        //         .get()
                        //         .then((value) {
                        //       return value.docs.forEach((element) {
                        //         var docRef = FirebaseFirestore.instance
                        //             .collection('users')
                        //             .doc(element.id);

                        //         docRef.update({
                        //           'adrewards': 0,
                        //         });
                        //       });
                        //     });
                        //   },
                        //   icon: Icon(
                        //     Icons.add,
                        //     color: Colors.black,
                        //     size: 30,
                        //   ),
                        // ),
                        IconButton(
                            onPressed: () async {
                              const _url = 'https://papswap.in/';
                              if (!await canLaunch(_url)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Could not launch $_url',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                  ),
                                );
                              } else {
                                launch(_url);
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
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 4),
                            child: Text(
                              'trending',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return FeedTile(
                              type: 'feed',
                              postdata: widget.postData.posts[index]);
                        },
                        childCount: widget.postData.posts.length,
                      ),
                    ),
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
              ),
            ),
          )
        : Scaffold(
            backgroundColor: AppColors.scaffColor,
            appBar: AppBar(
              elevation: 0,
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
                const SizedBox(width: 10),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.postData.selectedcategory == ''
                            ? showModalBottomSheet(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                context: context,
                                builder: (context) {
                                  return FilterMenu(
                                    categories: categories,
                                    selectedcategory:
                                        widget.postData.selectedcategory,
                                  );
                                },
                              )
                            : (widget.postData.selectedcategoryactions(
                                widget.postData.selectedcategory,
                                false,
                                context));
                      },
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    widget.postData.selectedcategory == ''
                        ? const SizedBox()
                        : const Positioned(
                            right: 5,
                            top: 10,
                            child: CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.blue,
                            ),
                          ),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      const _url = 'https://papswap.in/';
                      if (!await canLaunch(_url)) {
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
                      } else {
                        launch(_url);
                      }
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    )),
              ],
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: Text(
                      'showing posts of ${widget.postData.selectedcategory}.',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.indigo.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: PaginateFirestore(
                      itemBuilder: (context, documentSnapshots, index) {
                        final postdata = documentSnapshots
                            .map((doc) => Post.fromDoc(doc))
                            .toList();
                        return FeedTile(
                            postdata: postdata[index], type: 'feed');
                      },
                      query: dataFetcher
                          .filtercategories(widget.postData.selectedcategory),
                      initialLoader: const Center(
                        child: CustomProgressIndicator(),
                      ),
                      itemsPerPage: 7,
                      onEmpty: const Center(child: Text('No posts found!')),
                      itemBuilderType: PaginateBuilderType.listView,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
