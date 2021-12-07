import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/userData.dart';
import 'package:papswap/widgets/tabs/Wallet/wallet_card.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      body: SafeArea(
        child: CustomScrollView(
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
                    Icons.close,
                    color: Colors.black,
                  )),
              bottom: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 100,
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: WalletCard(
                  userData: userdata,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
