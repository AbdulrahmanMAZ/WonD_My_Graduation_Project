import 'dart:async';

import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/pages/home/Worker/worker_home.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:flutter/material.dart';

class workerlanding extends StatefulWidget {
  const workerlanding({Key? key}) : super(key: key);

  @override
  State<workerlanding> createState() => _workerlandingState();
}

class _workerlandingState extends State<workerlanding> {
  @override
  void initState() {
    Timer.run(() {
      // import 'dart:async:
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => worker_home()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Loading();
  }
}
