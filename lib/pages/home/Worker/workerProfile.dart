import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final usera = Provider.of<User?>(context);
    // final _myrates = Provider.of<List<Rate>?>(context) ?? [];

    // List<Rate> Rates = _myrates;

    // for (Rate item in Rates) {
    //   // Rates.add(item);
    // }
    // for (var item in Rates) {
    //   //   {
    //   //     a
    //   //   }
    //   //   ;
    // }
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<List<Rate>>(
            stream: DatabaseService(uid: usera?.uid).ratee,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                double avregeRating = 0;
                List<Rate>? userRate = snapshot.data;
                if (userRate != null) {
                  for (var item in userRate) {
                    avregeRating += item.rate;
                  }
                }
                return Text('${avregeRating}');
              } else {
                return Loading();
              }
            }));
  }
}
