import 'package:coffre_app/pages/home/profile.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/modules/coffe.dart';

class BrewTile extends StatelessWidget {
  final Coffe brew;
  BrewTile({required this.brew});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.brown[200],
            radius: 25,
          ),
          title: Text(brew.name),
          subtitle: Text("Takes  sugar's"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfile(
                        name: brew.name,
                      )),
            );
          },
        ),
      ),
    );
  }
}
