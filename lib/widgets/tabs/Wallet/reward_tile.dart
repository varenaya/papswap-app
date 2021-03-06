import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:papswap/widgets/tabs/Wallet/rewards_menu.dart';

class RewardTile extends StatelessWidget {
  final Map rewarddata;

  const RewardTile({
    Key? key,
    required this.rewarddata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            context: context,
            builder: (context) => RewardsMenu(
              rewarddata: rewarddata,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rewarddata['rewardName'],
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              RichText(
                  text: TextSpan(
                      text: rewarddata['cost'].toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.black),
                      children: const [
                    TextSpan(
                        text: ' PapTokens',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Colors.black))
                  ])),
              const SizedBox(
                height: 10,
              ),
              CachedNetworkImage(
                key: UniqueKey(),
                imageUrl: rewarddata['rewardMedia'],
                placeholder: (context, url) => Container(
                  height: 180,
                  color: Colors.black12,
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
