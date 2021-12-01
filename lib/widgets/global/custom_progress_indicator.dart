import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 25.0,
      width: 25.0,
      child: CircularProgressIndicator(
        strokeWidth: 3.5,
        color: Colors.black,
      ),
    );
  }
}
