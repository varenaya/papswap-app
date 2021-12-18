import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatefulWidget {
  final Map? transadata;
  const TransactionTile({Key? key, required this.transadata}) : super(key: key);

  @override
  _TransactionTileState createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  String timeDuration() {
    final timedif =
        (DateTime.now()).difference(widget.transadata!['trans_time'].toDate());

    final printedduration = printDuration(timedif, abbreviated: true);
    final time = printedduration.split(',').first;
    return '$time ago';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          expandedAlignment: Alignment.centerLeft,
          title: Text(
            widget.transadata!['transtext'],
            style: const TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            timeDuration(),
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          trailing: SizedBox(
            width: 85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Image(
                  image: AssetImage('assets/images/coin.png'),
                  height: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.transadata!['amount'].toString().contains('-')
                      ? widget.transadata!['amount']
                      : '+${widget.transadata!['amount']}',
                  style: TextStyle(
                      color:
                          widget.transadata!['amount'].toString().contains('-')
                              ? Colors.red
                              : Colors.teal,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                bottom: 5,
                right: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'DETAILS: ',
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          children: [
                        TextSpan(
                            text: widget.transadata!['details'],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ))
                      ])),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'TRANSACTION ID: ',
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          children: [
                        TextSpan(
                            text: widget.transadata!['transactionId'],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ))
                      ])),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'DATE: ',
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          children: [
                        TextSpan(
                            text: DateFormat('MMM dd yyyy, ').add_jm().format(
                                widget.transadata!['trans_time'].toDate()),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ))
                      ])),
                ],
              ),
            )
          ],
        ),
        const Divider(
          height: 0,
          thickness: 1,
          endIndent: 15,
          indent: 15,
        )
      ],
    );
  }
}
