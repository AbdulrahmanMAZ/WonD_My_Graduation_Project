import 'dart:convert';

import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/worker/worker_requests_tile.dart';
import 'package:coffre_app/services/storage.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Request;
    _markers.add(Marker(
        markerId: MarkerId('SomeId'),
        position: LatLng(args.latitude, args.longitude),
        infoWindow: InfoWindow(title: args.name)));
    final Storage storage = Storage();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
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
                const SizedBox(height: 18),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description of ${args.name}'s problem'",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    args.Description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(height: 1.5),
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
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
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
    );
  }
}
