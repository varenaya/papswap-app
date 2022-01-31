import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
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
        adUnitId: AdHelper.rewardedAdunitId,
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
    final userdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      body: SafeArea(
        child: PaginateFirestore(
          initialLoader: const Center(
            child: CustomProgressIndicator(),
          ),
          header: SliverAppBar(
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
          itemBuilderType:
              PaginateBuilderType.listView, //Change types accordingly
          itemBuilder: (context, documentSnapshots, index) {
            final transdata = documentSnapshots[index].data() as Map?;
            return TransactionTile(
              transadata: transdata,
            );
          },

          bottomLoader: const SizedBox(
              height: 50, child: Center(child: CustomProgressIndicator())),
          query: DataFetcher().gettransactiondata(),
          isLive: true,
        ),
      ),
    );
  }
}
