import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Worker/Track_accept.dart';
import 'package:coffre_app/pages/home/Worker/workerProfile.dart';

import 'package:coffre_app/pages/home/Worker/worker_home.dart';
import 'package:coffre_app/pages/home/Worker/worker_requests.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class worker_drawer extends StatefulWidget {
  final String? username;
  final Widget logout;
  worker_drawer({Key? key, required this.username, required this.logout})
      : super(key: key);

  @override
  State<worker_drawer> createState() => _worker_drawerState();
}

class _worker_drawerState extends State<worker_drawer> {
  String? firebaseURL =
      'https://firebasestorage.googleapis.com/v0/b/coffe-app-a36f3.appspot.com/o/profile_images%2Ffd4f9e70-d099-11ec-8fcf-e11cc2ef35a3?alt=media&token=';

  final AuthSrrvice _auth = AuthSrrvice();

  bool youHaveRequest = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final acceptedrequests = Provider.of<List<AcceptedRequest>?>(context) ?? [];
    List a = [];
    for (var item in acceptedrequests) {
      if (item.worker_ID == user?.uid) {
        // youHaveRequest = true;
        if (item.Status >= 0) {
          a.add(item);
        }
      }
    }
    if (a.isNotEmpty) {
      setState(() {
        youHaveRequest = true;
      });
    } else {
      setState(() {
        youHaveRequest = false;
      });
    }
    Widget choose() {
      if (youHaveRequest) {
        return TextButton.icon(
          icon: Icon(Icons.person),
          label: Text('Track on-going Request'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => accept_tracker()));
          },
        );
      }
      return SizedBox();
    }

    final CollectionReference aaa =
        FirebaseFirestore.instance.collection('coffes');

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
                  child: Text('Welcome, ${widget.username}'),
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Home Page'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => worker_home()));
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Nearby orders'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => worker_requests()));
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
              choose(),
              widget.logout,
            ],
          ),
        ),
      ),
    );
  }
}
