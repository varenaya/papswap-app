import 'package:flutter/material.dart';

class TokenEarningTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String buttontext;
  final Size size;
  final String imagepath;
  final void Function()? actionfn;
  const TokenEarningTile({
    Key? key,
    required this.title,
    required this.size,
    required this.subtitle1,
    required this.subtitle2,
    required this.buttontext,
    required this.imagepath,
    required this.actionfn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          leading: Image(
            image: AssetImage(imagepath),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          subtitle: RichText(
            text: TextSpan(
              text: subtitle1,
              style: const TextStyle(
                  fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
              children: [
                TextSpan(
                  text: subtitle2,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.blue, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          trailing: ElevatedButton(
              onPressed: actionfn,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                buttontext,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              )),
        ),
      ),
    );
  }
}
