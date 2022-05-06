import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/services/auth.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/methods.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class miniMap extends StatefulWidget {
  const miniMap({Key? key}) : super(key: key);

  @override
  State<miniMap> createState() => _miniMapState();
}

class _miniMapState extends State<miniMap> {
  late Stream<UserData> userDATA;

  Location location = new Location();

  PermissionStatus _permissionGranted = PermissionStatus.denied;
  bool? _isServiceEnabled;
  final user = FirebaseAuth.instance.currentUser!.uid;
  //  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final AuthSrrvice _auth = AuthSrrvice();
  List<Marker> _markers = [];
  @override
  void initState() {
    super.initState();
    final DatabaseService _db = DatabaseService(uid: user);
    final _userData = DatabaseService(uid: user).userData;
    this.userDATA = _userData;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AcceptedRequest;
    double _radius = 30000.0;

    final _acceptedRequest = Provider.of<List<AcceptedRequest>?>(context) ?? [];
    final user = Provider.of<User?>(context);

    return StreamBuilder<UserData>(
        stream: userDATA,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Loading();
            case ConnectionState.done:
            default:
              if (snapshot.hasError) {
                return Text('An error');
              } else if (snapshot.hasData) {
                bool hasAccepted = false;
                UserData? userData = snapshot.data;
                List<AcceptedRequest> b = _acceptedRequest;
                _markers.add(Marker(
                    markerId: MarkerId(args.Cust_name),
                    position: LatLng(args.latitude, args.longitude),
                    infoWindow: InfoWindow(title: args.Cust_name)));

                return Scaffold(
                  appBar: AppBar(title: Text("Nearby Customers")),
                  body: Scaffold(
                    body: GoogleMap(
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(_markers),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(args.latitude, args.longitude),
                          zoom: 14),
                    ),
                  ),
                );
              }
          }

          return Loading();
        }));
  }
}
