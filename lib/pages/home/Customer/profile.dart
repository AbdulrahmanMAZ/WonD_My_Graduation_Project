import 'dart:async';

import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/storage.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserProfile extends StatefulWidget {
  final AcceptedRequest? req;

  UserProfile({this.req});

  //const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isLoading = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    // 1. Using Timer
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isLoading = true;
      });
    });
    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    final _formKey = GlobalKey<FormState>();
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
    bool imageuploaded = false;
    var Path;
    var FileName = "no_image_in_firebase.png";
    UserData? currentUser;
    final users = Provider.of<List<UserData>?>(context) ?? [];
    List<UserData>? a = users;
    try {
      for (UserData item in a) {
        if (item.uid == widget.req!.worker_ID) {
          currentUser = item;
        }
      }
    } catch (e) {}
    final user = Provider.of<User?>(context);
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Center(
              child: Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: _isLoading
                            ? FutureBuilder(
                                future: storage.downloadProfileImageURL(
                                    currentUser!.profileImage as String),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return Container(
                                      child: Image.network(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                        color: Colors.grey,
                                        colorBlendMode: BlendMode.multiply,
                                      ),
                                    );
                                  }
                                  return Loading();
                                },
                              )
                            : Loading(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            if (currentUser?.name != null && usera != null)
              Column(
                children: [
                  Text(
                    currentUser?.name as String,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(usera.email as String,
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text(currentUser?.phoneNumber as String,
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
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

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(150, 0, 150, 0),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${avregeRating / userRate!.length}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    )),
                                Text('(${userRate.length})',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.amber)),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Rating",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Loading();
                  }
                }),
          ],
        ));
  }
}
