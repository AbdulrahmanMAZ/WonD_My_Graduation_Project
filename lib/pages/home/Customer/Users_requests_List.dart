import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Customer/First_Request_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserRequestsList extends StatefulWidget {
  @override
  _UserRequestsListState createState() => _UserRequestsListState();
}

class _UserRequestsListState extends State<UserRequestsList> {
  @override
  Widget build(BuildContext context) {
    //List<Widget> widgets = <Widget>[];
    final usera = Provider.of<User?>(context);
    final _myRequests = Provider.of<List<Request>?>(context) ?? [];
    List a = [];
    for (var item in _myRequests) {
      if (item.Cust_ID == usera?.uid) a.add(item);
    }
    return ListView.builder(
        itemCount: a.length,
        itemBuilder: (context, index) {
          return requestTile(userRequest: a[index]);
        });
  }
}




    // if (brews != null) {
    //   for (var User in brews.docs) {
    //     if (User.get('name') == 'Abdulrahman') {
    //       print(User.get('name'));
    //       print(User.get('sugars'));
    //       print(User.get('strentgh'));
         
    //     }
    //   }
    // }
    
    // counter + 1;
    // for (var brew in brews!.docs) {
    //   //print("=================${counter}=====================");
    //   if (brew != null) {
    //     widgets.add(Text(brew.get('name')));
    //   }}
    // return widgets[1];
  