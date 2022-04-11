// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';

import 'package:coffre_app/pages/home/worker/worker_requests_tile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
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
    final requests = Provider.of<List<Request>?>(context) ?? [];
    final user = Provider.of<User?>(context);

    //GETTING THE DATA OF THE WORKER
    bool noRequests = true;
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData2,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;

            List<Request> a = requests;
            //while (noRequests) {
            if (a.length >= 1) {
              for (var item in a) {
                return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      if (userData!.profession == requests[index].profession) {
                        return worker_requets_tile(request: requests[index]);
                      }

                      noRequests = false;
                      //print();
                      return Text('kkkk');
                    });
              }
            } else {
              return Text('You have no orders!');
            }
            //}

          }
          return Loading();
        }));
  }
}
