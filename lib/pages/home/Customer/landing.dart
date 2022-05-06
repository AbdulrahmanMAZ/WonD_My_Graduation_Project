import 'dart:async';

import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:flutter/material.dart';

class landing extends StatefulWidget {
  const landing({Key? key}) : super(key: key);

  @override
  State<landing> createState() => _landingState();
}

class _landingState extends State<landing> {
  @override
  void initState() {
    Timer.run(() {
      // import 'dart:async:
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Cust_Home()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Loading();
  }
}
