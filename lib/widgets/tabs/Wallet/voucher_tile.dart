import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:papswap/widgets/tabs/Wallet/voucher_menu.dart';

class VoucherTile extends StatelessWidget {
  final Map voucherdata;
  final Size size;

  const VoucherTile({Key? key, required this.voucherdata, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            context: context,
            builder: (context) => VoucherMenu(voucherdata: voucherdata),
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
                child: CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: voucherdata['voucherImg'],
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.black12,
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                voucherdata['voucherName'],
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                voucherdata['voucherText'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.indigo.shade900,
                ),
              ),
              RichText(
                  text: TextSpan(
                      text: voucherdata['cost'].toString(),
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
