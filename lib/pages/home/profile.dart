import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final String? name;
  UserProfile({this.name});

  //const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name as String),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: Colors.brown[200],
              radius: 40,
            ),
          ],
        ),
      ),
    );
  }
}
