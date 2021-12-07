import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:papswap/models/userdata.dart';

class WalletCard extends StatelessWidget {
  final UserData userData;
  const WalletCard({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: [
              Colors.lightBlue.shade100,
              Colors.lightBlue.shade300,
              Colors.indigo
            ])),
        child: Center(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
            title: RichText(
                text: TextSpan(
                    text:
                        NumberFormat.decimalPattern().format(userData.coinVal),
                    style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontFamily: 'Poppins'),
                    children: const [
                  TextSpan(
                      text: '   paptokens',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Poppins'))
                ])),
            subtitle: const Text('Current Balance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                )),
            trailing: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
