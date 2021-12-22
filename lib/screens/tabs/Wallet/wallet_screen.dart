import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/screens/tabs/Wallet/transactions_screen.dart';
import 'package:papswap/services/adservice/ad_helper.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Wallet/movie_tile.dart';
import 'package:papswap/widgets/tabs/Wallet/reward_tile.dart';
import 'package:papswap/widgets/tabs/Wallet/voucher_tile.dart';
import 'package:papswap/widgets/tabs/Wallet/wallet_actions_tile.dart';
import 'package:papswap/widgets/tabs/Wallet/wallet_card.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final DataFetcher dataFetcher = DataFetcher();
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
      UploadData().updatevideobonus(context);
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
    final Size size = MediaQuery.of(context).size;
    final userData = Provider.of<UserData>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.scaffColor,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
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
                    title: WalletCard(
                      showadfn: _showRewardedAd,
                      userData: userData,
                    ),
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
                                  'values upto 500 INR for every SuperTokens',
                              buttonText: 'Check Now',
                              imagepath: 'assets/images/supertoken.png',
                            ),
                            WalletActionsTile(
                              showad: () => _showRewardedAd(),
                              size: size,
                              title: 'Earn PapTokens',
                              subtitle:
                                  'Earn PapTokens daily with bonus and through swaps.',
                              footerText: 'upto 20 PapTokens every week',
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
              ];
            },
            body: FutureBuilder<
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                future: dataFetcher.rewardlist(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CustomProgressIndicator(),
                    );
                  }
                  final rewardata = snapshot.data;

                  return CustomScrollView(
                    slivers: [
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return RewardTile(
                            rewarddata: rewardata![index].data(),
                          );
                        },
                        childCount: rewardata!.length,
                      )),
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                            FutureBuilder<
                                    List<
                                        QueryDocumentSnapshot<
                                            Map<String, dynamic>>>>(
                                future: dataFetcher.movieslist(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CustomProgressIndicator(),
                                    );
                                  }
                                  final moviedata = snapshot.data;
                                  return SizedBox(
                                    height: size.height * 0.56,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: moviedata!.length,
                                      itemBuilder: (context, index) {
                                        return MovieTile(
                                          size: size,
                                          moviedata: moviedata[index].data(),
                                        );
                                      },
                                    ),
                                  );
                                }),
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
                            FutureBuilder<
                                    List<
                                        QueryDocumentSnapshot<
                                            Map<String, dynamic>>>>(
                                future: dataFetcher.voucherslist(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CustomProgressIndicator(),
                                    );
                                  }
                                  final voucherdata = snapshot.data;
                                  return SizedBox(
                                    height: size.height * 0.42,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: voucherdata!.length,
                                      itemBuilder: (context, index) {
                                        return VoucherTile(
                                            voucherdata:
                                                voucherdata[index].data(),
                                            size: size);
                                      },
                                    ),
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  );
                }),
          ),
        ));
  }
}
