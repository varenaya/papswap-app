import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color color;
  const CustomProgressIndicator({Key? key, this.color = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.0,
      width: 25.0,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}
