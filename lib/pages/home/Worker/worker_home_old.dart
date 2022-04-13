// import 'package:coffre_app/modules/requests.dart';
// import 'package:coffre_app/modules/users.dart';
// import 'package:coffre_app/modules/users.dart';
// import 'package:coffre_app/pages/home/Worker/requests_list.dart';
// import 'package:coffre_app/pages/home/Worker/worker_drawer.dart';
// import 'package:coffre_app/pages/home/Worker/worker_settings.dart';

// import 'package:coffre_app/services/auth.dart';
// import 'package:coffre_app/services/database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:coffre_app/shared/appbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';

// class worker_home extends StatelessWidget {
//   final AuthSrrvice _auth = AuthSrrvice();

//   // DocumentSnapshot doc =  DocRef.get();

//   List<Marker> _markers = [];
//   @override
//   Widget build(BuildContext context) {
//     void _showAppSettings() {
//       showModalBottomSheet(
//           context: context,
//           builder: (context) {
//             return Container(
//               child: WorkerSettingsForm(),
//             );
//           });
//     }

//     // final CollectionReference requests =
//     //     FirebaseFirestore.instance.collection('requests');
//     final usera = Provider.of<User?>(context);
//     final DatabaseService _db = DatabaseService(uid: usera?.uid);
//     // final DocumentReference workers =
//     //     FirebaseFirestore.instance.collection('coffes').doc(user?.uid);
//     final requests = Provider.of<List<Request>?>(context) ?? [];

//     // final _userdata = _db.userDataFromSnapshot(workers.);
//     // print(a[0]);
//     // print(usera?.uid);
//     return StreamProvider<UserData?>.value(
//       value: DatabaseService().userData,
//       initialData: null,
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.brown[50],
//         drawer: worker_drawer(
//           username: usera?.displayName,
//           logout: TextButton.icon(
//             icon: Icon(Icons.person),
//             label: Text('logout'),
//             onPressed: () async {
//               await _auth.SignOut();
//             },
//           ),
//         ),
//         appBar: MyCustomAppBar(
//           name: 'Nearby Customers',
//           widget: [],
//         ),

//         body: Center(
//           child: Container(
//             child: GoogleMap(
//               mapType: MapType.normal,
//               markers: Set<Marker>.of(_markers),
//               myLocationButtonEnabled: false,
//               zoomControlsEnabled: false,
//               initialCameraPosition: CameraPosition(
//                   target: LatLng(user, 42.573073170794395),
//                   zoom: 14),
//             ),
//           ),
//         ),

//         // TextButton.icon(
//         // onPressed: () async {
//         // DatabaseService()
//         //     .RaiseRequest(user.displayName.toString(), user.uid);
//         // },
//         // icon: Icon(Icons.front_hand),
//         // label: Text('Rquest Service'))

//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.settings),
//           onPressed: () {
//             _showAppSettings();
//           },
//         ),
//       ),
//     );
//   }
// }
