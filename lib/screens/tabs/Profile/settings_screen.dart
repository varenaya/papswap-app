import 'package:flutter/material.dart';
import 'package:papswap/models/app/color_const.dart';
import 'package:papswap/services/authservice/authservice.dart';
import 'package:url_launcher/url_launcher.dart';

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
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.fromLTRB(
                                24.0, 12.0, 12.0, 0.0),
                            title: const Text(
                              'Reset Password',
                              textAlign: TextAlign.start,
                            ),
                            content: const Text(
                              'Password reset email will be sent to your registered email address.',
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
                                  'SEND',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () async {
                                  AuthService().changepassword().then((value) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Password reset link sent!',
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(fontFamily: 'Poppins'),
                                        ),
                                        backgroundColor: Colors.blue,
                                      ),
                                    );
                                  });
                                },
                              )
                            ],
                          );
                        });
                  },
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
                  onTap: () async {
                    const _url = 'https://papswap.in/faq';
                    if (!await canLaunch(_url)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Could not launch $_url',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    } else {
                      launch(_url);
                    }
                  },
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
                  onTap: () async {
                    const email = 'hello@papswap.in';
                    final url =
                        'mailto:$email?subject=${Uri.encodeFull('Have a query and want to connect.')}&body=${Uri.encodeFull(' ')}';
                    if (!await launch(url)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Could not launch Email to $email',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }
                  },
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
                  onTap: () async {
                    const _url = 'https://papswap.in/terms-n-conditions';
                    if (!await canLaunch(_url)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Could not launch $_url',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    } else {
                      launch(_url);
                    }
                  },
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
