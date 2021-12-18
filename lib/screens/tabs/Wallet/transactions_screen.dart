import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/adservice/ad_helper.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Wallet/transaction_tile.dart';
import 'package:papswap/widgets/tabs/Wallet/wallet_card.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
        adUnitId: RewardedAd.testAdUnitId,
        request: AdHelper.adrequest,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd = null;
          },
        ));
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to load Ad, Try again later!',
            style: TextStyle(fontFamily: 'Poppins'),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'An error occured, Try again later!',
              style: TextStyle(fontFamily: 'Poppins'),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Congratulations, You earned a PapToken!',
            style: TextStyle(fontFamily: 'Poppins'),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.blue,
        ),
      );
      UploadData().updatevideobonus();
    });
    _rewardedAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: DataFetcher().gettransactiondata(10),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomProgressIndicator());
              }
              final transdata = snapshot.data!.docs;
              if (transdata.isEmpty) {
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
                          showadfn: _showRewardedAd,
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
                        showadfn: _showRewardedAd,
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
