import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/services/datarepo/uplaod_data.dart';
import 'package:papswap/services/datarepo/userData.dart';

import 'package:papswap/widgets/tabs/Home/swap_menu.dart';
import 'package:papswap/widgets/tabs/Home/video_player.dart';
import 'package:provider/provider.dart';

class FeedTile extends StatefulWidget {
  final Map postdata;

  final UserData createrdata;
  const FeedTile({Key? key, required this.postdata, required this.createrdata})
      : super(key: key);

  @override
  _FeedTileState createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  late bool isliked = false;
  int likes = 0;

  String timeDuration() {
    final timedif =
        (DateTime.now()).difference(widget.postdata['createdAt'].toDate());

    final printedduration = printDuration(timedif, abbreviated: true);
    final time = printedduration.split(',').first;
    return '$time ago';
  }

  @override
  Widget build(BuildContext context) {
    final currentuserdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;
    likes = widget.postdata['likes'];
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
                    widget.createrdata.userName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(),
                        );
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
                backgroundImage: widget.createrdata.userImage == ''
                    ? const AssetImage('assets/images/Person.png')
                        as ImageProvider
                    : NetworkImage(widget.createrdata.userImage),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 15.0, left: 15.0, bottom: 10.0, top: 5.0),
              child: DetectableText(
                detectedStyle: const TextStyle(
                    fontSize: 15, color: Colors.blue, fontFamily: 'Poppins'),
                basicStyle: const TextStyle(
                  fontSize: 15,
                ),
                text: widget.postdata['feedtext'],
                detectionRegExp: detectionRegExp(atSign: false)!,
              ),
            ),
            widget.postdata['medialink'] == ''
                ? const SizedBox()
                : widget.postdata['medialink'].contains('.jpg?')
                    ? Padding(
                        padding: const EdgeInsets.only(
                          right: 15.0,
                          left: 15.0,
                          bottom: 15.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image(
                              image:
                                  NetworkImage(widget.postdata['medialink'])),
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
                            link: widget.postdata['medialink'],
                          ),
                        ),
                      ),
            Padding(
              padding: const EdgeInsets.only(
                right: 15.0,
                left: 15.0,
                bottom: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isliked = !isliked;

                                UploadData().postlike(
                                    widget.postdata['post_id'],
                                    currentuserdata.user_id,
                                    isliked);
                              });
                            },
                            child: isliked
                                ? const Icon(
                                    Icons.favorite,
                                    size: 20,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    size: 20,
                                    color: Colors.blueGrey,
                                  ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          isliked
                              ? Text(
                                  (likes + 1).toString(),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12.5),
                                )
                              : Text(
                                  likes.toString(),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12.5),
                                ),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                context: context,
                                builder: (context) => SwapMenu(
                                  createrdata: widget.createrdata,
                                  postdata: widget.postdata,
                                  currentuserid: currentuserdata.user_id,
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.swap_horiz_rounded,
                              size: 20,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            widget.postdata['swaps'].toString(),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(),
                      );
                    },
                    child: const Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
