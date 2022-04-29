import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Customer/Accepted_req_list.dart';
import 'package:coffre_app/pages/home/Customer/Cust_orders.dart';
import 'package:coffre_app/pages/home/Customer/accepted_reqs.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/pages/home/Customer/orderPage.dart';
import 'package:coffre_app/pages/home/Customer/workingPage.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustDrawer extends StatelessWidget {
  final String? username;
  final Widget logout;

  CustDrawer({Key? key, required this.username, required this.logout})
      : super(key: key);
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  bool youHaveRequest = false;
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final acceptedrequests = Provider.of<List<AcceptedRequest>?>(context) ?? [];
    List a = [];
    for (var item in acceptedrequests) {
      if (item.Cust_ID == user?.uid) {
        youHaveRequest = true;
        a.add(item);
      }
    }
    Widget choose() {
      if (youHaveRequest) {
        return TextButton.icon(
          icon: Icon(Icons.person),
          label: Text('On-going Requests'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => workingpage(a[0])));
          },
        );
      }
      return SizedBox();
    }

    final CollectionReference aaa =
        FirebaseFirestore.instance.collection('coffes');
    // final usera = Provider.of<User?>(context);

    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthSrrvice().user,
      child: Drawer(
        backgroundColor: Color.fromARGB(64, 86, 123, 170),
        child: ListView(
          children: [
            Container(
              height: 50,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(255, 142, 187, 245),
                ),
                child: Text('Welcome, $username'),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Home Page'),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Cust_Home()));
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('My orders'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Cust_Order()));
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Workers accepts'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Accepted_Orders()));
              },
            ),
            choose(),
            logout,
          ],
        ),
      ),
    );
  }
}
