import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/Wrapper.dart';
import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:coffre_app/pages/home/Customer/settings_forms.dart';
import 'package:coffre_app/pages/home/Customer/Users_List.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/pages/home/Customer/Cust_drawer.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class Cust_Order extends StatelessWidget {
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  Widget build(BuildContext context) {
    final CollectionReference aaa =
        FirebaseFirestore.instance.collection('coffes');

    final usera = Provider.of<User?>(context);

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    return StreamProvider<List<Request>?>.value(
      value: DatabaseService().requets,
      initialData: null,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.Allbackgroundcolor,
        drawer: CustDrawer(
          username: usera?.displayName,
          logout: TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              // Navigator.of(context).pop();
              await _auth.SignOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Wrapper()),
                  (Route<dynamic> route) => false);
              // Navigator.of(context).pop();
              // Navigator.of(context).pop();
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/login', (Route<dynamic> route) => false);
              // await _auth.SignOut();
              // Navigator.of(context).popAndPushNamed('/login');
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/login', (Route<dynamic> route) => false);
            },
          ),
        ),

        appBar: MyCustomAppBar(name: 'My Orders', widget: []),

        //  AppBar(
        //   title: Text('Your requests'),
        //   backgroundColor: Colors.brown[400],
        //   elevation: 0.0,
        //   shadowColor: Colors.black,
        //   actions: <Widget>[
        //     TextButton.icon(
        //         onPressed: () {
        //           _showAppSettings();
        //         },
        //         icon: Icon(Icons.front_hand),
        //         label: Text('Rquest Service'))
        //   ],
        // ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(255, 73, 3, 105),
                Color.fromARGB(255, 15, 7, 1)
              ])),
          child: Stack(
            children: [
              PositionedBackground(context),
              UserList(),
            ],
          ),
        ),
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
