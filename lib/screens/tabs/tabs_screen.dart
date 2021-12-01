import 'package:flutter/material.dart';
import 'package:papswap/screens/tabs/Home/home_screen.dart';
import 'package:papswap/screens/tabs/Profile/profile_screen.dart';
import 'package:papswap/screens/tabs/Search/search_screen.dart';
import 'package:papswap/screens/tabs/Wallet/wallet_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
      body: _screens[_selectedIndex],
    );
  }
}
