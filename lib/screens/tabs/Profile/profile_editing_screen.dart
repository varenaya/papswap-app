import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:papswap/widgets/tabs/Profile/profile_widget.dart';
import 'package:papswap/widgets/tabs/Profile/textfield_widget.dart';
import 'package:provider/provider.dart';

class ProfileEditingScreen extends StatefulWidget {
  const ProfileEditingScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditingScreenState createState() => _ProfileEditingScreenState();
}

class _ProfileEditingScreenState extends State<ProfileEditingScreen> {
  File? media;
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _userGender = '';
  String _userWebsite = '';
  String _userBio = '';
  var _isLoading = false;

  Future pickMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
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
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      await UploadData()
          .updateuserdata(_userName, _userGender, _userWebsite, _userBio);
      if (media != null) {
        await UploadData().uploaduserPfp(media, context);
      }

      Navigator.of(context).pop();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffColor,
        elevation: 0,
        title: Text(
          'Edit profile',
          style: Theme.of(context).textTheme.headline1,
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
              onPressed: _trySubmit,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: _isLoading
                  ? const CustomProgressIndicator(
                      color: Colors.white,
                    )
                  : Row(
                      children: const [
                        Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.save_outlined,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.scaffColor,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: userdata.userImage,
              media: media,
              onClicked: () async {
                pickMedia();
              },
            ),
            const SizedBox(height: 15),
            TextFieldWidget(
              label: 'Full Name',
              text: userdata.userName,
              onChanged: (name) {
                _userName = name;
              },
            ),
            const SizedBox(height: 15),
            TextFieldWidget(
              label: 'Gender',
              text: userdata.userGender,
              onChanged: (gender) {
                _userGender = gender;
              },
            ),
            const SizedBox(height: 15),
            TextFieldWidget(
              label: 'Website',
              text: userdata.userWebsite,
              onChanged: (website) {
                _userWebsite = website;
              },
            ),
            const SizedBox(height: 15),
            TextFieldWidget(
              label: 'About',
              text: userdata.userBio,
              onChanged: (about) {
                _userBio = about;
              },
            ),
          ],
        ),
      ),
    );
  }
}
