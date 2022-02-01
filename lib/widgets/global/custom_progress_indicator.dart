import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color color;
  final double? value;
  const CustomProgressIndicator(
      {Key? key, this.color = Colors.blue, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.0,
      width: 25.0,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}
