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

class OrdersMap extends StatefulWidget {
  const OrdersMap({Key? key}) : super(key: key);

  @override
  State<OrdersMap> createState() => _OrdersMapState();
}

class _OrdersMapState extends State<OrdersMap> {
  late Stream<UserData> userDATA;

  Location location = new Location();

  PermissionStatus _permissionGranted = PermissionStatus.denied;
  bool? _isServiceEnabled;
  final user = FirebaseAuth.instance.currentUser!.uid;

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
    double _radius = 30000.0;
    final requests = Provider.of<List<Request>?>(context) ?? [];
    final _acceptedRequest = Provider.of<List<AcceptedRequest>?>(context) ?? [];
    final user = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: user?.uid);

    bool noRequests = true;
    return StreamBuilder<UserData>(
        stream: userDATA,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Loading();
            case ConnectionState.done:
            default:
              if (snapshot.hasError) {
                return Scaffold(
                    appBar: MyCustomAppBar(
                      name: 'Orders Map',
                      widget: [],
                    ),
                    body: Text('An error'));
              } else if (snapshot.hasData) {
                bool hasAccepted = false;
                UserData? userData = snapshot.data;
                List<AcceptedRequest> b = _acceptedRequest;

                List<Request> a = requests;
                List<AcceptedRequest> AcceptedRequests = [];
                for (AcceptedRequest item in b) {
                  if (item.worker_ID == user!.uid) {
                    hasAccepted = true;
                  }
                }
                if (!hasAccepted)
                  for (Request item in a) {
                    if (userData!.profession == item.profession &&
                        distance(userData.latitude, item.latitude,
                                userData.longitude, item.longitude) <
                            30) {
                      _markers.add(Marker(
                        markerId: MarkerId('${item.name}'),
                        position: LatLng(item.latitude, item.longitude),
                        infoWindow: InfoWindow(title: item.Description),
                        onTap: () {
                          Navigator.pushNamed(context, '/Show_Request',
                              arguments: item);
                        },
                      ));
                    }
                  }
                _markers.add(Marker(
                    markerId: MarkerId(userData?.name as String),
                    position: LatLng(userData?.latitude as double,
                        userData?.longitude as double),
                    icon: BitmapDescriptor.defaultMarkerWithHue(180)));

                return Scaffold(
                  appBar: AppBar(title: Text("Nearby Customers")),
                  body: Scaffold(
                    body: GoogleMap(
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(_markers),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer())),
                      initialCameraPosition: CameraPosition(
                          target: LatLng(userData?.latitude as double,
                              userData?.longitude as double),
                          zoom: 11),
                      minMaxZoomPreference: MinMaxZoomPreference(10, 18),
                      circles: {
                        Circle(
                            circleId: CircleId(userData!.name as String),
                            center: LatLng(userData.latitude as double,
                                userData.longitude as double),
                            radius: _radius,
                            strokeWidth: 2,
                            strokeColor: Colors.red)
                      },
                    ),
                  ),
                );
              }
          }

          return Loading();
        }));
  }
}
