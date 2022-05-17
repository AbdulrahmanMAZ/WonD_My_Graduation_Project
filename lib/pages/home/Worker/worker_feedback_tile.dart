import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Customer/profile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class worker_feedback_tile extends StatelessWidget {
  final double rate;

  final String? feedback;
  final String? name;
  const worker_feedback_tile(
      {Key? key,
      required this.rate,
      required this.feedback,
      required this.name})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: user?.uid);
    double price;
    return Center(
      child: Card(
        color: Color.fromARGB(255, 51, 1, 59),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Row(
                children: [
                  Text("${name as String} "),
                  Text(rate.toString()),
                  Icon(
                    Icons.star_rate_sharp,
                    size: 15,
                  )
                ],
              ),
              subtitle: Text(feedback as String),
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }
}
