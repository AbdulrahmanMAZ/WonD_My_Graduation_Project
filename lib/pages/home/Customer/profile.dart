import 'dart:async';
import 'dart:math';

import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/Worker/worker_feedback_tile.dart';
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
  String? firebaseURL =
      'https://firebasestorage.googleapis.com/v0/b/coffe-app-a36f3.appspot.com/o/profile_images%2Ffd4f9e70-d099-11ec-8fcf-e11cc2ef35a3?alt=media&token=';

  bool _isLoading = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    // 1. Using Timer
    Timer(Duration(seconds: 0), () {
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
    int itreation = 0;
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
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
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
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(firebaseURL! + usera!.uid),
                            ),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(currentUser!.email as String,
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
                        double avregeRating = 1;
                        List<Rate>? userRate = snapshot.data;
                        if (userRate != null) {
                          for (var item in userRate) {
                            avregeRating += item.rate;
                          }
                        }

                        int Number_of_ratings = userRate!.length;
                        if (Number_of_ratings <= 0) {
                          Number_of_ratings = 1;
                        }

                        if (userRate.isEmpty) {
                          itreation = 0;
                        }
                        if (userRate.length <= 3 && userRate.isNotEmpty) {
                          itreation = userRate.length;
                        }

                        if (userRate.length > 3) {
                          itreation = 3;
                        }
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(150, 0, 150, 0),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            '${(avregeRating / Number_of_ratings).toStringAsFixed(1)}',
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: itreation,
                                itemBuilder: (context, index) {
                                  //                 if (userRate != null) {
                                  //   for (var item in userRate) {
                                  //     avregeRating += item.rate;
                                  //   }
                                  // }
                                  final _random = new Random();
                                  userRate[_random.nextInt(userRate.length)];
                                  var element = userRate[
                                      _random.nextInt(userRate.length)];
                                  if (userRate != null) {
                                    return worker_feedback_tile(
                                        rate: element.rate,
                                        name: element.name,
                                        feedback: element.feedback);
                                  }
                                  return Loading();
                                }),
                          ],
                        );
                      } else {
                        return Loading();
                      }
                    }),
                (itreation > 0)
                    ? TextButton(
                        child: Text('See More! Feedbacks'),
                        onPressed: () {
                          // TO DO GO TO ALL FEEDBACKS PAGE
                          Navigator.pushNamed(context, '/FeedBack',
                              arguments: widget.req);
                        },
                      )
                    : (itreation == 0)
                        ? Text('No Feedbacks yet')
                        : Text('There is no more feedbacks')
              ],
            ),
          ),
        ));
  }
}
