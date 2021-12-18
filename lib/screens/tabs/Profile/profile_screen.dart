import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/screens/tabs/Profile/likes_screen.dart';
import 'package:papswap/screens/tabs/Profile/reswap_screen.dart';
import 'package:papswap/screens/tabs/Profile/settings_screen.dart';
import 'package:papswap/screens/tabs/Profile/swap_screen.dart';
import 'package:papswap/services/datarepo/providers/likespostprovider.dart';
import 'package:papswap/services/datarepo/providers/reswappostprovider.dart';
import 'package:papswap/services/datarepo/providers/swappostprovider.dart';
import 'package:papswap/widgets/tabs/Profile/profile_header.dart';
import 'package:provider/provider.dart';

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
        title: Text(
          'your profile',
          style: Theme.of(context).textTheme.headline1,
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
            key: const PageStorageKey('profile'),
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
              children: [
                const Material(
                  color: AppColors.scaffColor,
                  child: TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorWeight: 1,
                    indicatorColor: Colors.blue,
                    labelStyle: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                    tabs: [
                      Tab(
                        text: 'Swap',
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
                      Consumer<SwapPostData>(
                          builder: (context, swappostdata, _) => SwapScreen(
                                swapPostData: swappostdata,
                              )),
                      Consumer<ReswapPostData>(
                          builder: (context, reswappostdata, _) => ReswapScreen(
                                reswapPostData: reswappostdata,
                              )),
                      Consumer<LikesPostData>(
                          builder: (context, likespostdata, _) => LikesScreen(
                                likesPostData: likespostdata,
                              )),
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
