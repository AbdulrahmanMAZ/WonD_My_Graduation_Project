import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';

import 'package:coffre_app/pages/home/worker/worker_requests_tile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestsList extends StatefulWidget {
  const RequestsList({Key? key}) : super(key: key);

  @override
  _RequestsListState createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  @override
  Widget build(BuildContext context) {
    //UserData? userData = user as UserData;
    final custRequests = Provider.of<List<Request>?>(context) ?? [];
    final user = Provider.of<User>(context);

    //GETTING THE DATA OF THE WORKER
    bool noRequests = true;
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            UserData? workerData = snapshot.data;

            List<Request> a = custRequests;
            //while (noRequests) {
            //  for (var item in a) {}
            if (a.length >= 1)
              return ListView.builder(
                  itemCount: custRequests.length,
                  itemBuilder: (context, index) {
                    if (workerData!.profession ==
                        custRequests[index].profession) {
                      return worker_requets_tile(request: custRequests[index]);
                    }

                    noRequests = false;
                    //print();
                    return Text('');
                  });
            //}
          }
          return Loading();
        }));
  }
}
