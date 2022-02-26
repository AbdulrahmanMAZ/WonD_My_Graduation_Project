// import 'package:coffre_app/modules/user.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
// import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/settings_forms.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Users_List.dart';
// import 'package:coffre_app/modules/User.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  Widget build(BuildContext context) {
    final CollectionReference aaa =
        FirebaseFirestore.instance.collection('coffes');
    final usera = Provider.of<User>(context);
    void _showAppSettings() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: SettingsForm(),
            );
          });
    }

    int timestamp = DateTime.now().millisecondsSinceEpoch;
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
          title: Text('Your requests'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () {
                  _showAppSettings();
                },
                icon: Icon(Icons.front_hand),
                label: Text('Rquest Service'))
          ],
        ),
        body: UserList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings),
          onPressed: () {},
        )
        //  FutureBuilder<DocumentSnapshot>(
        //     future: coffes.doc(_auth.inputData()).get(),
        //     builder:
        //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //       if (snapshot.hasError) {
        //         return Text("Something went wrong");
        //       }

        //       if (snapshot.hasData && !snapshot.data!.exists) {
        //         return Text("Document does not exist");
        //       }

        //       if (snapshot.connectionState == ConnectionState.done) {
        //         Map<String, dynamic> data =
        //             snapshot.data!.data() as Map<String, dynamic>;
        //         return Text(data['name']);
        //       }
        //       return Loading();
        //     })

        ,
      ),
    );
  }
}
