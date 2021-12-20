import 'package:flutter/material.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';

import 'package:papswap/widgets/tabs/Wallet/token_eraning_tile.dart';
import 'package:provider/provider.dart';

class TokenEarningScreen extends StatelessWidget {
  final Function() showad;
  const TokenEarningScreen({Key? key, required this.showad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final userdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 8),
          child: Center(
            child: Container(
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[350],
              ),
            ),
          ),
        ),
        TokenEarningTile(
          actionfn: () async {
            final msg = await UploadData()
                .updatedailybonus(userdata.dailyrewardTimestamp);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  msg!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                backgroundColor: msg == 'You claimed a daily bonus!'
                    ? Colors.blue
                    : Theme.of(context).errorColor,
              ),
            );
          },
          title: 'Daily Bonus',
          size: size,
          subtitle1: 'Earn a PapToken daily! Just open the app everyday, ',
          subtitle2: 'claim 1 PapToken every 24 hrs',
          buttontext: 'Claim',
          imagepath: 'assets/images/daily bonus.png',
        ),
        TokenEarningTile(
          actionfn: () async {
            final msg = await UploadData()
                .updateweeklybonus(userdata.weeklyrewardTimestamp);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  msg!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
                backgroundColor: msg == 'You claimed a weekly bonus!'
                    ? Colors.blue
                    : Theme.of(context).errorColor,
              ),
            );
          },
          title: 'Weekly Bonus',
          size: size,
          subtitle1: 'Earn upto 5 PapTokens weekly,',
          subtitle2: ' claim 5 PapTokens on sundays',
          buttontext: 'Claim',
          imagepath: 'assets/images/weekly bonus.png',
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TokenEarningTile(
            actionfn: () => showad(),
            title: 'Video Bonus',
            size: size,
            subtitle1: 'Watch video ads to earn, ',
            subtitle2: 'upto 10 PapTokens',
            buttontext: 'Watch Now',
            imagepath: 'assets/images/video bonus.png',
          ),
        ),
      ],
    );
  }
}
