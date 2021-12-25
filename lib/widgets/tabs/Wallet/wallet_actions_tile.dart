// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/screens/tabs/Wallet/superToken/super_token_screen.dart';
import 'package:papswap/screens/tabs/Wallet/token_earning_screen.dart';

class WalletActionsTile extends StatelessWidget {
  final Size size;
  final String imagepath;
  final String title;
  final String subtitle;
  final String footerText;
  final String buttonText;
  final showad;
  const WalletActionsTile({
    Key? key,
    required this.size,
    required this.imagepath,
    required this.title,
    required this.subtitle,
    required this.footerText,
    required this.buttonText,
    this.showad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void earnNowfn() {
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        backgroundColor: AppColors.scaffColor,
        context: context,
        builder: (context) => TokenEarningScreen(
          showad: showad,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
        width: size.width * 0.44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    context: context,
                    builder: (context) => Wrap(
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
                        if (title == 'Earn PapTokens')
                          const Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Image(
                                  image: AssetImage('assets/images/coin.png'),
                                  height: 90,
                                ),
                              )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: title == 'SuperTokens'
                              ? RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: 'SuperTokens',
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        color: Colors.indigo.shade900,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                      children: const [
                                        TextSpan(
                                          text:
                                              ' are the exclusive tokens , that are dedicated to some inspiring and famous celebrities of nation . These tokens can be earned by the user by veryfying their data with the company , which will give user Rs 500 , which can be donated for nation building .',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Poppins'),
                                        )
                                      ]))
                              : const Text(
                                  'As Papswap is rewarding in nature , the user earns Paptokens for the time and data they spend on the app. Paptokens can be redeemed for various gifts and movie tickets by the users .',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            Image(
              image: AssetImage(imagepath),
              height: size.height * 0.085,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              footerText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: buttonText == 'Earn Now'
                      ? earnNowfn
                      : () {
                          Navigator.of(context).push(PageTransition(
                            child: const SuperTokenScreen(),
                            type: PageTransitionType.leftToRightWithFade,
                          ));
                        },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
