import 'package:flutter/material.dart';
import 'package:papswap/services/datarepo/Api/uplaod_data.dart';
import 'package:papswap/services/datarepo/providers/userData.dart';
import 'package:provider/provider.dart';

class RewardsMenu extends StatefulWidget {
  final Map rewarddata;
  const RewardsMenu({Key? key, required this.rewarddata}) : super(key: key);

  @override
  State<RewardsMenu> createState() => _RewardsMenuState();
}

class _RewardsMenuState extends State<RewardsMenu> {
  late bool _validate = false;
  String _mobileno = '';
  final TextEditingController mobilenumberController = TextEditingController();
  List optionsList = [];
  String selectedoption = '';
  @override
  void initState() {
    optionsList = widget.rewarddata['optionsList'];
    selectedoption = optionsList[0];
    super.initState();
  }

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
            widget.rewarddata['details'],
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
                  if (userdata.coinVal > widget.rewarddata['cost']) {
                    if (mobilenumberController.text.length < 10 ||
                        mobilenumberController.text.length > 10) {
                      setState(() {
                        _validate = true;
                      });
                    } else {
                      _validate = false;
                      UploadData()
                          .rewardclaim(
                              widget.rewarddata['rewardId'],
                              widget.rewarddata['cost'],
                              widget.rewarddata['rewardName'],
                              _mobileno,
                              selectedoption,
                              userdata,
                              context)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'You have successfully claimed a ${widget.rewarddata['rewardName']}, You\'ll recieve a email for further details.',
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
                    var diff = widget.rewarddata['cost'] - userdata.coinVal;
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    widget.rewarddata['buttontext'],
                    style: const TextStyle(color: Colors.white, fontSize: 14),
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
              hintText: 'Your mobile number',
              errorText: _validate ? 'Please enter a valid number.' : null,
            ),
            onChanged: (value) {
              _mobileno = value;
            },
          ),
          if (optionsList.isNotEmpty)
            DropdownButton(
              value: selectedoption,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: optionsList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedoption = value!.toString();
                });
              },
            )
        ],
      ),
    );
  }
}
