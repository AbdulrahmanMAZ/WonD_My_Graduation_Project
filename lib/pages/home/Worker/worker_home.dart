// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/pages/home/Worker/worker_drawer.dart';

import 'package:coffre_app/pages/home/worker/worker_requests_tile.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class worker_home extends StatefulWidget {
  const worker_home({Key? key}) : super(key: key);

  @override
  _worker_homeState createState() => _worker_homeState();
}

class _worker_homeState extends State<worker_home> {
  final AuthSrrvice _auth = AuthSrrvice();
  List<Marker> _markers = [];
  @override
  Widget build(BuildContext context) {
    //UserData? userData = user as UserData;
    final requests = Provider.of<List<Request>?>(context) ?? [];
    final user = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: user?.uid);
    //GETTING THE DATA OF THE WORKER
    bool noRequests = true;
    setState(() {
      _db.updateUserLocation(16.905971167609255, 42.573032566335506);
    });
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user?.uid).userData,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            // _markers.add(Marker(
            //     markerId: MarkerId('SomeId'),
            //     position: LatLng(userData?.latitude as double,
            //         userData?.longitude as double),
            //     infoWindow: InfoWindow(title: userData?.name)));
            List<Request> a = requests;
            for (Request item in a) {
              // for (int i = 0; i >= a.length; i++)
              print(
                  '${item.profession}=================================================================================================');

              if (userData!.profession == item.profession) {
                _markers.add(Marker(
                  markerId: MarkerId('${item.name}'),
                  position: LatLng(item.latitude, item.longitude),
                  infoWindow: InfoWindow(title: item.Description),
                  onTap: () {
                    // print('${item.name}');
                    Navigator.pushNamed(context, '/Show_Request',
                        arguments: item);
                  },
                ));
                // print(item.latitude);
              }
            }
            // print('${a.length}  kkkkkkkkkkkkkkkkkkkkkkkkkk');
            //while (noRequests) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.brown[50],
              drawer: worker_drawer(
                username: user?.displayName,
                logout: TextButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('logout'),
                  onPressed: () async {
                    await _auth.SignOut();
                  },
                ),
              ),
              appBar: MyCustomAppBar(
                name: 'Nearby Customers',
                widget: [],
              ),
              body: Scaffold(
                body: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 410,
                            height: 300,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              markers: Set<Marker>.of(_markers),
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(userData?.latitude as double,
                                      userData?.longitude as double),
                                  zoom: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
            //}

          }
          return Loading();
        }));
  }
}
