import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/Wrapper.dart';
import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:coffre_app/pages/home/Customer/Accepted_req_list.dart';
import 'package:coffre_app/pages/home/Customer/AdressPage.dart';
import 'package:coffre_app/pages/home/Customer/Cust_orders.dart';
import 'package:coffre_app/pages/home/Customer/MakeOrder.dart';
import 'package:coffre_app/pages/home/Customer/accepted_reqs.dart';
import 'package:coffre_app/pages/home/Customer/settings_forms.dart';
import 'package:coffre_app/pages/home/Customer/Users_List.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/pages/home/Customer/Cust_drawer.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;

class Cust_Home extends StatefulWidget {
  int a = 0;
  @override
  State<Cust_Home> createState() => _Cust_HomeState();
}

class _Cust_HomeState extends State<Cust_Home> {
  bool _isLoading = false;
  PermissionStatus? _permissionGranted;
  String? _currentAddress;
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
  int RefreshCounter = 0;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final CollectionReference aaa =
        FirebaseFirestore.instance.collection('coffes');
    final usera = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: usera?.uid);

    //LOCATION IN TITLE
    void locatepostion() async {
      //GET THE CURRENT USER DATA
      final users = Provider.of<List<UserData>?>(context) ?? [];
      List<UserData>? a = users;
      if (usera?.uid != null) {
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

    void _showAppSettings(profession) {
      try {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MakeOrder(profession: profession)));
      } catch (e) {
        print("${e.toString()} You have already signed out.");
      }
    }

    final _myAcceptedRequests =
        Provider.of<List<AcceptedRequest>?>(context) ?? [];
    List<AcceptedRequest> Workers_Who_Accepted = [];
    bool newItem = true;
    for (AcceptedRequest item in _myAcceptedRequests) {
      if (item.Cust_ID == usera?.uid) Workers_Who_Accepted.add(item);
    }

    Future SetLocation(a) async {
      var _locationStatus = await PermissionHandler.Permission.location.status;
      print(_locationStatus);
      if (!_locationStatus.isGranted) {
        await PermissionHandler.Permission.location.request();
      }
      if (await PermissionHandler.Permission.location.isGranted) {
        _locationData = await location.getLocation();
        _db.updateUserLocation(
            _locationData!.latitude, _locationData!.longitude);
        _showAppSettings(a);
      } else {
        showSimpleNotification(
            Text(
                'You must allow location access to continue\nTo do so, click on the location icon at the right top corner'),
            background: Colors.red);
      }
    }
    //   _isServiceEnabled = await location.serviceEnabled();
    //   if (!_isServiceEnabled!) {
    //     _isServiceEnabled = await location.requestService();
    //     if (_isServiceEnabled!) return;
    //   }

    //   _permissionGranted = await location.hasPermission();
    //   if (_permissionGranted == PermissionStatus.granted) {
    //     _locationData = await location.getLocation();
    //     _db.updateUserLocation(
    //         _locationData!.latitude, _locationData!.longitude);
    //   }
    //   if (_permissionGranted == PermissionStatus.denied) {
    //     print(_permissionGranted);
    //     // setState(() {});
    //     _permissionGranted = await location.requestPermission();
    //     if (_permissionGranted == PermissionStatus.granted) {}
    //   }
    //   // _db.updateUserLocation(16.905971167609255, 42.573032566335506);

    // SetLocation();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    locatepostion();
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthSrrvice().user,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.Allbackgroundcolor,

        drawer: CustDrawer(
          username: usera?.displayName as String?,
          logout: TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              // setState(() {});
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => Cust_Home()));
              await _auth.SignOut();
              await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Wrapper()),
                  (Route<dynamic> route) => false);

              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => SignIn()));
              // Navigator.of(context).pop();
              // Navigator.pushReplacementNamed(context, '/login');

              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => SignIn()));
            },
          ),
        ),

        appBar: MyCustomAppBar(name: _currentAddress ?? '', widget: [
          IconButton(
              onPressed: () async {
                if (await PermissionHandler.Permission.location.isDenied)
                  setState(() {
                    PermissionHandler.openAppSettings();
                  });
                else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdressPage()));
                }
              },
              icon: Icon(Icons.location_pin)),
          IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.handyman,
                  ),
                  if (Workers_Who_Accepted.isNotEmpty &&
                      Workers_Who_Accepted[0].Status == 0)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                Workers_Who_Accepted.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () async => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Accepted_Orders()))
                  })

          // TextButton.icon(

          //   onPressed: () async {
          // _isServiceEnabled = await location.serviceEnabled();
          // if (!_isServiceEnabled!) {
          //   _isServiceEnabled = await location.requestService();
          //   if (_isServiceEnabled!) return;
          // }

          // _permissionGranted = await location.hasPermission();
          // if (_permissionGranted == PermissionStatus.granted) {
          // _locationData = await location.getLocation();
          // _db.updateUserLocation(
          //     _locationData!.latitude, _locationData!.longitude);
          //   return _showAppSettings();
          // }
          // if (_permissionGranted == PermissionStatus.denied) {
          //   print(_permissionGranted);
          //   _permissionGranted = await location.requestPermission();
          //   if (_permissionGranted == PermissionStatus.granted) {
          //     return _showAppSettings();
          //   }
          // }
          //   },
          //   icon: Icon(Icons.handyman),
          //   label: Text('Rquests'),
          // ),
        ]),

        //  AppBar(
        //   title: Text('Your requests'),
        //   backgroundColor: Colors.brown[400],
        //   elevation: 0.0,
        //   shadowColor: Colors.black,
        //   actions: <Widget>[
        //     TextButton.icon(
        //         onPressed: () {
        //           _showAppSettings();
        //         },
        //         icon: Icon(Icons.front_hand),
        //         label: Text('Rquest Service'))
        //   ],
        // ),
        body: Container(
          height: height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(255, 73, 3, 105),
                Color.fromARGB(255, 15, 7, 1)
              ])),
          child: Stack(
            children: [
              PositionedBackground(context),
              Container(
                child: SingleChildScrollView(
                  child: Wrap(children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () async {
                          hasInternet =
                              await InternetConnectionChecker().hasConnection;
                          if (hasInternet) {
                            if (Workers_Who_Accepted.isEmpty) {
                              if (await PermissionHandler
                                  .Permission.location.isGranted)
                                return _showAppSettings("Electrician");
                              else {
                                return setState(() {
                                  SetLocation("Electrician");
                                });
                              }
                            } else {
                              showSimpleNotification(
                                  Text('You have an On-going request!'),
                                  background: Colors.red);
                            }
                          } else {
                            showSimpleNotification(
                                Text('You have no connection!'),
                                background: Colors.red);
                          }
                        },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                "images/fix fesh.jpg",
                                color: Color.fromARGB(255, 136, 135, 135),
                                colorBlendMode: BlendMode.darken,
                                //alignment: ,
                                fit: BoxFit.cover,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Electrion",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () async {
                          hasInternet =
                              await InternetConnectionChecker().hasConnection;
                          if (hasInternet) {
                            if (Workers_Who_Accepted.isEmpty) {
                              if (await PermissionHandler
                                  .Permission.location.isGranted)
                                return _showAppSettings("plumber");
                              else {
                                return setState(() {
                                  SetLocation('plumber');
                                });
                              }
                            } else {
                              showSimpleNotification(
                                  Text('You have an On-going request!'),
                                  background: Colors.red);
                            }
                          } else {
                            showSimpleNotification(
                                Text('You have no connection!'),
                                background: Colors.red);
                          }
                        },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                "images/brken sink.jpg",
                                color: Color.fromARGB(255, 211, 210, 210),
                                colorBlendMode: BlendMode.darken,
                                //alignment: ,
                                fit: BoxFit.cover,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "plumbing",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.settings),
        //   onPressed: () {},
        // )
        //  FutureBuilder<DocumentSnapshot>(
        //     future: coffes.doc(_auth.inputData()).get(),
        //     builder:
        //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //       if (snapshot.hasError) {
        //         return Text("Something went wrong");
        //       }

        //       if (snapshot.hasData && !snapshot.data!.exists) {
        //         return Text("Document does not exist");
        //       }

        //       if (snapshot.connectionState == ConnectionState.done) {
        //         Map<String, dynamic> data =
        //             snapshot.data!.data() as Map<String, dynamic>;
        //         return Text(data['name']);
        //       }
        //       return Loading();
        //     })
      ),
    );
  }
}
