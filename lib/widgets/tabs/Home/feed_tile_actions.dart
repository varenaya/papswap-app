import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/screens/tabs/Home/report_screen.dart';

class FeedTileAction extends StatelessWidget {
  final postdata;
  const FeedTileAction({Key? key, required this.postdata}) : super(key: key);

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
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: ListTile(
            onTap: () async {
              Navigator.pop(context);
              Navigator.of(context).push(
                PageTransition(
                    child: ReportScreen(
                      post: postdata,
                    ),
                    type: PageTransitionType.leftToRightWithFade),
              );
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            minLeadingWidth: 30,
            title: const Text(
              'Report Post',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            leading: const Icon(
              Icons.report_outlined,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
