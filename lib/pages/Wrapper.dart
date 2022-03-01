import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/pages/authenricate/authenticate.dart';
import 'package:coffre_app/pages/authenricate/email_veriifiy.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    final CollectionReference workers =
        FirebaseFirestore.instance.collection('coffes');

    //bool isWorker = brewCollection.doc(user!.uid).get('isWorker') as bool;

    // print(user?.displayName);
    if (user == null) {
      return Autheticate();
    } else {
      return VerifyEmail();
    }
  }
}
