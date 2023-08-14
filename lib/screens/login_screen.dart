import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/rounded_button.dart';
import 'package:chat_app/components/errors.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  bool loading = false;
  late String email;
  late String password;

  @override
  void initState() {
    super.initState();
    loading = false;
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
                    //Do something with the user input.
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
                    //Do something with the user input.
                    password = value;
                  },
                  decoration: kInputDecuration.copyWith(
                      hintText: 'Enter Your Password')),
              SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: 'LoginButton',
                child: RoundedButton(
                    text: "Log in",
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });

                      try {
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        setState(() {
                          loading = false;
                        });
                        Navigator.pushNamedAndRemoveUntil(context,
                            ChatScreen.id, (Route<dynamic> route) => false);
                      } catch (e) {
                        setState(() {
                          loading = false;
                        });
                        if (e.toString() ==
                            '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
                          errorPopUp(
                                  context: context,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  trigger: 'NO SUCH USER',
                                  message:
                                      'There is no user with this email, please check the email.')
                              .getPopUp();
                        } else {
                          errorPopUp(
                                  context: context,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  trigger: 'ACCESS DENIED',
                                  message:
                                      'Wrong password or email, please check and try again.')
                              .getPopUp();
                        }
                      }
                    },
                    color: Colors.lightBlueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
