import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/screens/tabs/Profile/likes_screen.dart';
import 'package:papswap/screens/tabs/Profile/reswap_screen.dart';
import 'package:papswap/screens/tabs/Profile/settings_screen.dart';
import 'package:papswap/screens/tabs/Profile/swap_screen.dart';
import 'package:papswap/widgets/tabs/Profile/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.scaffColor,
        title: const Text(
          'profile',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(PageTransition(
                    child: const SettingScreen(),
                    type: PageTransitionType.fade));
              },
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const ProfileHeader(),
                    ],
                  ),
                ),
              ];
            },
            body: Column(
              children: const [
                Material(
                  color: AppColors.scaffColor,
                  child: TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorWeight: 1,
                    indicatorColor: Colors.blue,
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: [
                      Tab(
                        text: 'Sawp',
                      ),
                      Tab(
                        text: 'Reswap',
                      ),
                      Tab(
                        text: 'Likes',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SwapScreen(),
                      ReswapScreen(),
                      LikesScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
