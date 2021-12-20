import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googlesignin = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googlelogin(BuildContext context) async {
    try {
      final googleuser = await googlesignin.signIn();
      if (googleuser == null) return;
      _user = googleuser;

      final googleauth = await googleuser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      var message = 'An error occured in uploading the post! Try again';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    notifyListeners();
  }
}
