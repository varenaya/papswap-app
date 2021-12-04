import 'package:flutter/material.dart';

class MovieTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Size size;
  final String cost;
  const MovieTile({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.size,
    required this.cost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          width: size.width * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fitHeight,
                  height: size.height * 0.45,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
