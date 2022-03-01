import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustDrawer extends StatelessWidget {
  final String username;
  CustDrawer({Key? key, required this.username}) : super(key: key);
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  Widget build(BuildContext context) {
    final CollectionReference aaa =
        FirebaseFirestore.instance.collection('coffes');
    final usera = Provider.of<User>(context);

    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 50,
            child: DrawerHeader(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromARGB(255, 38, 70, 173),
              ),
              child: Text('Welcome, $username'),
            ),
          ),
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Home Page'),
            onPressed: () {
              Navigator.pushNamed(context, '/cust_home');
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('My orders'),
            onPressed: () {
              Navigator.pushNamed(context, '/cust_orders');
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.SignOut();
            },
          ),
        ],
      ),
    );
  }
}
