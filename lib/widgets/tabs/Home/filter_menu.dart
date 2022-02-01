import 'package:flutter/material.dart';

class FilterMenu extends StatefulWidget {
  final List categories;
  const FilterMenu({Key? key, required this.categories}) : super(key: key);

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
          ...widget.categories
              .map(
                (e) => ListTile(
                    onTap: () async {},
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 24.0),
                    minLeadingWidth: 30,
                    title: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    leading: const Icon(Icons.arrow_right_alt_rounded)),
              )
              .toList(),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
