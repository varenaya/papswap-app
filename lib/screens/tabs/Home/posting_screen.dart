// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:papswap/widgets/tabs/Home/feed_tile.dart';
import 'package:papswap/widgets/tabs/Home/video_player.dart';
import 'package:provider/provider.dart';

class PostingScreen extends StatefulWidget {
  final String type;
  final reswappostdata;

  final reswapcreaterdata;
  const PostingScreen(
      {Key? key,
      required this.type,
      this.reswappostdata,
      this.reswapcreaterdata})
      : super(key: key);

  @override
  _PostingScreenState createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  File? media;
  final TextEditingController _textcontroller = TextEditingController();
  final UploadData uploadData = UploadData();
  String feedtext = '';
  UploadTask? task;

  Future pickMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      final file = result.files.first;
      final media = File(file.path!);
      setState(() {
        this.media = media;
      });
    } on PlatformException catch (e) {
      var message = 'An error occured';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;
    return Scaffold(
      backgroundColor: AppColors.scaffColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: userdata.userImage == ''
                            ? const AssetImage('assets/images/Person.png')
                                as ImageProvider
                            : NetworkImage(userdata.userImage),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      RichText(
                        text: TextSpan(
                          text: widget.type == 'Post'
                              ? 'posting as  '
                              : 'Reswaping as  ',
                          style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              color: Colors.black87),
                          children: [
                            TextSpan(
                                text: userdata.userName,
                                style: const TextStyle(
                                    fontSize: 16.6,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: Colors.black))
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        pickMedia();
                      },
                      child: Icon(
                        Icons.image_search_outlined,
                        color: Colors.indigo.shade900,
                      ))
                ],
              ),
            ),
            preferredSize: const Size.fromHeight(50)),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  if (widget.type == 'Post') {
                    final docId =
                        await uploadData.postData(feedtext, userdata, context);
                    if (media == null) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Your post has been posted successfully!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      );
                      return;
                    }
                    task = await uploadData.postMedia(media, docId!, context);

                    setState(() {});
                    if (task == null) return;
                    final snapshot = await task!.whenComplete(() {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Your post has been posted successfully!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    });
                    final url = await snapshot.ref.getDownloadURL();

                    uploadData.updatepostmedialink(docId, url);
                  } else {
                    final docId = await uploadData.reswappostData(feedtext,
                        userdata, context, widget.reswappostdata['post_id']);
                    if (media == null) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'You have earned 2 papTokens for successfully reswapping!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      );
                      return;
                    }
                    task = await uploadData.reswappostMedia(media, docId!,
                        context, widget.reswappostdata['post_id']);

                    setState(() {});
                    if (task == null) return;
                    final snapshot = await task!.whenComplete(() {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'You have earned 2 papTokens for successfully reswapping!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    });
                    final url = await snapshot.ref.getDownloadURL();

                    uploadData.updatereswappostmedialink(
                        docId, url, widget.reswappostdata['post_id']);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.type == 'Post' ? 'Post' : 'Reswap',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    widget.type == 'Post'
                        ? const Icon(
                            Icons.send_outlined,
                            color: Colors.white,
                            size: 20,
                          )
                        : const Icon(
                            Icons.swap_horiz_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                  ],
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DetectableTextField(
                decoration: const InputDecoration.collapsed(
                    hintText: "What's new?",
                    hintStyle: TextStyle(
                      fontSize: 18,
                    )),
                decoratedStyle: const TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Poppins',
                ),
                controller: _textcontroller,
                scrollPadding: const EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autofocus: true,
                onChanged: (value) {
                  feedtext = value;
                },
                detectionRegExp: detectionRegExp(atSign: false)!,
              ),
              const SizedBox(
                height: 10,
              ),
              if (media != null)
                lookupMimeType(media!.path)!.contains('image')
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              media!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  media = null;
                                });
                              },
                              child: const CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: VideoWidget(file: media!)),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  media = null;
                                });
                              },
                              child: const CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
              else
                const SizedBox(),
              task != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<TaskSnapshot>(
                        stream: task!.snapshotEvents,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final snap = snapshot.data;
                            final progress =
                                snap!.bytesTransferred / snap.totalBytes;
                            return Column(
                              children: [
                                LinearProgressIndicator(
                                  value: progress,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'please wait ....',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 8,
              ),
              if (widget.reswappostdata != null)
                FeedTile(
                  type: 'reswapost',
                  postdata: widget.reswappostdata,
                ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
