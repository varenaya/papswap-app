import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:papswap/services/authservice/authservice.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  String _userEmail = '';
  String _userpassword = '';
  String _userName = '';
  var _isLoading = false;

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      await _auth.trySignup(context, _userEmail, _userpassword, _userName);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: size.height * 0.01,
              bottom: size.height * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                ),
              ),
              // Hero(
              //   tag: 'welcome-image',
              //   child: Image(
              //     width: size.width * 0.6,
              //     image: AssetImage('assets/images/hwt_filli.png'),
              //   ),
              // ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty ||
                              !EmailValidator.validate(value)) {
                            return 'Please enter a valid Email address';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Your Email"),
                        onSaved: (newValue) {
                          _userEmail = newValue!;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: TextFormField(
                        key: const ValueKey('Username'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter atleast 4 characters.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Name"),
                        onSaved: (newValue) {
                          _userName = newValue!;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: TextFormField(
                        key: const ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Password Must be 7 characters long';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Password"),
                        onSaved: (newValue) {
                          _userpassword = newValue!;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _isLoading
                      ? const Center(child: CustomProgressIndicator())
                      : ElevatedButton(
                          onPressed: _trySubmit,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Center(
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
