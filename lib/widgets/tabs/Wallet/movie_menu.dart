import 'package:flutter/material.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:provider/provider.dart';

class MovieMenu extends StatefulWidget {
  final Map moviedata;
  const MovieMenu({Key? key, required this.moviedata}) : super(key: key);

  @override
  _MovieMenuState createState() => _MovieMenuState();
}

class _MovieMenuState extends State<MovieMenu> {
  late bool _mobilevalidate = false;
  late bool _addressvalidate = false;
  String _mobileno = '';
  String _address = '';
  final TextEditingController mobilenumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
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
            'Claim a ticket of ${widget.moviedata['movieName']} for ${widget.moviedata['cost'].toString()} PapTokens',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        getform(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ElevatedButton(
                onPressed: () {
                  if (userdata.coinVal > widget.moviedata['cost']) {
                    if (mobilenumberController.text.length != 10) {
                      setState(() {
                        _mobilevalidate = true;
                      });
                    } else if (addressController.text.isEmpty) {
                      setState(() {
                        _addressvalidate = true;
                      });
                    } else {
                      UploadData()
                          .movieclaim(
                              widget.moviedata['movieId'],
                              widget.moviedata['cost'],
                              widget.moviedata['movieName'],
                              _mobileno,
                              _address,
                              userdata,
                              context)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'You have successfully claimed a movie ticket of ${widget.moviedata['movieName']}, You\'ll recieve a email for further details.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                        Navigator.of(context).pop();
                      });
                    }
                  } else {
                    var diff = widget.moviedata['cost'] - userdata.coinVal;
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
                    'Claim Movie',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Widget getform() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          TextField(
            controller: mobilenumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefix: const Text(
                '+91   ',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              border: InputBorder.none,
              hintText: 'Your mobile number',
              errorText:
                  _mobilevalidate ? 'Please enter a valid number.' : null,
            ),
            onChanged: (value) {
              _mobileno = value;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: addressController,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Your Address with pincode',
              errorText: _addressvalidate ? 'Address cannot be empty.' : null,
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              _address = value;
            },
            maxLines: null,
          ),
        ],
      ),
    );
  }
}
