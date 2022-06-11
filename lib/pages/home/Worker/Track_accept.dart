import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/pages/home/Worker/miniMap.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/appbar.dart';
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
  final _formKey = GlobalKey<FormState>();
  int? _OTP;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final acceptedrequests = Provider.of<List<AcceptedRequest>?>(context) ?? [];
    final user = Provider.of<User?>(context);
// user if == worker id
// item.status == 2 - means customer accepted your request.
    for (var item in acceptedrequests) {
      // If the worker ID == item.worker_id
      // and the item status == 1 then show waiting or working.
      // after the worker press the button the status will be 2
      // then we will show the secoed page.

      if (item.worker_ID == user?.uid) {
        if (item.Status == 1) {
          return Scaffold(
            appBar: MyCustomAppBar(
              name: 'Customer Accepted - Working',
              widget: [],
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(
                            child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(26.0),
                            child: Card(
                              color: Colors.purple,
                              child: Text(
                                'Now the user  ${item.Cust_name} has accepted your offer, when you finish the work ask for the OTP to confirm that the work is done.',
                                style: GoogleFonts.actor(
                                    textStyle: TextStyle(
                                        color: Color.fromARGB(238, 22, 1, 1),
                                        fontSize: 20,
                                        letterSpacing: .5,
                                        fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ),
                        )),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  decoration: InputDecoration(
                                      fillColor:
                                          Color.fromARGB(255, 255, 255, 255),
                                      filled: true,
                                      alignLabelWithHint: true,
                                      hintText: 'Provide the OTP')),
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      shadowColor:
                                          Color.fromARGB(255, 241, 241, 241),
                                      elevation: 10,
                                      padding: const EdgeInsets.all(16.0),
                                      primary:
                                          Color.fromARGB(255, 255, 255, 255),
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      backgroundColor:
                                          Color.fromARGB(255, 113, 5, 146)),
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
                          'Here is the location of the Customer',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.location_on),
                          iconSize: 50,
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.pushNamed(context, '/mini_Map',
                                arguments: item);
                          },
                        ),
                        Text(
                          'Here is the Phone number of the Customer',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        StreamBuilder<UserData>(
                            //Fetching data from the documentId specified of the student
                            stream:
                                DatabaseService(uid: item.Cust_ID).userData3,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Loading();
                              }
                              double avregeRating = 0;
                              double Rating = 0;
                              UserData? userDataVar = snapshot.data;
                              if (userDataVar != null && snapshot.hasData) {
                                return Text(
                                  userDataVar.phoneNumber!,
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.normal,
                                      color:
                                          Color.fromARGB(255, 231, 224, 230)),
                                );
                              }
                              return Loading();
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'To be able to see directions please do the following steps:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          '1. Click on the icon above to open the map',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        Text(
                          '2. Click on the red marker',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        Text(
                          '3. Click on the arrow icon at the bottom to start tracking',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
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
            appBar: MyCustomAppBar(
              name: 'Waiting for Customer Acceptance',
              widget: [],
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
                                    color: Color.fromARGB(193, 255, 255, 255),
                                    fontSize: 20,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ),
                      )),
                      Loading(),
                      //BUTTON FOR CANCELING THE REQUEST
                      ElevatedButton(
                        style: TextButton.styleFrom(
                            shadowColor: Color.fromARGB(255, 241, 241, 241),
                            elevation: 10,
                            padding: const EdgeInsets.all(16.0),
                            primary: Color.fromARGB(255, 255, 255, 255),
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            backgroundColor: Color.fromARGB(255, 113, 5, 146)),
                        onPressed: () {
                          //CALLING DELETE FIREBASE DELETE FUNCTION
                          DatabaseService()
                              .AcceptenceCollection
                              .doc(item.worker_ID)
                              .delete()
                              .catchError(
                                  (error) => print('Delete failed: $error'));
                        }
                        // Child TEXT widget
                        ,
                        child: const Text('Press this to cancel the request'),
                      )
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
