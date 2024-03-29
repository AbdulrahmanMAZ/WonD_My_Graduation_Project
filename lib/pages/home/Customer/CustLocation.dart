import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/pages/home/Worker/worker_home.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class setLocationCustomer extends StatelessWidget {
  setLocationCustomer({Key? key}) : super(key: key);
  Location location = new Location();

  PermissionStatus _permissionGranted = PermissionStatus.denied;
  bool? _isServiceEnabled;
  //  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final AuthSrrvice _auth = AuthSrrvice();
  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: user?.uid);
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
        Navigator.pushNamed(context, '/cust_home');
      }
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.granted) {
          Navigator.pushNamed(context, '/cust_home');
        }
      }
    }

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You Must Set Your Location To Use The APP!"),
          TextButton(
              child: Text('Set Location'),
              onPressed: () {
                SetLocation();
              }),
          TextButton(
              child: Text('Go To Sign In Page'),
              onPressed: () {
                AuthSrrvice().SignOut();
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => SignIn()));
              })
        ],
      ),
    ));
  }
}
