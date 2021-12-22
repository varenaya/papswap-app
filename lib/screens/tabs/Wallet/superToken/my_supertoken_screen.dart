import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/Api/data_fetcher.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Wallet/super_token_tile.dart';

class MySuperTokenScreen extends StatelessWidget {
  const MySuperTokenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: DataFetcher().mysuperTokens(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomProgressIndicator());
              }
              final data = snapshot.data!.docs;
              if (data.isEmpty) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.error_outline_outlined,
                              size: 30,
                              color: Colors.red,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'You haven\'t earned any SuperTokens yet. Keep swapping!',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return SuperTokenTile(tokendata: data[index].data());
                      },
                      childCount: data.length,
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
