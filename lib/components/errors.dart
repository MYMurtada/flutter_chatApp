import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class errorPopUp {
  errorPopUp(
      {required this.message,
      required this.trigger,
      this.context,
      required this.onTap});

  final void Function() onTap;
  final String trigger;
  final String message;
  final context;

  Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  Future<bool?> getPopUp() {
    return Alert(
      style: AlertStyle(
        alertElevation: 50.0,
      ),
      context: context,
      type: AlertType.error,
      alertAnimation: fadeAlertAnimation,
      title: trigger,
      desc: message,
      buttons: [
        DialogButton(
          onPressed: onTap,
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          child: Text(
            "back",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }
}
