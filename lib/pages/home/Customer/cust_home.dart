import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/authenricate/sign_in.dart';
import 'package:coffre_app/pages/home/Customer/settings_forms.dart';
import 'package:coffre_app/pages/home/Worker/Users_List.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/pages/home/Customer/Cust_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Cust_Home extends StatefulWidget {
  @override
  State<Cust_Home> createState() => _Cust_HomeState();
}

class _Cust_HomeState extends State<Cust_Home> {
  Location location = new Location();

  PermissionStatus _permissionGranted = PermissionStatus.denied;

  bool? _isServiceEnabled;
  // PermissionStatus _permissionGranted;
  LocationData? _locationData;
  bool _isListenLocation = false, isGetLocation = false;
  final AuthSrrvice _auth = AuthSrrvice();

  @override
  Widget build(BuildContext context) {
    final CollectionReference aaa =
        FirebaseFirestore.instance.collection('coffes');
    final usera = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: usera?.uid);
    void _showAppSettings() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: SettingsForm(),
            );
          });
    }

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthSrrvice().user,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.brown[50],

        drawer: CustDrawer(
          username: usera?.displayName as String?,
          logout: TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.SignOut();
              Navigator.pushReplacementNamed(context, '/login');

              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => SignIn()));
            },
          ),
        ),
        appBar: MyCustomAppBar(name: 'Your Requests', widget: [
          TextButton.icon(
            onPressed: () async {
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
                return _showAppSettings();
              }
              if (_permissionGranted == PermissionStatus.denied) {
                print(_permissionGranted);
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted == PermissionStatus.granted) {
                  return _showAppSettings();
                }
              }
            },
            icon: Icon(Icons.abc),
            label: Text('Rquest Service'),
          ),
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
          color: Colors.amber,
          child: Center(child: Text('Home Page')),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.settings),
          onPressed: () {},
        )
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

        ,
      ),
    );
  }
}
