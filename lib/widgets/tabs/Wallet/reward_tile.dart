import 'package:flutter/material.dart';

class RewardTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String buttonText;
  final String cost;
  const RewardTile({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.buttonText,
    required this.cost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                RichText(
                    text: TextSpan(
                        text: cost,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.black),
                        children: const [
                      TextSpan(
                          text: ' PapTokens',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: Colors.black))
                    ])),
                const SizedBox(
                  height: 10,
                ),
                Image(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
