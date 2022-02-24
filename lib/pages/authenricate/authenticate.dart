import 'package:coffre_app/pages/authenricate/register.dart';
import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:flutter/material.dart';

class Autheticate extends StatefulWidget {
  const Autheticate({Key? key}) : super(key: key);

  @override
  _AutheticateState createState() => _AutheticateState();
}

class _AutheticateState extends State<Autheticate> {
  bool showLogIn = true;

  void checkPage() {
    setState(() {
      showLogIn = !showLogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogIn) {
      return SignIn(toggleVeiw: checkPage);
    } else {
      return Register(toggleView: checkPage);
    }
  }
}
