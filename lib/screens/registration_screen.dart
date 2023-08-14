import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/rounded_button.dart';
import 'package:chat_app/components/errors.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;
  bool loading = false;

  @override
  void dispose() {
    setState(() {
      loading = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kInputDecuration.copyWith(hintText: 'Enter Your Email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kInputDecuration.copyWith(
                    hintText: 'Enter Your Password',
                  )),
              SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: 'RegisterButton',
                child: RoundedButton(
                  text: "Register",
                  color: Colors.blueAccent,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      Navigator.pushNamed(context, ChatScreen.id);

                      loading = false;
                    } catch (e) {
                      switch (e.toString()) {
                        case ('[firebase_auth/email-already-in-use] The email address is already in use by another account.'):
                          {
                            errorPopUp(
                                    context: context,
                                    onTap: () {
                                      setState(() {
                                        loading = false;
                                        Navigator.pop(context);
                                      });
                                    },
                                    message:
                                        'There is a user with this email, try logging in!',
                                    trigger: 'USER EXISTS')
                                .getPopUp();
                          }
                        case ('[firebase_auth/invalid-email] The email address is badly formatted.' ||
                              'LateInitializationError: Field \'email\' has not been initialized.'):
                          {
                            errorPopUp(
                                    onTap: () {
                                      setState(() {
                                        loading = false;
                                        Navigator.pop(context);
                                      });
                                    },
                                    context: context,
                                    message:
                                        'The entered email is invalid please check the email format!',
                                    trigger: 'EMAIL FORMAT')
                                .getPopUp();
                          }
                        case ('[firebase_auth/weak-password] Password should be at least 6 characters'):
                          {
                            errorPopUp(
                                    onTap: () {
                                      setState(() {
                                        loading = false;
                                        Navigator.pop(context);
                                      });
                                    },
                                    context: context,
                                    message:
                                        'The password you entered is very short it must be at lest 6 characters!',
                                    trigger: 'INVALID PASSWORD')
                                .getPopUp();
                          }
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
