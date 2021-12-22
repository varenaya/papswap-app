import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:papswap/models/reswappost.dart';
import 'package:papswap/services/datarepo/providers/reswappostprovider.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';
import 'package:papswap/widgets/tabs/Home/video_player.dart';
import 'package:papswap/widgets/tabs/Profile/reswap_action_menu.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReswapFeedTile extends StatelessWidget {
  final ReswapPost reswapPost;

  const ReswapFeedTile({
    Key? key,
    required this.reswapPost,
  }) : super(key: key);

  String timeDuration() {
    final timedif = (DateTime.now()).difference(reswapPost.createdAt.toDate());

    final printedduration = printDuration(timedif, abbreviated: true);
    final time = printedduration.split(',').first;
    return '$time ago';
  }

  @override
  Widget build(BuildContext context) {
    final userdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;

    return Padding(
      padding: const EdgeInsets.only(
        right: 15.0,
        left: 15,
        bottom: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
              minLeadingWidth: 30,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'reswapped as ${userdata.userName}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        var isdeleted = await showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                          ),
                          context: context,
                          builder: (context) => ReswapactionMenu(
                            commentId: reswapPost.commentId,
                            postId: reswapPost.postId,
                          ),
                        );
                        if (isdeleted != null) {
                          if (isdeleted) {
                            Provider.of<ReswapPostData>(context, listen: false)
                                .removereswap(reswapPost.commentId);
                          }
                        }
                      },
                      child: const Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                      ))
                ],
              ),
              subtitle: Text(
                timeDuration(),
                style: const TextStyle(fontSize: 13),
              ),
              leading: CircleAvatar(
                radius: 22,
                backgroundImage: userdata.userImage == ''
                    ? const AssetImage('assets/images/Person.png')
                        as ImageProvider
                    : NetworkImage(userdata.userImage),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 15.0, left: 15.0, bottom: 10.0, top: 5.0),
              child: DetectableText(
                detectedStyle:
                    const TextStyle(color: Colors.blue, fontFamily: 'Poppins'),
                basicStyle: const TextStyle(
                  fontSize: 15,
                ),
                moreStyle: const TextStyle(color: Colors.blue),
                lessStyle: const TextStyle(
                  color: Colors.indigo,
                  fontFamily: 'Poppins',
                ),
                onTap: (text) async {
                  if (Uri.parse(text).isAbsolute) {
                    if (!await launch(text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Could not launch $text',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }
                  }
                },
                text: reswapPost.comment,
                detectionRegExp: detectionRegExp(atSign: false)!,
              ),
            ),
            reswapPost.medialink == ''
                ? const SizedBox()
                : reswapPost.medialink.contains('.jpg?') ||
                        reswapPost.medialink.contains('.png?') ||
                        reswapPost.medialink.contains('.jpeg?')
                    ? Padding(
                        padding: const EdgeInsets.only(
                          right: 15.0,
                          left: 15.0,
                          bottom: 15.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child:
                              Image(image: NetworkImage(reswapPost.medialink)),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          right: 15.0,
                          left: 15.0,
                          bottom: 15.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: VideoWidget(
                            link: reswapPost.medialink,
                          ),
                        ),
                      ),
            FeedTile(postdata: reswapPost.post, type: 'reswap'),
          ],
        ),
      ),
    );
  }
}
