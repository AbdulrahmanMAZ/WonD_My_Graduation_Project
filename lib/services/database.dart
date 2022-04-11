import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:coffre_app/modules/User.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/modules/requests.dart';
//import 'package:coffre_app/modules/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference workersCollection =
      FirebaseFirestore.instance.collection('coffes');

  final CollectionReference RequestsCollection =
      FirebaseFirestore.instance.collection('requests');
  final CollectionReference AcceptenceCollection =
      FirebaseFirestore.instance.collection('Accepted_requests');

  // final CollectionReference WorkersCollection =
  //     FirebaseFirestore.instance.collection('Collection of workers');

  Future<void> updateUserData(
      String name, bool isWorker, String profession) async {
    return await workersCollection
        .doc(uid)
        .set({'name': name, 'isWorker': isWorker, 'profession': profession});
  }

  Future<void> updateUserLocation(lat, long) async {
    return await workersCollection
        .doc(uid)
        .update({'latitude': lat, 'longitude': long});
  }

  // Future<String?> getProfession(String uid) async {
  //   var collection = FirebaseFirestore.instance.collection('coffes');
  //   var docSnapshot = await collection.doc(uid).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic> data = docSnapshot.data()!;

  //     // You can then retrieve the value from the Map like this:
  //     var name = await data['name'];
  //     return name.toString();
  //   }
  // }
  // getProfession(String userID) async {
  //   DocumentReference documentReference = workersCollection.doc(userID);
  //   DocumentSnapshot documentSnapshot = documentReference.snapshots();
  //   String? specie;
  //   await documentReference.get().then((snapshot) async {
  //     specie = await snapshot.get('profession');
  //   });
  //   return specie;
  // }

// getSpecie(String petId) async{
//     Future<DocumentSnapshot> snapshot = await workersCollection.doc(petId).get();
//     return snapshot.then((value) => Pet.fromSnapshot(value).specie);
//   }

  Future<void> RaiseRequest(String name, String Cust_ID, int t, profession,
      imageName, Description, lat, long) async {
    return await RequestsCollection.doc(Cust_ID).set({
      'Cust_ID': Cust_ID,
      'name': name,
      'time': t,
      'profession': profession,
      'problemimage': imageName,
      'probleDescription ': Description,
      'latitude': lat,
      'longitude': long
    });
  }

  Future<void> AcceptRequest(String Cust_name, String Worker_Name,
      String Cust_ID, int t, Worker_ID, Price) async {
    return await AcceptenceCollection.doc(Worker_ID).set({
      'Cust_ID': Cust_ID,
      'Worker_ID': Cust_ID,
      'Cust_name': Cust_name,
      'time': t,
      'Worker_Name': Worker_Name,
      'Price': Price
    });
  }

  Future<void> UpdateWorker(String name, String Cust_ID, profession) async {
    return await workersCollection
        .doc(Cust_ID)
        .set({'name': name, 'profession': profession, 'isWorker': true});
  }

  List<Request> _requestsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Request(
          name: doc.get('name'),
          Cust_ID: doc.get('Cust_ID'),
          t: doc.get('time'),
          profession: doc.get('profession'),
          imageName: doc.get('problemimage'),
          Description: doc.get('probleDescription '),
          latitude: doc.get('latitude'),
          longitude: doc.get('longitude'));
    }).toList();
  }

  // Request _requestSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     //print(doc.data);
  //     return Request(
  //         name: doc.get('name'),
  //         Cust_ID: doc.get('Cust_ID'),
  //         t: doc.get('time'),
  //         profession: doc.get('profession'));
  //   }).toList();
  // }

  List<Request> _userRequestsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Request(
          name: doc.get('name'),
          Cust_ID: doc.get('Cust_ID'),
          t: doc.get('time'),
          profession: doc.get('profession'),
          imageName: doc.get('problemimage'),
          Description: doc.get('probleDescription '),
          latitude: doc.get('latitude'),
          longitude: doc.get('longitude'));
    }).toList();
  }

  // brew list from snapshot
  List<user> _workersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return user(
          name: doc.get('name') ?? '', isWorker: doc.get('isWorker') ?? false);
    }).toList();
  }

  //UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        isWorker: snapshot.get('isWorker'),
        profession: snapshot.get('profession'),
        latitude: snapshot.get('latitude'),
        longitude: snapshot.get('longitude'));
  }

  UserData _userDataFromSnapshot2(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.get('name'),
      isWorker: snapshot.get('isWorker'),
      profession: snapshot.get('profession'),
    );
  }

  //get users stream
  Stream<List<user>> get users {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return workersCollection.snapshots().map(_workersListFromSnapshot);
  }

  Stream<List<Request>> get requets {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return RequestsCollection.snapshots().map(_requestsListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return workersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<UserData> get userData2 {
    return workersCollection.doc(uid).snapshots().map(_userDataFromSnapshot2);
  }

  // Stream<UserData> get userData {
  //   return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  // }
}
