import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final AcceptedRequest? req;

  UserProfile({this.req});

  //const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(
          //title: Text(widget.name as String),
          ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundColor: Colors.brown[200],
              radius: 40,
            ),
            Text('${widget.req?.worker_name}'),
            StreamBuilder<List<Rate>>(
                stream: DatabaseService(uid: widget.req?.worker_ID).ratee,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    double avregeRating = 0;
                    List<Rate>? userRate = snapshot.data;
                    if (userRate != null) {
                      for (var item in userRate) {
                        avregeRating += item.rate;
                      }
                    }
                    return Text(
                      '${avregeRating / userRate!.length}',
                      style: TextStyle(color: Colors.amber, fontSize: 50),
                    );
                  } else {
                    return Loading();
                  }
                })
          ],
        ),
      ),
    );
  }
}
