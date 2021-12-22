import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/screens/tabs/Wallet/superToken/all_supertokens_screen.dart';
import 'package:papswap/screens/tabs/Wallet/superToken/my_supertoken_screen.dart';

class SuperTokenScreen extends StatefulWidget {
  const SuperTokenScreen({Key? key}) : super(key: key);

  @override
  _SuperTokenScreenState createState() => _SuperTokenScreenState();
}

class _SuperTokenScreenState extends State<SuperTokenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.scaffColor,
        title: Text(
          'SuperTokens',
          style: Theme.of(context).textTheme.headline1,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: const [
            Material(
              color: AppColors.scaffColor,
              child: TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 1,
                indicatorColor: Colors.blue,
                labelStyle: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                tabs: [
                  Tab(
                    text: 'My SuperTokens',
                  ),
                  Tab(
                    text: 'All SuperTokens',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MySuperTokenScreen(),
                  AllSuperTokensScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
