import 'package:flutter/material.dart';
import 'package:papswap/widgets/tabs/Home/swap_menu.dart';

class FeedTile extends StatefulWidget {
  const FeedTile({Key? key}) : super(key: key);

  @override
  _FeedTileState createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20.0,
        left: 20,
        bottom: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
              minLeadingWidth: 30,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Alan Talan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
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
              subtitle: const Text('2hr'),
              leading: const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                    'https://bestprofilepictures.com/wp-content/uploads/2021/04/Cool-Profile-Picture-For-Discord.jpg'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  right: 15.0, left: 15.0, bottom: 10.0, top: 5.0),
              child: Text(
                  'In the first place we have granted to God, and by this our present charter confirmed for us and our heirs! 🍔🍕'),
            ),
            const Padding(
              padding: EdgeInsets.only(
                right: 15.0,
                left: 15.0,
                bottom: 10.0,
              ),
              child: Text(
                '#cars #carsofinstagram #CarsWithOutLimits #carspotting',
                style: TextStyle(color: Colors.indigo),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                right: 15.0,
                left: 15.0,
                bottom: 15.0,
              ),
              child: Image(
                  image: NetworkImage(
                      'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/carbon-fiber-shelby-mustang-1600685276.jpg?crop=0.9988636363636364xw:1xh;center,top&resize=480:*')),
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
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.favorite_border,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          const Text(
                            '110',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.5),
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
                                builder: (context) => const SwapMenu(),
                              );
                            },
                            child: const Icon(
                              Icons.swap_horiz_rounded,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          const Text(
                            '15',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.5),
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
