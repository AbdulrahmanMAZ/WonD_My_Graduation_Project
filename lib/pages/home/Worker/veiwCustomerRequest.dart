import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:flutter/material.dart';

class veiwCustomerRequest extends StatefulWidget {
  const veiwCustomerRequest({Key? key}) : super(key: key);

  @override
  _veiwCustomerRequestState createState() => _veiwCustomerRequestState();
}

class _veiwCustomerRequestState extends State<veiwCustomerRequest> {
  Map request = {};

  @override
  Widget build(BuildContext context) {
    request = ModalRoute.of(context)!.settings.arguments as Map;
    //print(request['Cust_ID']);
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('coffes')
          .doc(request['Cust_ID'].toString())
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return SafeArea(
            child: Scaffold(
              appBar: MyCustomAppBar(name: data['name'], widget: []),
              backgroundColor: Colors.blueGrey[100],
              body: Center(child: Text('my name is ${data['name']}')),
            ),
          );
        }

        return Loading();
      },
    );
  }
}
