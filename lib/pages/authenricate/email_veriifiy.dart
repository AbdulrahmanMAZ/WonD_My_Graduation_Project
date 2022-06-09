import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:coffre_app/pages/home/Customer/CustLocation.dart';
import 'package:coffre_app/pages/home/Customer/Customerlanding.dart';
import 'package:coffre_app/pages/home/Shop/shopHomePage.dart';
import 'package:coffre_app/pages/home/Worker/workerLanding.dart';
import 'package:coffre_app/pages/home/Worker/worker_home.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser!.uid;
  //const VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late Future<DocumentSnapshot<Object?>> userDATA;
  bool isEmailVertfied = false;
  bool canResend = true;
  Timer? timer;
  bool showLogIn = true;

  void checkPage() {
    setState(() {
      showLogIn = !showLogIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    this.userDATA = GiveMETHEGUSER();
    super.initState();

    isEmailVertfied = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVertfied) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVertified();
      });
    }
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVertified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVertfied = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVertfied) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final _user = FirebaseAuth.instance.currentUser!;
      await _user.sendEmailVerification();

      setState(() => canResend = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResend = true);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot<Object?>> GiveMETHEGUSER() {
    final CollectionReference workers =
        FirebaseFirestore.instance.collection('coffes');
    Future<DocumentSnapshot<Object?>> a = workers.doc(widget.user).get();
    return a;
  }

  @override
  Widget build(BuildContext context) => isEmailVertfied
      ? FutureBuilder<DocumentSnapshot>(
          future: this.userDATA,
          // initialData: null,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                  appBar: AppBar(), body: Text('${snapshot.error}'));
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Document does not exist"),
                        TextButton(
                            child: Text('Go To Sign In Page'),
                            onPressed: () {
                              AuthSrrvice().SignOut();
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => SignIn()));
                            })
                      ],
                    ),
                  ));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              if (data['isWorker'] == true) {
                return workerlanding();
              } else {
                return Customerlanding();
              }
            }

            return Loading();
          },
        )
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.email,
                  size: 50,
                ),
                Container(
                  child: Text(
                    'An email has been sent to this email ${FirebaseAuth.instance.currentUser!.email}, click the link to verify',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => canResend ? sendVerificationEmail : null,
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromRadius(20)),
                  icon: Icon(Icons.email_outlined),
                  label: Text('Resend email'),
                ),
                TextButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromRadius(20)),
                  child: Text('Cancel'),
                )
              ],
            )),
          ),
        );
}
