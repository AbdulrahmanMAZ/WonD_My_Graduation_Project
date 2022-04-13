import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String name;
  final String Cust_ID;
  final int t;
  final String profession;
  final String imageName;
  final String Description;
  final double latitude;
  final double longitude;

  Request(
      {required this.name,
      required this.Cust_ID,
      required this.t,
      required this.profession,
      required this.imageName,
      required this.Description,
      required this.latitude,
      required this.longitude});
}

class AcceptedRequest {
  final String Cust_name;
  final String Cust_ID;
  final String worker_name;
  final String worker_ID;
  final int t;
  final String price;

  AcceptedRequest({
    required this.Cust_ID,
    required this.Cust_name,
    required this.worker_ID,
    required this.worker_name,
    required this.t,
    required this.price,
  });
}
