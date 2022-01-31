import 'package:flutter/material.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/screens/tabs/Home/home_screen.dart';
import 'package:papswap/screens/tabs/Profile/profile_screen.dart';
import 'package:papswap/screens/tabs/Search/search_screen.dart';
import 'package:papswap/screens/tabs/Wallet/wallet_screen.dart';
import 'package:papswap/services/datarepo/providers/flamespostprovider.dart';
import 'package:papswap/services/datarepo/providers/postprovider.dart';
import 'package:papswap/services/datarepo/providers/reswappostprovider.dart';
import 'package:papswap/services/datarepo/providers/rewardsprovider.dart';
import 'package:papswap/services/datarepo/providers/swappostprovider.dart';

import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex + 1 || index == _selectedIndex - 1) {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      pageController.jumpToPage(index);
    }
  }

  onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    Provider.of<UserDataProvider>(context, listen: false).userData(userData);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.black,
            ),
            label: 'Home',
            activeIcon: Icon(
              Icons.home,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_outlined,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.account_balance_wallet,
              color: Colors.black,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<SwapPostData>(
            create: (context) => SwapPostData(),
          ),
          ChangeNotifierProvider<FlamesPostData>(
            create: (context) => FlamesPostData(),
          ),
          ChangeNotifierProvider<ReswapPostData>(
            create: (context) => ReswapPostData(),
          )
        ],
        child: PageView(
          children: [
            Consumer<PostData>(
              builder: (context, postdata, _) => HomeScreen(
                postData: postdata,
              ),
            ),
            const SearchScreen(),
            Consumer<RewardData>(
              builder: (context, rewarddata, _) => WalletScreen(
                rewardData: rewarddata,
              ),
            ),
            const ProfileScreen(),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
