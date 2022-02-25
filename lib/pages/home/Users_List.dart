import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/Cust_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    //List<Widget> widgets = <Widget>[];
    final usera = Provider.of<User>(context);
    final _myRequests = Provider.of<List<Request>?>(context) ?? [];

    return ListView.builder(
        itemCount: _myRequests.length,
        itemBuilder: (context, index) {
          //print(users[index].);
          if (_myRequests[index].Cust_ID == usera.uid && index <= 1) {
            return BrewTile(userRequest: _myRequests[index]);
          }
          return Text('');
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
  