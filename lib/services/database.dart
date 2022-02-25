import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:coffre_app/modules/User.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/modules/requests.dart';
//import 'package:coffre_app/modules/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('coffes');

  final CollectionReference RequestsCollection =
      FirebaseFirestore.instance.collection('requests');

  final CollectionReference WorkersCollection =
      FirebaseFirestore.instance.collection('Collection of workers');

  Future<void> updateUserData(String name, bool isWorker) async {
    return await brewCollection.doc(uid).set({
      'name': name,
      'isWorker': isWorker,
    });
  }

  Future<void> RaiseRequest(String name, String Cust_ID) async {
    return await RequestsCollection.doc().set({
      'Cust_ID': Cust_ID,
      'name': name,
    });
  }

  List<Request> _requestsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Request(name: doc.get('name'), Cust_ID: doc.get('Cust_ID'));
    }).toList();
  }

  // brew list from snapshot
  List<user> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return user(
          name: doc.get('name') ?? '', isWorker: doc.get('isWorker') ?? false);
    }).toList();
  }

  //UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        isWorker: snapshot.get('isWorker'));
  }

  //get brews stream
  Stream<List<user>?> get users {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  Stream<List<Request>> get requets {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return RequestsCollection.snapshots().map(_requestsListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // Stream<UserData> get userData {
  //   return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  // }
}
