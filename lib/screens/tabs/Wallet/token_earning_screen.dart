import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/widgets/tabs/Wallet/token_eraning_tile.dart';

class TokenEarningScreen extends StatefulWidget {
  const TokenEarningScreen({Key? key}) : super(key: key);

  @override
  _TokenEarningScreenState createState() => _TokenEarningScreenState();
}

class _TokenEarningScreenState extends State<TokenEarningScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
          title: 'Daily Bonus',
          size: size,
          subtitle1: 'Earn a PapToken daily! Just open the app everyday, ',
          subtitle2: 'claim 1 PapToken daily',
          buttontext: 'Claim',
          imagepath: 'assets/images/daily bonus.png',
        ),
        TokenEarningTile(
          title: 'Weekly Bonus',
          size: size,
          subtitle1: 'Earn upto 25 PapTokens weekly,',
          subtitle2:
              ' claim 15 PapTokens on sundays and 10 Paptokens on wednesdays',
          buttontext: 'Claim',
          imagepath: 'assets/images/weekly bonus.png',
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: TokenEarningTile(
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
