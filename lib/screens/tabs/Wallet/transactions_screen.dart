import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Wallet/transaction_tile.dart';
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
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: DataFetcher().gettransactiondata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomProgressIndicator());
              }
              final transdata = snapshot.data!.docs;
              if (!snapshot.hasData) {
                return CustomScrollView(
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
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 10,
                          ),
                          Text('No Transactions yet...'),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return CustomScrollView(
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
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'HISTORY',
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                'TOKENS',
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return TransactionTile(
                          transadata: transdata[index].data(),
                        );
                      },
                      childCount: transdata.length,
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
