import 'dart:convert';
import 'dart:math';

import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Worker/Track_accept.dart';
import 'package:coffre_app/pages/home/worker/worker_requests_tile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/storage.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/shared/constant.dart';

import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ShowRequest extends StatefulWidget {


  const ShowRequest({Key? key}) : super(key: key);

  @override
  State<ShowRequest> createState() => _ShowRequestState();
}

class _ShowRequestState extends State<ShowRequest>
    with SingleTickerProviderStateMixin {
  String? firebaseURL =
      'https://firebasestorage.googleapis.com/v0/b/coffe-app-a36f3.appspot.com/o/Orders_Images%2F';

  late AnimationController _controller;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool showLocation = false;
  String? price;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Request;
    final user = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: user?.uid);
  
    _markers.add(Marker(
        markerId: MarkerId(args.name),
        position: LatLng(args.latitude, args.longitude),
        infoWindow: InfoWindow(title: args.name)));
    final Storage storage = Storage();
    print(args.imageName);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: MyCustomAppBar(
        name: "${args.name} Request",
        widget: [],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: IntrinsicHeight(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  const SizedBox(height: 15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Owner',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: Constants.appFont,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blacColor,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${args.name}',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: Constants.appFont,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 58, 27, 131),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Description ",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: Constants.appFont,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blacColor,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            args.Description,
                            style: const TextStyle(
                              color: Color.fromARGB(171, 0, 0, 0),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Photo ",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: Constants.appFont,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blacColor,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * .35,
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image(
                                          image: NetworkImage(firebaseURL! +
                                              args.imageName +
                                              '?alt=media&token=')) ??
                                      Loading(),
                                
                                ),
                               
                              ],
                            ),
                          ),
                          Text(
                            "Location ",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: Constants.appFont,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blacColor,
                            ),
                          ),
                          (showLocation)
                              ? Center(
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    child: GoogleMap(
                                      mapType: MapType.normal,
                                      markers: Set<Marker>.of(_markers),
                                      myLocationButtonEnabled: false,
                                      zoomControlsEnabled: false,
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              args.latitude, args.longitude),
                                          zoom: 14),
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.fromHeight(10),
                                    padding: EdgeInsets.all(5),
                                    primary: Color.fromARGB(108, 240, 177, 240),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showLocation = true;
                                    });
                                  },
                                  child: Text('Show location')),
                          const SizedBox(
                            height: 18,
                          ),
                          TextFormField(
                              validator: ((value) {
                                if (value != null && value.isEmpty) {
                                  return "You must enter a number";
                                } else {
                                  return null;
                                }
                              }),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              onChanged: (value) => setState(() {
                                    this.price = value;
                                  }),
                              decoration: InputDecoration(
                                  fillColor: Color.fromARGB(106, 78, 3, 122),
                                  filled: true,
                                  alignLabelWithHint: true,
                                  hintText: 'Name you price here')),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var rng = new Random();
                      var OTP = rng.nextInt(900000) + 100000;
                      if (_formKey.currentState!.validate()) {
                        _db.AcceptRequest(
                            args.name,
                            args.Cust_ID,
                            user?.displayName as String,
                            user?.uid,
                            DateTime.now().millisecondsSinceEpoch,
                            price,
                            0,
                            args.latitude,
                            args.longitude,
                            OTP);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => accept_tracker()));
                  
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      primary: Color.fromARGB(255, 78, 2, 78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Accept Request",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
