import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/pages/authenricate/authenticate.dart';
import 'package:coffre_app/pages/home/cust_home.dart';
import 'package:coffre_app/pages/home/requests_home.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    final CollectionReference workers =
        FirebaseFirestore.instance.collection('coffes');

    //bool isWorker = brewCollection.doc(user!.uid).get('isWorker') as bool;

    // print(user?.displayName);
    if (user == null) {
      return Autheticate();
    } else {
      return FutureBuilder<DocumentSnapshot>(
        future: workers.doc(user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            if (data['isWorker'] == true) {
              return request_home();
            } else {
              return Home();
            }
          }

          return Loading();
        },
      );
    }
  }
}
