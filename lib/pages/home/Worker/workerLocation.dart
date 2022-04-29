import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/pages/home/Worker/worker_home.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;
import 'package:provider/provider.dart';

class setLocationWorker extends StatefulWidget {
  setLocationWorker({Key? key}) : super(key: key);

  @override
  State<setLocationWorker> createState() => _setLocationWorkerState();
}

class _setLocationWorkerState extends State<setLocationWorker> {
  Location location = new Location();

  PermissionStatus _permissionGranted = PermissionStatus.denied;

  // bool? _isServiceEnabled;

  //  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final AuthSrrvice _auth = AuthSrrvice();
  // final AuthSrrvice _auth = AuthSrrvice();

  // List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    // final DatabaseService _db = DatabaseService(uid: user?.uid);
    // Future checkPermission() async {
    //   _permissionGranted = await location.hasPermission();
    // }

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You Must Set Your Location To Use The APP!"),
          TextButton(
              child: Text('Go to settings'),
              onPressed: () async {
                await PermissionHandler.openAppSettings();
                // Future.delayed(Duration(seconds: 5));
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/worker_home', (Route<dynamic> route) => false);
                //setState(() {});
              }),
          TextButton(
              child: Text('Press here when you enabled location permissions.'),
              onPressed: () async {
                _permissionGranted = await location.hasPermission();
                if (_permissionGranted == PermissionStatus.granted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/worker_home', (Route<dynamic> route) => false);
                }
                // Future.delayed(Duration(seconds: 5));
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/worker_home', (Route<dynamic> route) => false);
                //setState(() {});
              }),
          TextButton(
              child: Text('Sign Out and Go To Sign In Page'),
              onPressed: () {
                _auth.SignOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              })
        ],
      ),
    ));
  }
}
