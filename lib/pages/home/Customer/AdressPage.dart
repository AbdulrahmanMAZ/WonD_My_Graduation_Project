import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;
import 'package:provider/provider.dart';

class AdressPage extends StatefulWidget {
  const AdressPage({Key? key}) : super(key: key);

  @override
  State<AdressPage> createState() => _AdressPageState();
}

class _AdressPageState extends State<AdressPage> {
  PermissionHandler.PermissionStatus? _permissionGranted;

  bool hasInternet = false;
  void initState() {
    super.initState();
    // widget.a += 1;
    PermissionHandler.Permission.location;
  }

  Location location = new Location();
  bool? _isServiceEnabled;
  // PermissionStatus _permissionGranted;
  LocationData? _locationData;
  bool _isListenLocation = false, isGetLocation = false;
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  Widget build(BuildContext context) {
    final usera = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: usera?.uid);
    Future SetLocation() async {
      var _locationStatus = await PermissionHandler.Permission.location.status;
      print(_locationStatus);

      if (!_locationStatus.isGranted) {
        await PermissionHandler.Permission.location.request();
      }
      if (await PermissionHandler.Permission.location.isGranted) {
        _locationData = await location.getLocation();
        _db.updateUserLocation(
            _locationData!.latitude, _locationData!.longitude);
      } else {
        showSimpleNotification(
            Text(
                'You must allow location access to continue\nTo do so, click on the location icon at the right top corner'),
            background: Colors.red);
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                SetLocation();
              },
              child: Text('Update Location'))),
    );
  }
}
