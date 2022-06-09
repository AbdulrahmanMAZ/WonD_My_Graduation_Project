import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Customer/profile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class requestTile extends StatelessWidget {
  final Request userRequest;
  bool hasInternet = false;
  requestTile({required this.userRequest});

  @override
  Widget build(BuildContext context) {
    final userStream = Provider.of<User>(context);
    var date = DateTime.fromMillisecondsSinceEpoch(userRequest.t);
    var h24 = DateFormat('dd/MM/yyyy, hh:mm a').format(date);
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          trailing: TextButton.icon(
              onPressed: () async {
                hasInternet = await InternetConnectionChecker().hasConnection;
                if (hasInternet) {
                  DatabaseService()
                      .RequestsCollection
                      .doc(userStream.uid)
                      .delete() // <-- Delete
                      .then((_) => print('Deleted'))
                      .catchError((error) => print('Delete failed: $error'));
                } else {
                  showSimpleNotification(Text('You have no connection!'),
                      background: Colors.red);
                }
              },
              icon: Icon(
                Icons.delete,
                size: 20,
              ),
              label: Text(
                '',
                style: TextStyle(fontSize: 1),
              )),
          title: Text(userRequest.profession,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(h24),
        ),
      ),
    );
  }
}
