import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/requests_list.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class request_home extends StatelessWidget {
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  Widget build(BuildContext context) {
    final CollectionReference requests =
        FirebaseFirestore.instance.collection('requests');
    // final user = Provider.of<User>(context);

    return StreamProvider<List<Request>?>.value(
      value: DatabaseService().requets,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: 50,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),
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
        ),
        appBar: AppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            // TextButton.icon(
            // onPressed: () async {
            // DatabaseService()
            //     .RaiseRequest(user.displayName.toString(), user.uid);
            // },
            // icon: Icon(Icons.front_hand),
            // label: Text('Rquest Service'))
          ],
        ),
        body: RequestsList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings),
          onPressed: () {},
        ),
      ),
    );
  }
}
