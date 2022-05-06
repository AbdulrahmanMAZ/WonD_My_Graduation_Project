import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class accept_tracker extends StatefulWidget {
  const accept_tracker({Key? key}) : super(key: key);

  @override
  State<accept_tracker> createState() => _accept_trackerState();
}

class _accept_trackerState extends State<accept_tracker> {
  List<Marker> _markers = [];
  final _formKey = GlobalKey<FormState>();
  int? _OTP;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //final args = ModalRoute.of(context)!.settings.arguments as Request;
    //  final requests = Provider.of<List<Request>?>(context) ?? [];
    // final workinOnItrequests = Provider.of<List<WorkingOnit>?>(context) ?? [];
    final acceptedrequests = Provider.of<List<AcceptedRequest>?>(context) ?? [];
    final user = Provider.of<User?>(context);
// user if == worker id
// item.status == 2 - means customer accepted your request.
//

    for (var item in acceptedrequests) {
      // If the worker ID == item.worker_id
      // and the item status == 1 then show waiting or working.
      // after the worker press the button the status will be 2
      // then we will show the secoed page.

      if (item.worker_ID == user?.uid) {
        _markers.add(Marker(
            markerId: MarkerId(item.Cust_name),
            position: LatLng(item.latitude, item.longitude),
            infoWindow: InfoWindow(title: item.Cust_name)));
        if (item.Status == 1) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Hello'),
            ),
            backgroundColor: Colors.grey,
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
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                reverse: false,
                child: Stack(
                  children: [
                    PositionedBackground(context),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SafeArea(
                            child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Text(
                              'The user  ${item.Cust_name} accepted you offer',
                              style: GoogleFonts.actor(
                                  textStyle: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 20,
                                      letterSpacing: .5,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                        )),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              TextFormField(
                                  validator: ((val) {
                                    if (val != null && val.isEmpty) {
                                      return 'enter a value';
                                    } else if (val != null &&
                                        int.parse(val) != item.OTP) {
                                      return 'Does Not match';
                                    } else {
                                      return null;
                                    }
                                  }),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  // onChanged: (value) => setState(() {
                                  //       this._OTP = int.parse(value);
                                  //     }),
                                  decoration: InputDecoration(
                                      fillColor:
                                          Color.fromARGB(255, 255, 255, 255),
                                      filled: true,
                                      alignLabelWithHint: true,
                                      hintText: 'Provide the OTP')),
                              Center(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      shadowColor: Colors.red,
                                      elevation: 10,
                                      padding: const EdgeInsets.all(16.0),
                                      primary: Color.fromARGB(255, 155, 34, 34),
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      backgroundColor: Colors.amber[200]),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      for (var item in acceptedrequests) {
                                        if (item.worker_ID == user?.uid) {}
                                        DatabaseService()
                                            .AcceptenceCollection
                                            .doc(item.worker_ID)
                                            .update({"Status": 2});
                                      }
                                    }
                                  },
                                  child: const Text(
                                      'Press this when the job is done'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Here is the locatin of the Customer',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            markers: Set<Marker>.of(_markers),
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(item.latitude, item.longitude),
                                zoom: 14),
                          ),
                        ),
                        Text(
                          'Click on the red marker then selecet google maps icon to start tracking',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (item.Status == 0) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Hello'),
            ),
            backgroundColor: Colors.grey,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SafeArea(
                          child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Text(
                            'Waiting for  ${item.Cust_name}To accepts...',
                            style: GoogleFonts.actor(
                                textStyle: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 20,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ),
                      )),
                      Loading()
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      backgroundColor: Colors.grey,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Text(
            'You have no on-going orders',
            style: GoogleFonts.actor(
                textStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 20,
                    letterSpacing: .5,
                    fontWeight: FontWeight.w900)),
          ),
        ),
      )),
    );
  }
}
