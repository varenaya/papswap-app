import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffColor,
      body: const Center(
        child: Text('wallet'),
      ),
    );
  }
}
