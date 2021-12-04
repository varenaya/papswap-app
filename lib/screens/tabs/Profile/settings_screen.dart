import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/authservice/authservice.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.scaffColor,
        bottom: PreferredSize(
            child: Container(
              color: Colors.black,
              height: 0.2,
            ),
            preferredSize: const Size.fromHeight(4.0)),
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
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                  minLeadingWidth: 30,
                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.notifications)),
              ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                  minLeadingWidth: 30,
                  title: const Text(
                    'Passwords',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.password)),
              ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                  minLeadingWidth: 30,
                  title: const Text(
                    'FAQs',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.question_answer)),
              ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                  minLeadingWidth: 30,
                  title: const Text(
                    'Help & Support',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.help)),
              ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                  minLeadingWidth: 30,
                  title: const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  leading: const Icon(Icons.checklist_outlined)),
              ListTile(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          contentPadding:
                              const EdgeInsets.fromLTRB(24.0, 12.0, 12.0, 0.0),
                          title: const Text(
                            'Logout',
                            textAlign: TextAlign.start,
                          ),
                          content: const Text(
                            'Are you sure you want to log out?',
                            textAlign: TextAlign.start,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'LOGOUT',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () async {
                                AuthService().logout(context);
                              },
                            )
                          ],
                        );
                      });
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                minLeadingWidth: 30,
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red, fontSize: 17),
                ),
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text('betaV1.0'),
          ),
        ],
      ),
    );
  }
}
