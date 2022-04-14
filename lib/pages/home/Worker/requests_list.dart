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
    //UserData? userData = user as UserData;
    final requests = Provider.of<List<Request>?>(context) ?? [];
    final user = Provider.of<User?>(context);

    //GETTING THE DATA OF THE WORKER
    bool noRequests = true;
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: ((context, snapshot) {
          print(
              '=================================================================================================');
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;

            List<Request> a = requests;
            //while (noRequests) {
            if (a.length >= 1) {
              // print(a.length);
              for (Request item in a) {
                // for (int i = 0; i >= a.length; i++)

                if (userData!.profession == item.profession) {
                  _markers.add(Marker(
                    markerId: MarkerId('SomeId'),
                    position: LatLng(item.latitude, item.longitude),
                    infoWindow: InfoWindow(title: item.Description),
                    onTap: () {
                      print('');
                    },

                    // Navigator.pushNamed(context, '/Show_Request',
                    //     arguments: item);
                  ));
                  // print(item.latitude);
                }
              }
              // List<Request> a = requests;
              print(a.length);
              //while (noRequests) {
              if (a.length >= 1) {
                for (var item in a) {
                  return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        if (userData!.profession ==
                            requests[index].profession) {
                          return worker_requets_tile(request: requests[index]);
                        }
                        return Text('data');
                      });
                }
              }
              // print(_markers.length);
              //noRequests = false;
              //print();
              // return Scaffold(
              //   body: SingleChildScrollView(
              //     child: ConstrainedBox(
              //       constraints: BoxConstraints(),
              //       child: IntrinsicHeight(
              //         child: Column(
              //           children: [
              //             SizedBox(
              //               width: 410,
              //               height: 300,
              //               child: GoogleMap(
              //                 mapType: MapType.normal,
              //                 markers: Set<Marker>.of(_markers),
              //                 myLocationButtonEnabled: false,
              //                 zoomControlsEnabled: false,
              //                 initialCameraPosition: CameraPosition(
              //                     target: LatLng(userData?.latitude as double,
              //                         userData?.longitude as double),
              //                     zoom: 14),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // );
            } else {
              return Text('You have no orders!');
            }
            //}

          }
          return Loading();
        }));
  }
}
