// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:papswap/models/userdata.dart';

class UserDataProvider extends ChangeNotifier {
  late UserData _userdata;

  UserData get userdata {
    return _userdata;
  }

  UserData userData(UserData userData) {
    return _userdata = userData;
  }
}
