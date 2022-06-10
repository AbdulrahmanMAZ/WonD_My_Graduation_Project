import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Customer/workingPage.dart';
import 'package:coffre_app/pages/home/Customer/profile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/storage.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class acceppted_Req_Tile extends StatefulWidget {
  final AcceptedRequest acceptedRequest;
  final List acc_list;

  acceppted_Req_Tile({required this.acceptedRequest, required this.acc_list});

  @override
  State<acceppted_Req_Tile> createState() => _acceppted_Req_TileState();
}

class _acceppted_Req_TileState extends State<acceppted_Req_Tile> {
  bool hasInternet = false;

  bool _isLoading = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    // 1. Using Timer
    Timer(Duration(seconds: 1), () {
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

  String? firebaseURL =
      'https://firebasestorage.googleapis.com/v0/b/coffe-app-a36f3.appspot.com/o/profile_images%2Ffd4f9e70-d099-11ec-8fcf-e11cc2ef35a3?alt=media&token=';

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    final _myAcceptedRequests =
        Provider.of<List<AcceptedRequest>?>(context) ?? [];
    final users = Provider.of<List<UserData>?>(context) ?? [];
    List<UserData>? a = users;
    final userStream = Provider.of<User>(context);
    var date = DateTime.fromMillisecondsSinceEpoch(widget.acceptedRequest.t);
    var h24 = DateFormat('dd/MM/yyyy, hh:mm a').format(date);
    bool Accepted = false;
    UserData? currentUser;
    try {
      for (UserData item in a) {
        if (item.uid == widget.acceptedRequest.worker_ID) {
          currentUser = item;
        }
      }
    } catch (e) {}
    return _isLoading
        ? Padding(
            padding: EdgeInsets.only(
              top: 8,
            ),
            child: Card(
              margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.delete_forever,
                          color: Color.fromARGB(255, 175, 76, 76),
                          size: 20,
                        ),
                        onPressed: () {
                          DatabaseService()
                              .AcceptenceCollection
                              .doc(widget.acceptedRequest.worker_ID)
                              .delete() // <-- Delete
                              .then((_) => print('Deleted other offers'))
                              .catchError(
                                  (error) => print('Delete failed: $error'));
                        }),
                    TextButton.icon(
                        onPressed: () async {
                          hasInternet =
                              await InternetConnectionChecker().hasConnection;
                          if (hasInternet) {
                            for (var item in _myAcceptedRequests) {
                              if (item.Cust_ID == userStream.uid) {
                                if (item.worker_ID !=
                                    widget.acceptedRequest.worker_ID) {
                                  //DELETE REQUEST FROM OTHER USERS WHO ACCEPTED REQUESTS
                                  DatabaseService()
                                      .AcceptenceCollection
                                      .doc(item.worker_ID)
                                      .delete() // <-- Delete
                                      .then(
                                          (_) => print('Deleted other offers'))
                                      .catchError((error) =>
                                          print('Delete failed: $error'));
                                }
                                if (item.worker_ID ==
                                    widget.acceptedRequest.worker_ID) {
                                  //UPDATE CURRENT STATUS TO ACCEPTED
                                  DatabaseService(uid: item.worker_ID)
                                      .updateRequestStatus(1);
                                  //DELETE REQUEST FROM CURRENT USER Requests
                                  DatabaseService()
                                      .RequestsCollection
                                      .doc(userStream.uid)
                                      .delete() // <-- Delete
                                      .then((_) => print('Deleted'))
                                      .catchError((error) =>
                                          print('Delete failed: $error'));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              workingpage(item)));
                                }
                              }
                            }
                          } else {
                            showSimpleNotification(
                                Text('You have no connection!'),
                                background: Colors.red);
                          }
                        },
                        icon: Icon(
                          Icons.handshake,
                          size: 20,
                        ),
                        label: Text(
                          '',
                          style: TextStyle(fontSize: 1),
                        )),
                  ],
                ),
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(firebaseURL! + currentUser!.uid!),
                      ),
                    ),
                  ),
                ),
                title: RichText(
                    text: TextSpan(
                        text: "${widget.acceptedRequest.worker_name} ",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 0, 0)),
                        children: [
                      TextSpan(
                          text: "Accepted your order for ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0))),
                      TextSpan(
                          text: "${widget.acceptedRequest.price}SR",
                          style: TextStyle(fontSize: 16, color: Colors.amber))
                    ])),
                subtitle: Text(h24),
                onTap: () async {
                  hasInternet = await InternetConnectionChecker().hasConnection;
                  if (hasInternet) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfile(
                                req: widget.acceptedRequest,
                              )),
                    );
                  } else {
                    showSimpleNotification(Text('You have no connection!'),
                        background: Colors.red);
                  }
                },
              ),
            ),
          )
        : Loading();
  }
}
