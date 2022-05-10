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

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    // void _showRequestStatus() {
    //   Scaffold(
    //       body: Container(
    //     child: workingpage(),
    //   ));
    // }

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
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          trailing: TextButton.icon(
              onPressed: () async {
                hasInternet = await InternetConnectionChecker().hasConnection;
                if (hasInternet) {
                  for (var item in _myAcceptedRequests) {
                    if (item.Cust_ID == userStream.uid) {
                      if (item.worker_ID != widget.acceptedRequest.worker_ID) {
                        // acc_list.add(item);
                        DatabaseService()
                            .AcceptenceCollection
                            .doc(item.worker_ID)
                            .delete() // <-- Delete
                            .then((_) => print('Accepted'))
                            .catchError(
                                (error) => print('Delete failed: $error'));
                      }
                      if (item.worker_ID == widget.acceptedRequest.worker_ID) {
                        DatabaseService(uid: item.worker_ID)
                            .updateRequestStatus(1);
                        DatabaseService()
                            .RequestsCollection
                            .doc(userStream.uid)
                            .delete() // <-- Delete
                            .then((_) => print('Deleted'))
                            .catchError(
                                (error) => print('Delete failed: $error'));

                        // DatabaseService().WorkingOnIt(
                        //     item.Cust_name,
                        //     item.Cust_ID,
                        //     item.worker_name,
                        //     item.worker_ID,
                        //     DateTime.now().millisecondsSinceEpoch,
                        //     item.price,
                        //     1);
                        // .then((value) => DatabaseService()
                        //     .AcceptenceCollection
                        //     .doc(item.worker_ID)
                        //     .delete());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => workingpage(item)));
                      }
                    }
                  }
                } else {
                  showSimpleNotification(Text('You have no connection!'),
                      background: Colors.red);
                }
              },
              icon: Icon(
                Icons.add,
                size: 20,
              ),
              label: Text(
                '',
                style: TextStyle(fontSize: 1),
              )),
          leading: SizedBox(
            height: 50,
            width: 50,
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
                            print(currentUser!.uid);

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
          title: RichText(
              text: TextSpan(
                  text: "${widget.acceptedRequest.worker_name} ",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 255, 0, 0)),
                  children: [
                TextSpan(
                    text: "Accepted your order for ",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 0, 0, 0))),
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
    );
  }
}
