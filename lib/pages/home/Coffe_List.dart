import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/pages/home/brew_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffre_app/modules/coffe.dart';

class CoffeList extends StatefulWidget {
  @override
  _CoffeListState createState() => _CoffeListState();
}

class _CoffeListState extends State<CoffeList> {
  @override
  Widget build(BuildContext context) {
    //List<Widget> widgets = <Widget>[];

    final brews = Provider.of<List<Coffe>?>(context) ?? [];

    return ListView.builder(
        itemCount: brews.length,
        itemBuilder: (context, index) {
          return BrewTile(brew: brews[index]);
        });
  }
}




    // if (brews != null) {
    //   for (var coffe in brews.docs) {
    //     if (coffe.get('name') == 'Abdulrahman') {
    //       print(coffe.get('name'));
    //       print(coffe.get('sugars'));
    //       print(coffe.get('strentgh'));
         
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
  