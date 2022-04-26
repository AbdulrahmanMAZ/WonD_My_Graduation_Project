// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/pages/home/Worker/worker_drawer.dart';

import 'package:coffre_app/pages/home/worker/worker_requests_tile.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/methods.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/shared/constant.dart';
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
  Location location = new Location();

  PermissionStatus _permissionGranted = PermissionStatus.denied;
  bool? _isServiceEnabled;
  //  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final AuthSrrvice _auth = AuthSrrvice();
  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    double _radius = 30000.0;
    //UserData? userData = user as UserData;
    final requests = Provider.of<List<Request>?>(context) ?? [];
    final user = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: user?.uid);
    //GETTING THE DATA OF THE WORKER
    bool noRequests = true;
    Future SetLocation() async {
      _isServiceEnabled = await location.serviceEnabled();
      if (!_isServiceEnabled!) {
        _isServiceEnabled = await location.requestService();
        if (_isServiceEnabled!) return;
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        _locationData = await location.getLocation();
        _db.updateUserLocation(
            _locationData!.latitude, _locationData!.longitude);
      }
      if (_permissionGranted == PermissionStatus.denied) {
        print(_permissionGranted);
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.granted) {}
      }
    }

    SetLocation();
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

              if (userData!.profession == item.profession &&
                  distance(userData.latitude, item.latitude, userData.longitude,
                          item.longitude) <
                      30) {
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
            _markers.add(Marker(
                markerId: MarkerId(userData?.name as String),
                position: LatLng(userData?.latitude as double,
                    userData?.longitude as double),
                icon: BitmapDescriptor.defaultMarkerWithHue(180)));
            // print('${a.length}  kkkkkkkkkkkkkkkkkkkkkkkkkk');
            //while (noRequests) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.Allbackgroundcolor,
              drawer: worker_drawer(
                username: user?.displayName,
                logout: TextButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('logout'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _auth.SignOut();
                  },
                ),
              ),
              appBar: MyCustomAppBar(
                name: 'Nearby Customers',
                widget: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          SetLocation();
                        });
                        //Future.delayed(Duration(seconds: 5));
                        // setState(() {});
                      },
                      icon: Icon(Icons.location_pin))
                ],
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
                              //liteModeEnabled: true,
                              mapType: MapType.normal,
                              markers: Set<Marker>.of(_markers),
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: true,
                              zoomGesturesEnabled: true,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(userData?.latitude as double,
                                      userData?.longitude as double),
                                  zoom: 9.5),
                              scrollGesturesEnabled: false,
                              minMaxZoomPreference: MinMaxZoomPreference(9, 15),
                              circles: {
                                Circle(
                                    circleId:
                                        CircleId(userData!.name as String),
                                    center: LatLng(userData.latitude as double,
                                        userData.longitude as double),
                                    radius: _radius,
                                    strokeWidth: 2,
                                    strokeColor: Colors.red)
                              },
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
