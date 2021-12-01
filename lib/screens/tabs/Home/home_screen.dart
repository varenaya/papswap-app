import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add,
            size: 26,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                floating: true,
                backgroundColor: AppColors.scaffColor,
                title: const Text(
                  'papswap',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      )),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, bottom: 4),
                      child: Text(
                        'trending',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
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
