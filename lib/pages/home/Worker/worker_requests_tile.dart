import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/profile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class worker_requets_tile extends StatelessWidget {
  final Request request;

  final double distance;
  const worker_requets_tile(
      {Key? key, required this.request, required this.distance})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: user?.uid);
    double price;
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text(request.name),
              subtitle: Text(request.Description),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(' ${distance} KM     '),
                TextButton(
                  child: const Text('Accept Request'),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Show details'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Show_Request',
                        arguments: request);
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
