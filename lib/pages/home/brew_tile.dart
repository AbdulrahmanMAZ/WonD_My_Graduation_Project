import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/profile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:provider/provider.dart';

class BrewTile extends StatelessWidget {
  final Request userRequest;
  BrewTile({required this.userRequest});

  @override
  Widget build(BuildContext context) {
    final userStream = Provider.of<User>(context);
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          trailing: TextButton.icon(
              onPressed: () {
                DatabaseService()
                    .RequestsCollection
                    .doc(userStream.uid)
                    .delete() // <-- Delete
                    .then((_) => print('Deleted'))
                    .catchError((error) => print('Delete failed: $error'));
              },
              icon: Icon(Icons.delete),
              label: Text('Delete Iteam')),
          leading: CircleAvatar(
            backgroundColor: Colors.brown[200],
            radius: 25,
          ),
          title: Text(userRequest.name),
          subtitle: Text("Takes  sugar's"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfile(
                        name: userRequest.name,
                      )),
            );
          },
        ),
      ),
    );
  }
}
