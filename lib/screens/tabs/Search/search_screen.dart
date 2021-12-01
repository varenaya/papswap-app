import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      body: const Center(
        child: Text('Search'),
      ),
    );
  }
}
