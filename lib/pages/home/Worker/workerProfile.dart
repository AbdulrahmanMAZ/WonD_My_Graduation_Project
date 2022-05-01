import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
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
    UserData? currentUser;
    final users = Provider.of<List<UserData>?>(context) ?? [];
    List<UserData>? a = users;
    try {
      for (UserData item in a) {
        if (item.uid == usera!.uid) {
          currentUser = item;
        }
      }
    } catch (e) {}
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: NetworkImage(
                            "https://images.unsplash.com/photo-1649636269015-d92f1f08f11d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60"),
                        fit: BoxFit.cover,
                        width: 128,
                        height: 128,
                        child: InkWell(onTap: () {}),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 17,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Column(
              children: [
                Text(
                  currentUser?.name as String,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(usera?.email as String,
                    style: TextStyle(
                      color: Colors.grey,
                    )),
                SizedBox(
                  height: 5,
                ),
                Text('data',
                    style: TextStyle(
                      color: Colors.grey,
                    )),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            StreamBuilder<List<Rate>>(
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
                    return Text('${avregeRating / userRate!.length}');
                  } else {
                    return Loading();
                  }
                }),
          ],
        ));
  }
}

class MyClip extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, 100, 100);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}
