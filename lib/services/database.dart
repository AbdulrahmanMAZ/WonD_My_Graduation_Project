import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
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

  final CollectionReference WorkignOnCollection =
      FirebaseFirestore.instance.collection('Working_on_Service');

  // final CollectionReference WorkersCollection =
  //     FirebaseFirestore.instance.collection('Collection of workers');
  // DocumentReference DocRef = workersCollection.doc(uid);
  // DocumentSnapshot doc = await DocRef.get();

  Future<void> updateUserData(
      String name, bool isWorker, String profession) async {
    return await workersCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'isWorker': isWorker,
      'profession': profession,
      'latitude': 0.1,
      'longitude': 0.1
    });
  }

  Future<void> updateUserLocation(lat, long) async {
    try {
      var a = await workersCollection
          .doc(uid)
          .update({'latitude': lat, 'longitude': long});

      return a;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateRequestStatus(Status) async {
    return await AcceptenceCollection.doc(uid).update({'Status': Status});
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

  Future<void> AcceptRequest(String Cust_name, String Cust_ID,
      String Worker_Name, Worker_ID, int t, Price, Status) async {
    return await AcceptenceCollection.doc(Worker_ID).set({
      'Cust_ID': Cust_ID,
      'Cust_name': Cust_name,
      'Worker_ID': Worker_ID,
      'Worker_Name': Worker_Name,
      'time': t,
      'Price': Price,
      'Status': Status
    });
  }

  Future<void> WorkingOnIt(String Cust_name, String Cust_ID, String Worker_Name,
      Worker_ID, int t, Price, status) async {
    return await WorkignOnCollection.doc(Worker_ID).set({
      'Cust_ID': Cust_ID,
      'Cust_name': Cust_name,
      'Worker_ID': Worker_ID,
      'Worker_Name': Worker_Name,
      'time': t,
      'Price': Price,
      'Status': status
    });
  }

  Future<void> Ratethis(double Rate, String whorated) async {
    return await workersCollection
        .doc(uid)
        .collection("Ratings")
        .doc(whorated)
        .set({'Rating': Rate});
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

  List<AcceptedRequest> _AcceptedrequestsListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return AcceptedRequest(
          Cust_ID: doc.get('Cust_ID'),
          Cust_name: doc.get('Cust_name'),
          worker_ID: doc.get('Worker_ID'),
          worker_name: doc.get('Worker_Name'),
          t: doc.get('time'),
          price: doc.get('Price'),
          Status: doc.get('Status'));
    }).toList();
  }

  List<WorkingOnit> _WorkingOnitListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return WorkingOnit(
          Cust_ID: doc.get('Cust_ID'),
          Cust_name: doc.get('Cust_name'),
          worker_ID: doc.get('Worker_ID'),
          worker_name: doc.get('Worker_Name'),
          t: doc.get('time'),
          price: doc.get('Price'),
          status: doc.get('Status'));
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

  List<Rate> _RatingListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Rate(
        rate: doc.get('Rating'),
      );
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

  List<UserData>? _usersListDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
          uid: doc.get('uid'),
          name: doc.get('name'),
          isWorker: doc.get('isWorker'),
          profession: doc.get('profession'),
          latitude: doc.get('latitude'),
          longitude: doc.get('longitude'));
    }).toList();
  }

  UserData _userDataFromSnapshot2(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.get('name'),
      isWorker: snapshot.get('isWorker'),
      profession: snapshot.get('profession'),
    );
  }

  UserData _userDataFromSnapshot3(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        isWorker: snapshot.get('isWorker'),
        profession: snapshot.get('profession'),
        latitude: snapshot.get('latitude'),
        longitude: snapshot.get('longitude'));
  }

  //get users stream
  Stream<List<user>> get users {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return workersCollection.snapshots().map(_workersListFromSnapshot);
  }

  Stream<List<UserData>?> get users2 {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return workersCollection.snapshots().map(_usersListDataFromSnapshot);
  }

  Stream<List<Request>> get requets {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return RequestsCollection.snapshots().map(_requestsListFromSnapshot);
  }

  Stream<List<AcceptedRequest>> get Acceptedrequets {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return AcceptenceCollection.snapshots()
        .map(_AcceptedrequestsListFromSnapshot);
  }

  Stream<List<WorkingOnit>> get WorkingOnitStream {
    //Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
    return WorkignOnCollection.snapshots().map(_WorkingOnitListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return workersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<List<Rate>> get ratee {
    return workersCollection
        .doc(uid)
        .collection('Ratings')
        .snapshots()
        .map(_RatingListFromSnapshot);
  }

  Stream<UserData> get userData2 {
    return workersCollection.doc(uid).snapshots().map(_userDataFromSnapshot2);
  }

  Stream<UserData> get userData3 {
    return workersCollection.doc(uid).snapshots().map(_userDataFromSnapshot3);
  }

  // Stream<UserData> get userData {
  //   return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  // }
}
