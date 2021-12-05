import 'package:flutter/material.dart';

class SwapMenu extends StatelessWidget {
  const SwapMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ListTile(
            onTap: () {},
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            minLeadingWidth: 30,
            title: const Text(
              'Swap',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            leading: const Icon(Icons.arrow_right_alt_rounded)),
        ListTile(
          onTap: () {},
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          minLeadingWidth: 30,
          leading: const Icon(Icons.swap_horiz_rounded),
          title: const Text(
            'Reswap',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
