import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/models/post.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  final Post post;

  const ReportScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late bool _validate = false;
  final TextEditingController textEditingController = TextEditingController();
  String reporttext = '';

  @override
  Widget build(BuildContext context) {
    final userdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffColor,
        elevation: 0,
        title: const Text(
          'Report an issue',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.9),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  if (textEditingController.text.length < 20) {
                    setState(() {
                      _validate = true;
                    });
                  } else {
                    _validate = false;
                    UploadData().uploadreport(
                        widget.post.postId, reporttext, userdata, context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Row(
                  children: const [
                    Text(
                      'Submit',
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
                    )
                  ],
                )),
          ),
        ],
      ),
      backgroundColor: AppColors.scaffColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: const AssetImage('assets/images/report.png'),
                    height: size.height * 0.23,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: RichText(
                      text: const TextSpan(
                        text:
                            'We count on you to make papswap a better platform, to directly connect you to policies and policy makers. So help us to understand the problem in this post.\nYou can report any problem regarding the ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        children: [
                          TextSpan(
                              text: 'content, media, hashtags',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              )),
                          TextSpan(text: ' of the post.')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Write your issue here!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueGrey, width: 1)),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: size.height * 0.53,
                  ),
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      errorText:
                          _validate ? 'Enter atleast 20 characters' : null,
                      border: InputBorder.none,
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      hintText: 'Type here..',
                    ),
                    onChanged: (value) {
                      reporttext = value;
                    },
                    maxLines: null,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
