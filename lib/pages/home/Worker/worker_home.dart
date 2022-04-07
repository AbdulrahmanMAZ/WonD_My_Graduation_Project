import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Worker/requests_list.dart';
import 'package:coffre_app/pages/home/Worker/worker_drawer.dart';
import 'package:coffre_app/pages/home/Worker/worker_settings.dart';

import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class worker_home extends StatelessWidget {
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  Widget build(BuildContext context) {
    void _showAppSettings() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: WorkerSettingsForm(),
            );
          });
    }

    final CollectionReference requests =
        FirebaseFirestore.instance.collection('requests');
    final user = Provider.of<User>(context);

    return StreamProvider<List<Request>?>.value(
      value: DatabaseService().requets,
      initialData: null,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.brown[50],
        drawer: worker_drawer(
          username: user.displayName,
          logout: TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.SignOut();
            },
          ),
        ),
        appBar: MyCustomAppBar(
          name: 'Nearby Customers',
          widget: [],
        ),
        // TextButton.icon(
        // onPressed: () async {
        // DatabaseService()
        //     .RaiseRequest(user.displayName.toString(), user.uid);
        // },
        // icon: Icon(Icons.front_hand),
        // label: Text('Rquest Service'))

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings),
          onPressed: () {
            _showAppSettings();
          },
        ),
      ),
    );
  }
}