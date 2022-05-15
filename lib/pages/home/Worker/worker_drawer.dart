import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/pages/home/Worker/Track_accept.dart';
import 'package:coffre_app/pages/home/Worker/workerProfile.dart';

import 'package:coffre_app/pages/home/Worker/worker_home.dart';
import 'package:coffre_app/pages/home/Worker/worker_requests.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class worker_drawer extends StatelessWidget {
  final String? username;
  final Widget logout;
  worker_drawer({Key? key, required this.username, required this.logout})
      : super(key: key);
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  Widget build(BuildContext context) {
    final CollectionReference aaa =
        FirebaseFirestore.instance.collection('coffes');
    // final usera = Provider.of<User?>(context);

    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthSrrvice().user,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(255, 73, 3, 105),
                Color.fromARGB(255, 12, 7, 10)
              ])),
          child: ListView(
            children: [
              Container(
                height: 50,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 181, 193, 231),
                  ),
                  child: Text('Welcome, $username'),
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Home Page'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => worker_home()));

                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     '/worker_home', (Route<dynamic> route) => false);
                  // Navigator.of(context).pushReplacementNamed('/worker_home');
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('My orders'),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => worker_requests()));
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Requests tracker'),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => accept_tracker()));
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Profile'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
              logout,
            ],
          ),
        ),
      ),
    );
  }
}
