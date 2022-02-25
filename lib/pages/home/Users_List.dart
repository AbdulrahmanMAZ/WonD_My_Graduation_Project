import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/brew_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffre_app/modules/User.dart';

class CoffeList extends StatefulWidget {
  @override
  _CoffeListState createState() => _CoffeListState();
}

class _CoffeListState extends State<CoffeList> {
  @override
  Widget build(BuildContext context) {
    //List<Widget> widgets = <Widget>[];

    final users = Provider.of<List<user>?>(context) ?? [];

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return BrewTile(User: users[index]);
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
  