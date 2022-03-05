import 'package:flutter/material.dart';
import 'package:papswap/widgets/tabs/Home/filter_tile.dart';

class FilterMenu extends StatefulWidget {
  final List categories;
  final String selectedcategory;
  const FilterMenu(
      {Key? key, required this.categories, required this.selectedcategory})
      : super(key: key);

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
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
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 10,
            ),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          ...widget.categories.map((e) {
            return FilterTile(
              ministry: e,
              isselcted: e == widget.selectedcategory,
            );
          }).toList(),
        ],
      ),
    );
  }
}
