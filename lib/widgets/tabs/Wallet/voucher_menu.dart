import 'package:flutter/material.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VoucherMenu extends StatelessWidget {
  final Map voucherdata;
  const VoucherMenu({Key? key, required this.voucherdata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userdata =
        Provider.of<UserDataProvider>(context, listen: false).userdata;

    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 8),
          child: Center(
            child: Container(
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[350],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Text(
            'Claim a discount voucher of ${voucherdata['voucherName']} and ${voucherdata['voucherText']} for ${voucherdata['cost'].toString()} PapTokens',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: TextButton(
            onPressed: () async {
              final _url = voucherdata['voucherWebsite'];
              if (!await launch(_url)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Could not launch $_url',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    backgroundColor: Theme.of(context).errorColor,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Check Store',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ElevatedButton(
                onPressed: () {
                  if (userdata.coinVal > voucherdata['cost']) {
                    UploadData()
                        .voucherclaim(
                            voucherdata['voucherId'],
                            voucherdata['cost'],
                            voucherdata['voucherName'],
                            voucherdata['voucherText'],
                            userdata,
                            context)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You have successfully claimed a discount voucher of ${voucherdata['voucherName']}, You\'ll recieve a email for further details.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      );
                      Navigator.of(context).pop();
                    });
                  } else {
                    var diff = voucherdata['cost'] - userdata.coinVal;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'you need $diff PapTokens more to claim this reward. Keep swapping!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        backgroundColor: Theme.of(context).errorColor,
                      ),
                    );
                    Navigator.pop(context, false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Claim Voucher',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
