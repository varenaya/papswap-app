import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:papswap/screens/auth/signup_screen.dart';
import 'package:papswap/services/authservice/authservice.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  String _userEmail = '';
  String _userpassword = '';
  var _isLoading = false;

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      await _auth.trylogin(context, _userEmail, _userpassword);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
              top: size.height * 0.05,
              bottom: size.height * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                tag: 'welcome-image',
                child: Image(
                  width: size.width * 0.5,
                  image: const AssetImage('assets/images/welcome_papswap.png'),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                        onChanged: (value) {
                          _userEmail = value;
                        },
                        onSaved: (newValue) {
                          _userEmail = newValue!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
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
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    InkWell(
                      onTap: () {
                        _auth.passwordreset(_userEmail, context);
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  _isLoading
                      ? const CustomProgressIndicator()
                      : ElevatedButton(
                          onPressed: _trySubmit,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  InkWell(
                    onTap: () async {
                      await _auth.googlesignin(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          width: 30,
                          image: AssetImage('assets/icons/google.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sign in',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageTransition(
                          child: const SignUpScreen(),
                          type: PageTransitionType.fade));
                    },
                    child: Text(
                      "Create account",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.indigo.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
