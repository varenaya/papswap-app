import 'package:flutter/material.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/screens/tabs/Home/home_screen.dart';
import 'package:papswap/screens/tabs/Profile/profile_screen.dart';
import 'package:papswap/screens/tabs/Search/search_screen.dart';
import 'package:papswap/screens/tabs/Wallet/wallet_screen.dart';
import 'package:papswap/services/datarepo/postData.dart';
import 'package:papswap/services/datarepo/userData.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  var _isInit = true;
  var _isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    // SearchScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<PostDataListProvider>(context).postData().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.search_outlined,
          //     color: Colors.black,
          //   ),
          //   activeIcon: Icon(
          //     Icons.search,
          //     color: Colors.black,
          //   ),
          //   label: 'Search',
          // ),
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
      body: _isLoading
          ? const Center(child: CustomProgressIndicator())
          : _screens[_selectedIndex],
    );
  }
}
