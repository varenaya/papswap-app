import 'package:flutter/material.dart';

class VoucherTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Size size;
  final String voucherText;
  final String cost;
  const VoucherTile(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.voucherText,
      required this.cost,
      required this.size})
      : super(key: key);

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
                  fit: BoxFit.contain,
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
              Text(
                voucherText,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.indigo.shade900,
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
