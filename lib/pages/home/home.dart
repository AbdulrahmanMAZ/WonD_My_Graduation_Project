import 'package:coffre_app/pages/home/settings_forms.dart';
import 'package:coffre_app/shared/loading.dart';

import 'Coffe_List.dart';
import 'package:coffre_app/modules/coffe.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  Widget build(BuildContext context) {
    final CollectionReference coffes =
        FirebaseFirestore.instance.collection('coffes');

    void _showAppSettings() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: SettingsForm(),
            );
          });
    }
    // FirebaseFirestore.instance
    //     .collection('coffes')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print(doc["name"]);
    //     print(doc["strengh"]);
    //   });
    // });

    return StreamProvider<List<Coffe>?>.value(
      value: DatabaseService().brews,
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
          actions: <Widget>[],
        ),
        body: CoffeList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings),
          onPressed: () {
            _showAppSettings();
          },
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
