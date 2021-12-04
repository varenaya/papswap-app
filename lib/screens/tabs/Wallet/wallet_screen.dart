import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/screens/tabs/Wallet/transactions_screen.dart';
import 'package:papswap/widgets/tabs/Wallet/movie_tile.dart';
import 'package:papswap/widgets/tabs/Wallet/reward_tile.dart';
import 'package:papswap/widgets/tabs/Wallet/voucher_tile.dart';
import 'package:papswap/widgets/tabs/Wallet/wallet_actions_tile.dart';
import 'package:papswap/widgets/tabs/Wallet/wallet_card.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
                  'account overview',
                  style: Theme.of(context).textTheme.headline1,
                ),
                actions: [
                  IconButton(
                      tooltip: 'Wallet log',
                      onPressed: () {
                        Navigator.of(context).push(PageTransition(
                            child: const TransactionsScreen(),
                            type: PageTransitionType.topToBottom));
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                        size: 28,
                      )),
                ],
                bottom: AppBar(
                  toolbarHeight: 100,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: const WalletCard(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WalletActionsTile(
                            size: size,
                            title: 'SuperTokens',
                            subtitle:
                                'SuperTokens can only be earned after the content verification.',
                            footerText:
                                'values upto 500 INR for every SuperCoin',
                            buttonText: 'Check Now',
                            imagepath: 'assets/images/supertoken.png',
                          ),
                          WalletActionsTile(
                            size: size,
                            title: 'Earn PapTokens',
                            subtitle:
                                'Earn PapTokens daily with bonus and through swaps.',
                            footerText: 'upto 25 PapTokens every week',
                            buttonText: 'Earn Now',
                            imagepath: 'assets/images/paptoken.png',
                          ),
                        ],
                      ),
                      Text(
                        'Claim Rewards',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.indigo.shade900,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'New Offers',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return const RewardTile(
                        title: 'NewsPaper Subscription',
                        cost: '500',
                        imageUrl:
                            'https://www.savethestudent.org/uploads/UK-newspapers-spread-out-tabloid-broadsheet.jpg',
                        buttonText: 'Buy Subscription');
                  },
                  childCount: 2,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: Text(
                        'Movies',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.56,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return MovieTile(
                            size: size,
                            title: 'Eternals',
                            cost: '100',
                            imageUrl:
                                'https://m.media-amazon.com/images/M/MV5BMTExZmVjY2ItYTAzYi00MDdlLWFlOWItNTJhMDRjMzQ5ZGY0XkEyXkFqcGdeQXVyODIyOTEyMzY@._V1_.jpg',
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: Text(
                        'Vouchers',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return VoucherTile(
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/papswap-test.appspot.com/o/Screenshot%202021-12-04%20125824.png?alt=media&token=2682708b-1d49-428e-9741-991270cb302e',
                              title: 'Jamies',
                              voucherText: 'Get upto 15% off',
                              cost: '75',
                              size: size);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
