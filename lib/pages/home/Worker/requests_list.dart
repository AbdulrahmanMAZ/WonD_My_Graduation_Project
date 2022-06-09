// import 'dart:html';

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';

import 'package:coffre_app/pages/home/worker/worker_requests_tile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/methods.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class RequestsList extends StatefulWidget {
  const RequestsList({Key? key}) : super(key: key);

  @override
  _RequestsListState createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  List<Marker> _markers = [];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final requests = Provider.of<List<Request>?>(context) ?? [];
    final _acceptedRequest = Provider.of<List<AcceptedRequest>?>(context) ?? [];
    final user = Provider.of<User?>(context);
    bool noRequests = true;

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            bool hasAccepted = false;
            List<Request> a = requests;
            List<AcceptedRequest> b = _acceptedRequest;

            List<Request> RealComingRequests = [];
            List<AcceptedRequest> AcceptedRequests = [];
            for (AcceptedRequest item in b) {
              if (item.worker_ID == user!.uid) {
                hasAccepted = true;
              }
            }
            if (!hasAccepted)
              for (Request item in a) {
                if (userData!.profession == item.profession &&
                    distance(userData.latitude, item.latitude,
                            userData.longitude, item.longitude) <
                        30) {
                  RealComingRequests.add(item);
                }
              }
            RealComingRequests.sort((a, b) => distance(userData!.latitude,
                    a.latitude, userData.longitude, a.longitude)
                .compareTo(distance(userData.latitude, b.latitude,
                    userData.longitude, b.longitude)));
            if (RealComingRequests.length >= 1) {
              return ListView.builder(
                  itemCount: RealComingRequests.length,
                  itemBuilder: (context, index) {
                    if (userData?.profession ==
                        RealComingRequests[index].profession) {
                      return worker_requets_tile(
                          request: RealComingRequests[index],
                          distance: distance(
                              userData?.latitude,
                              RealComingRequests[index].latitude,
                              userData?.longitude,
                              RealComingRequests[index].longitude));
                    }
                    return Text('data');
                  });
            } else {
              return Container(
                height: height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color.fromARGB(255, 73, 3, 105),
                      Color.fromARGB(255, 15, 7, 1)
                    ])),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/Error_face.png'),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Sorry, no nearby orders',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          return Loading();
        }));
  }
}
