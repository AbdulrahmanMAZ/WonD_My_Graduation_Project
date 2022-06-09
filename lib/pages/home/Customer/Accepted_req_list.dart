import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Customer/Accepted_reqs_tile.dart';
import 'package:coffre_app/pages/home/Customer/First_Request_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AcceptedRequestsList extends StatefulWidget {
  @override
  _AcceptedRequestsListState createState() => _AcceptedRequestsListState();
}

class _AcceptedRequestsListState extends State<AcceptedRequestsList> {
  @override
  Widget build(BuildContext context) {
    final usera = Provider.of<User?>(context);
    final _myAcceptedRequests =
        Provider.of<List<AcceptedRequest>?>(context) ?? [];
    List<AcceptedRequest> Workers_Who_Accepted = [];
    for (var item in _myAcceptedRequests) {
      if (item.Cust_ID == usera?.uid) {
        if (item.Status == 0) Workers_Who_Accepted.add(item);
      }
    }

    Workers_Who_Accepted.sort(
        (a, b) => double.parse(a.price).compareTo(double.parse(b.price)));

    return ListView.builder(
        itemCount: Workers_Who_Accepted.length,
        itemBuilder: (context, index) {
          //print(users[index].);

          return acceppted_Req_Tile(
              acceptedRequest: Workers_Who_Accepted[index],
              acc_list: Workers_Who_Accepted);
        });
  }
}
