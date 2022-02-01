import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/models/userdata.dart';
import 'package:papswap/screens/tabs/Profile/profile_editing_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: userData.userImage == ''
                            ? const AssetImage('assets/images/Person.png')
                                as ImageProvider
                            : CachedNetworkImageProvider(userData.userImage),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        userData.userEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageTransition(
                        child: const ProfileEditingScreen(),
                        type: PageTransitionType.rightToLeftWithFade));
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          userData.userBio == ''
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userData.userBio,
                        style: const TextStyle(
                          fontSize: 15.5,
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
          Row(
            children: [
              const Icon(
                Icons.date_range_rounded,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'Joined ${DateFormat.yMMMM().format(userData.dateJoined.toDate())}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15.5,
                ),
              )
            ],
          ),
          userData.userWebsite == ''
              ? const SizedBox(
                  height: 10,
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Transform.rotate(
                          angle: 120 * 3.14 / 180,
                          child: const Icon(
                            Icons.link,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        InkWell(
                          onTap: () async {
                            final _url = 'https://${userData.userWebsite}';
                            if (!await canLaunch(_url)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Could not launch $_url',
                                    textAlign: TextAlign.center,
                                    style:
                                        const TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  backgroundColor: Theme.of(context).errorColor,
                                ),
                              );
                            }
                            {
                              launch(_url);
                            }
                          },
                          child: Text(
                            userData.userWebsite,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
