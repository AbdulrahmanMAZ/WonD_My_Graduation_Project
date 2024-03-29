import 'dart:async';
import 'dart:math';

import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/Worker/worker_feedback_tile.dart';
import 'package:coffre_app/pages/home/Worker/worker_home.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/storage.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/shared/feedbacks.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 1. Using Timer
    Timer(Duration(seconds: 2), () {
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

  bool imageuploaded = false;
  var Path;
  var FileName = "no_image_in_firebase.png";
  String? firebaseURL =
      'https://firebasestorage.googleapis.com/v0/b/coffe-app-a36f3.appspot.com/o/profile_images%2F';
  int ListLeangth = 0;
  @override
  Widget build(BuildContext context) {
    List<Rate> UserRate = Provider.of<List<Rate>>(context);
    int itreation = 0;
    final Storage storage = Storage();
    final _formKey = GlobalKey<FormState>();
    final usera = Provider.of<User?>(context);

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
    print(a.length);

    return _isLoading
        ? Scaffold(
            appBar: MyCustomAppBar(
              name: '',
              widget: [],
            ),
            body: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          if (usera!.uid != null)
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: _isLoading
                                      ? FutureBuilder(
                                          future:
                                              storage.downloadProfileImageURL(
                                                  currentUser?.profileImage
                                                      as String),
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
                                                  colorBlendMode:
                                                      BlendMode.multiply,
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
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 17,
                                child: IconButton(
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(
                                            allowMultiple: false,
                                            type: FileType.custom,
                                            allowedExtensions: ['png', 'jpg']);
                                    if (result == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('No Image is There'),
                                        ),
                                      );
                                      return null;
                                    }
                                    setState(() {
                                      Path = result.files.single.path!;
                                      FileName = result.files.single.name;
                                      setState(() {
                                        this.imageuploaded = true;
                                      });
                                    });
                                    print(Path + ' -- ' + FileName);
                                    final UUID = Uuid().v1();
                                    if (FileName !=
                                        "no_image_in_firebase.png") {
                                      await DatabaseService(uid: usera!.uid)
                                          .updateUserImage(UUID);

                                      storage
                                          .uploudProfileImage(Path, UUID)
                                          .then((value) => print('Uplouded'));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  worker_home()));
                                      showSimpleNotification(
                                          Text('Your image has been updated'),
                                          background:
                                              Color.fromARGB(255, 6, 240, 103));
                                    }
                                  },
                                  icon: Icon(Icons.edit,
                                      color: Colors.white, size: 20),
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
                            dynamic Number_of_ratings = userRate!.length;
                            if (Number_of_ratings <= 0) {
                              Number_of_ratings = '0';
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
                            ListLeangth = userRate.length;
                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(150, 0, 150, 0),
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (Number_of_ratings == '0')
                                              Text('0',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                  )),
                                            if (Number_of_ratings != '0')
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
                                      userRate[
                                          _random.nextInt(userRate.length)];
                                      var element = userRate[
                                          _random.nextInt(userRate.length)];
                                      if (userRate != null) {
                                        return worker_feedback_tile(
                                            name: element.name,
                                            rate: element.rate,
                                            feedback: element.feedback);
                                      }
                                      return Loading();
                                    }),
                                (itreation > 0)
                                    ? TextButton(
                                        child: Text('See More! Feedbacks'),
                                        onPressed: () {
                                          // TO DO GO TO ALL FEEDBACKS PAGE
                                          Navigator.pushNamed(
                                              context, '/FeedBack2',
                                              arguments: userRate);
                                        },
                                      )
                                    : (itreation == 0)
                                        ? Text('No Feedbacks or Rates yet')
                                        : Text('There is no more feedbacks')
                              ],
                            );
                          } else {
                            return Loading();
                          }
                        }),
                  ],
                ),
              ),
            ))
        : Loading();
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

class NumbersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, '4.8', 'Ranking'),
          buildDivider(),
          buildButton(context, '35', 'Following'),
          buildDivider(),
          buildButton(context, '50', 'Followers'),
        ],
      );
  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
