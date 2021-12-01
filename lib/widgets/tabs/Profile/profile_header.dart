import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://bestprofilepictures.com/wp-content/uploads/2021/04/Cool-Profile-Picture-For-Discord.jpg'),
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
                    children: const [
                      Text(
                        'Alan Talan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'alantalan145@gmail.com',
                        style: TextStyle(
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
                  onTap: () {},
                  child: const Icon(
                    Icons.edit_outlined,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
              'I’ve been waiting hours and I’ll be waiting for hours more 🍟, till my love arrives and my heart’s fulfilled.🎈🎁',
              style: TextStyle(
                fontSize: 15.5,
              )),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: const [
              Icon(
                Icons.date_range_rounded,
                color: Colors.grey,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                'Joined December 2021',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.5,
                ),
              )
            ],
          ),
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
              const Text(
                'alantalan.com',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15.5,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
