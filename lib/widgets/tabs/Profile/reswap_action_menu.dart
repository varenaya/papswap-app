import 'package:flutter/material.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/reswappostprovider.dart';
import 'package:provider/provider.dart';

class ReswapactionMenu extends StatelessWidget {
  final String commentId;
  final String postId;
  const ReswapactionMenu(
      {Key? key, required this.commentId, required this.postId})
      : super(key: key);

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
                await UploadData()
                    .deletereswap(commentId, postId, context)
                    .then((value) {
                  Navigator.pop(context, true);
                });
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              minLeadingWidth: 30,
              title: const Text(
                'Delete Reswap',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              leading: const Icon(
                Icons.delete_outline_outlined,
                color: Colors.red,
              )),
        ),
      ],
    );
  }
}
