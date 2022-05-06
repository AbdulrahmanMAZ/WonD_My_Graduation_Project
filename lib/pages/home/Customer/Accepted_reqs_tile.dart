import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Customer/workingPage.dart';
import 'package:coffre_app/pages/home/profile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class acceppted_Req_Tile extends StatelessWidget {
  final AcceptedRequest acceptedRequest;
  final List acc_list;

  bool hasInternet = false;
  acceppted_Req_Tile({required this.acceptedRequest, required this.acc_list});

  @override
  Widget build(BuildContext context) {
    // void _showRequestStatus() {
    //   Scaffold(
    //       body: Container(
    //     child: workingpage(),
    //   ));
    // }

    final _myAcceptedRequests =
        Provider.of<List<AcceptedRequest>?>(context) ?? [];
    final userStream = Provider.of<User>(context);
    var date = DateTime.fromMillisecondsSinceEpoch(acceptedRequest.t);
    var h24 = DateFormat('dd/MM/yyyy, hh:mm a').format(date);
    bool Accepted = false;
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
                      if (item.worker_ID != acceptedRequest.worker_ID) {
                        // acc_list.add(item);
                        DatabaseService()
                            .AcceptenceCollection
                            .doc(item.worker_ID)
                            .delete() // <-- Delete
                            .then((_) => print('Accepted'))
                            .catchError(
                                (error) => print('Delete failed: $error'));
                      }
                      if (item.worker_ID == acceptedRequest.worker_ID) {
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
          leading: CircleAvatar(
            backgroundColor: Colors.brown[200],
            radius: 25,
          ),
          title: RichText(
              text: TextSpan(
                  text: "${acceptedRequest.worker_name} ",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 255, 0, 0)),
                  children: [
                TextSpan(
                    text: "Accepted your order for ",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 0, 0, 0))),
                TextSpan(
                    text: "${acceptedRequest.price}SR",
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
                          req: acceptedRequest,
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
