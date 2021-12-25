import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Wallet/super_token_tile.dart';

class AllSuperTokensScreen extends StatelessWidget {
  const AllSuperTokensScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      body: SafeArea(
        child: PaginateFirestore(
          initialLoader: const Center(
            child: CustomProgressIndicator(),
          ),
          itemBuilderType:
              PaginateBuilderType.listView, //Change types accordingly
          itemBuilder: (context, documentSnapshots, index) {
            final tokendata = documentSnapshots[index].data() as Map;
            return SuperTokenTile(
              tokendata: tokendata,
            );
          },

          bottomLoader: const SizedBox(
              height: 50, child: Center(child: CustomProgressIndicator())),
          query: DataFetcher().allsuperTokens(),
        ),
      ),
    );
  }
}
