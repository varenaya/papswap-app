import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/userData.dart';
import 'package:papswap/widgets/tabs/Home/video_player.dart';
import 'package:provider/provider.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({Key? key}) : super(key: key);

  @override
  _PostingScreenState createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  File? media;
  final TextEditingController _textcontroller = TextEditingController();
  late String _feedtext;

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
    final Size size = MediaQuery.of(context).size;
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
                          text: 'posting as  ',
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Row(
                  children: const [
                    Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.send_outlined,
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
              TextField(
                decoration: const InputDecoration.collapsed(
                  hintText: "What's new?",
                ),
                controller: _textcontroller,
                scrollPadding: const EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autofocus: true,
                onChanged: (value) {
                  _feedtext = value;
                },
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
