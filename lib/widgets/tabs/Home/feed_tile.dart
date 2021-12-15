// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:papswap/models/post.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';

import 'package:papswap/widgets/tabs/Home/swap_menu.dart';
import 'package:papswap/widgets/tabs/Home/video_player.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedTile extends StatefulWidget {
  final Post postdata;
  final String type;

  const FeedTile({
    Key? key,
    required this.postdata,
    required this.type,
  }) : super(key: key);

  @override
  _FeedTileState createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  late bool isliked = false;
  int likes = 0;
  @override
  void initState() {
    super.initState();
    likes = widget.postdata.likes;
    if (widget.type == 'like') {
      isliked = true;
    }
  }

  String timeDuration() {
    final timedif =
        (DateTime.now()).difference(widget.postdata.createdAt.toDate());

    final printedduration = printDuration(timedif, abbreviated: true);
    final time = printedduration.split(',').first;
    return '$time ago';
  }

  @override
  Widget build(BuildContext context) {
    final currentuserdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;

    return Padding(
      padding: const EdgeInsets.only(
        right: 15.0,
        left: 15,
        bottom: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
            border: widget.type == 'reswap'
                ? Border.all(color: Colors.black, width: 1)
                : null,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white),
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
                    widget.postdata.creatername,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  widget.type == 'reswapost' || widget.type == 'reswap'
                      ? const SizedBox()
                      : InkWell(
                          onTap: () {
                            // showModalBottomSheet(
                            //   context: context,
                            //   builder: (context) => Container(),
                            // );
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
                backgroundImage: widget.postdata.createrimg == ''
                    ? const AssetImage('assets/images/Person.png')
                        as ImageProvider
                    : NetworkImage(widget.postdata.createrimg),
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
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }
                  }
                },
                text: ('${widget.postdata.feedtext}   '),
                detectionRegExp: detectionRegExp(atSign: false)!,
              ),
            ),
            // widget.postdata['medialink'] == ''
            //     ? const SizedBox()
            // : widget.postdata['medialink'].contains('.jpg?') ||
            //         widget.postdata['medialink'].contains('.png?')||
            //         widget.postdata['medialink'].contains('.jpeg?')
            //         ? Padding(
            //             padding: const EdgeInsets.only(
            //               right: 15.0,
            //               left: 15.0,
            //               bottom: 15.0,
            //             ),
            //             child: ClipRRect(
            //               borderRadius: BorderRadius.circular(15),
            //               child: Image(
            //                   image:
            //                       NetworkImage(widget.postdata['medialink'])),
            //             ),
            //           )
            //         : Padding(
            //             padding: const EdgeInsets.only(
            //               right: 15.0,
            //               left: 15.0,
            //               bottom: 15.0,
            //             ),
            //             child: ClipRRect(
            //               borderRadius: BorderRadius.circular(15),
            //               child: VideoWidget(
            //                 link: widget.postdata['medialink'],
            //               ),
            //             ),
            //           ),
            widget.type == 'reswapost' || widget.type == 'reswap'
                ? const SizedBox()
                : Padding(
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
                                          widget.postdata.postId,
                                          currentuserdata.user_id,
                                          isliked,
                                          context);
                                      if (isliked) {}
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
                                        likes == 0
                                            ? (likes + 1).abs().toString()
                                            : likes.abs().toString(),
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12.5),
                                      )
                                    : Text(
                                        likes == 0
                                            ? likes.abs().toString()
                                            : (likes - 1).abs().toString(),
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
                                widget.type == 'swap' || widget.type == 'like'
                                    ? const Icon(
                                        Icons.swap_horiz_rounded,
                                        size: 20,
                                        color: Colors.blueGrey,
                                      )
                                    : InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight:
                                                      Radius.circular(15)),
                                            ),
                                            context: context,
                                            builder: (context) => SwapMenu(
                                              postdata: widget.postdata,
                                              currentuserid:
                                                  currentuserdata.user_id,
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
                                  widget.postdata.swaps.toString(),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ],
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
