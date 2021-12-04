import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/widgets/tabs/Wallet/wallet_card.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.scaffColor,
            elevation: 0,
            title: Text(
              'transactions',
              style: Theme.of(context).textTheme.headline1,
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                )),
            bottom: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 100,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const WalletCard(),
            ),
          )
        ],
      ),
    );
  }
}
