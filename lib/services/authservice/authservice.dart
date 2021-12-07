import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papswap/services/authservice/googlesigninprovider.dart';
import 'package:provider/provider.dart';

class AuthService {
  final _firestore = FirebaseFirestore.instance;

  Stream<User?> userStream() {
    return FirebaseAuth.instance.idTokenChanges();
  }

  Future<void> trylogin(
      BuildContext context, String userEmail, String userpassword) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: userpassword,
      );
    } on FirebaseAuthException catch (err) {
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  Future<void> trySignup(BuildContext context, String userEmail,
      String userpassword, String userName) async {
    UserCredential authresult;

    try {
      authresult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userpassword,
      );
      await _firestore.collection('users').doc(authresult.user!.uid).set({
        'userName': userName,
        'userEmail': userEmail,
        'userImage': '',
        'userGender': '',
        'userBio': '',
        'user_id': authresult.user!.uid,
        'dateJoined': DateTime.now(),
        'coinVal': 5,
        'userWebsite': '',
        'userType': '',
      });
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (err) {
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> googlesignin(BuildContext context) async {
    final authprovider =
        Provider.of<GoogleSignInProvider>(context, listen: false);
    try {
      authprovider.googlelogin().then((value) async {
        final user = FirebaseAuth.instance.currentUser;
        final usertime = user!.metadata.creationTime;
        if (DateTime.now().difference(usertime!).inSeconds < 10) {
          await _firestore.collection('users').doc(user.uid).set({
            'userName': user.displayName,
            'userEmail': user.email,
            'userImage': user.photoURL,
            'userGender': '',
            'userBio': '',
            'user_id': user.uid,
            'dateJoined': DateTime.now(),
            'coinVal': 5,
            'userWebsite': '',
            'userType': '',
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      var message = 'An error occured, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  void passwordreset(String userEmail, BuildContext context) {
    if (userEmail == '' || !EmailValidator.validate(userEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please enter a valid email first.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text(
                'Password Reset',
                textAlign: TextAlign.center,
              ),
              content: const Text(
                'A link to change has been sent to you to change your password to the above email address!',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: userEmail);
                    } on FirebaseAuthException catch (e) {
                      var message =
                          'An error occured, please check your credentials!';
                      if (e.message != null) {
                        message = e.message!;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            message.toString(),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }

                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  void logout(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser!.providerData[0].providerId ==
        'google.com') {
      final authprovider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      authprovider.googlesignin.disconnect();
    }

    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false));
  }
}
