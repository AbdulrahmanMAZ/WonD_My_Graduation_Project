// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/Wrapper.dart';
import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/pages/home/Worker/OrdersMap.dart';
import 'package:coffre_app/pages/home/Worker/workerLocation.dart';
import 'package:coffre_app/pages/home/Worker/worker_drawer.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:coffre_app/pages/home/worker/worker_requests_tile.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/methods.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as PermssionHandler;
import 'package:provider/provider.dart';
import 'package:async/async.dart';

class worker_home extends StatefulWidget {
  const worker_home({Key? key}) : super(key: key);

  @override
  _worker_homeState createState() => _worker_homeState();
}

class _worker_homeState extends State<worker_home> {
  late Stream<UserData> userDATA;
  String? _currentAddress;
  Location location = new Location();

  PermissionStatus _permissionGranted = PermissionStatus.denied;
  bool? _isServiceEnabled;
  final user = FirebaseAuth.instance.currentUser!.uid;

  LocationData? _locationData;
  final AuthSrrvice _auth = AuthSrrvice();
  List<Marker> _markers = [];

  int counter = 0;

  @override
  void initState() {
    super.initState();
    final DatabaseService _db = DatabaseService(uid: user);
    final _userData = DatabaseService(uid: user).userData;
    this.userDATA = _userData;
    if (counter == 0) {
      setState(() {
        counter++;
      });
    }
  }

  int RefreshCounter = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: user?.uid);
    void locatepostion() async {
      //GET THE CURRENT USER DATA
      final users = Provider.of<List<UserData>?>(context) ?? [];
      List<UserData>? a = users;
      if (user?.uid != null) {
        UserData? wattinguser = await _db.getUser();

        if (RefreshCounter < 1)
          setState(() {
            RefreshCounter++;
          });
        UserData currentUser = wattinguser;

        try {
          List<geoCoding.Placemark> placemarks =
              await geoCoding.placemarkFromCoordinates(
                  currentUser.latitude as double,
                  currentUser.longitude as double);

          geoCoding.Placemark place1 = placemarks[0];
          geoCoding.Placemark place2 = placemarks[1];

          _currentAddress =
              "${place2.locality}  ${place2.country} ${place1.street}  ";
        } catch (e) {
          print(e.toString());
        }
      }
    }

    double _radius = 30000.0;

    final requests = Provider.of<List<Request>?>(context) ?? [];

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
        await _db.updateUserLocation(
            _locationData!.latitude, _locationData!.longitude);
        print(_permissionGranted);
      }
      print('$_permissionGranted');
      try {
        await PermssionHandler.Permission.location.request();
      } catch (e) {
        print(e.toString());
      }
      if (await PermssionHandler.Permission.location.isDenied) {
        Navigator.pushNamed(context, '/SetWorkerLocation');
      }

      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }

    SetLocation();
    locatepostion();

    String firebaseURL =
        'https://firebasestorage.googleapis.com/v0/b/coffe-app-a36f3.appspot.com/o/profile_images%2Ffd4f9e70-d099-11ec-8fcf-e11cc2ef35a3?alt=media&token=';
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.Allbackgroundcolor,
        drawer: worker_drawer(
          username: user?.displayName,
          logout: TextButton.icon(
            icon: Icon(Icons.logout),
            label: Text('logout'),
            onPressed: () async {
              Navigator.of(context).pop();
              await _auth.SignOut();

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Wrapper()),
                  (Route<dynamic> route) => false);
            },
          ),
        ),
        appBar: MyCustomAppBar(
          name: _currentAddress ?? '',
          widget: [
            IconButton(
                onPressed: () {
                  setState(() {
                    SetLocation();
                  });
                },
                icon: Icon(Icons.location_pin))
          ],
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/OrdersMap');
              },
              child: Text('Open a Map of the nearby Orders')),
        ));
  }
}
