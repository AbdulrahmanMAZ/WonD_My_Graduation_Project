import 'dart:convert';

import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Worker/Track_accept.dart';
import 'package:coffre_app/pages/home/worker/worker_requests_tile.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/storage.dart';
import 'package:coffre_app/shared/constant.dart';

import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ShowRequest extends StatefulWidget {
  // static const _initialCameraPosition =
  //     CameraPosition(target: LatLng(40, -120), zoom: 12);

  const ShowRequest({Key? key}) : super(key: key);

  @override
  State<ShowRequest> createState() => _ShowRequestState();
}

class _ShowRequestState extends State<ShowRequest>
    with SingleTickerProviderStateMixin {
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

  String? price;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Request;
    final user = Provider.of<User?>(context);
    final DatabaseService _db = DatabaseService(uid: user?.uid);
    //Double later
    _markers.add(Marker(
        markerId: MarkerId('SomeId'),
        position: LatLng(args.latitude, args.longitude),
        infoWindow: InfoWindow(title: args.name)));
    final Storage storage = Storage();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //DetailHeader(title: args.name),
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
                                child: FutureBuilder(
                                  future: storage.downloadURL(args.imageName),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      return Container(
                                        child: Image.network(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                          color: Colors.grey,
                                          colorBlendMode: BlendMode.multiply,
                                        ),
                                      );
                                    }
                                    return Loading();
                                  },
                                ),

                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: imagePreviews,
                                // ),
                              ),
                              // const SizedBox(height: 18),
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
                        Center(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              markers: Set<Marker>.of(_markers),
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(args.latitude, args.longitude),
                                  zoom: 14),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Spacer(),
                        TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            onChanged: (value) => setState(() {
                                  this.price = value;
                                }),
                            decoration: InputDecoration(
                                fillColor: Colors.amber,
                                filled: true,
                                alignLabelWithHint: true,
                                hintText: 'Name you price here')),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _db.AcceptRequest(
                        args.name,
                        args.Cust_ID,
                        user?.displayName as String,
                        user?.uid,
                        DateTime.now().millisecondsSinceEpoch,
                        price,
                        0);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => accept_tracker()));
                  },
                  style: ElevatedButton.styleFrom(
                    // minimumSize: Size(200, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
    );
  }
}
