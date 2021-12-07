import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/screens/tabs/Home/posting_screen.dart';
import 'package:papswap/services/datarepo/uplaod_data.dart';

class SwapMenu extends StatelessWidget {
  final Map postdata;

  final UserData createrdata;

  final String currentuserid;
  const SwapMenu(
      {Key? key,
      required this.currentuserid,
      required this.postdata,
      required this.createrdata})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postId = postdata['post_id'];
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
            onTap: () {
              UploadData().postswap(postId, currentuserid).then((value) {
                Navigator.of(context).pop();
              });
            },
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
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(PageTransition(
                child: PostingScreen(
                  type: 'Reswap',
                  reswapcreaterdata: createrdata,
                  reswappostdata: postdata,
                ),
                type: PageTransitionType.bottomToTop));
          },
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
