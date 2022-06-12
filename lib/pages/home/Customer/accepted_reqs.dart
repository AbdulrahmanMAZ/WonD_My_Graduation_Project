import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/Wrapper.dart';
import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:coffre_app/pages/home/Customer/Accepted_req_list.dart';
import 'package:coffre_app/pages/home/Customer/settings_forms.dart';
import 'package:coffre_app/pages/home/Customer/Users_requests_List.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/pages/home/Customer/Cust_drawer.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Accepted_Orders extends StatefulWidget {
  @override
  State<Accepted_Orders> createState() => _Accepted_OrdersState();
}

class _Accepted_OrdersState extends State<Accepted_Orders> {
  final AuthSrrvice _auth = AuthSrrvice();
  String sortingMethod = 'price';
  @override
  Widget build(BuildContext context) {
    final CollectionReference aaa =
        FirebaseFirestore.instance.collection('coffes');

    final usera = Provider.of<User?>(context);

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    return StreamProvider<List<AcceptedRequest>?>.value(
      value: DatabaseService().Acceptedrequets,
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
              await _auth.SignOut();

              // Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Wrapper()),
                  (Route<dynamic> route) => false);
            },
          ),
        ),
        appBar: MyCustomAppBar(name: 'Accepted Requests', widget: [
          Center(child: Text('Sort by: ')),
          TextButton(
              onPressed: (() {
                setState(() {
                  sortingMethod = 'price';
                });
              }),
              child: sortingMethod == "price"
                  ? Text(
                      'Price',
                      style: TextStyle(color: Colors.red),
                    )
                  : Text('Price', style: TextStyle(color: Colors.white))),
          TextButton(
              onPressed: (() {
                setState(() {
                  sortingMethod = 'rate';
                });
              }),
              child: sortingMethod == "rate"
                  ? Text('Rate', style: TextStyle(color: Colors.red))
                  : Text("Rate", style: TextStyle(color: Colors.white)))
        ]),
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
              AcceptedRequestsList(sortingMethod: sortingMethod),
            ],
          ),
        ),
      ),
    );
  }
}
