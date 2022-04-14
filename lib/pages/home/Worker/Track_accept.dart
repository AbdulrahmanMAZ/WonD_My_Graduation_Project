import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class accept_tracker extends StatefulWidget {
  const accept_tracker({Key? key}) : super(key: key);

  @override
  State<accept_tracker> createState() => _accept_trackerState();
}

class _accept_trackerState extends State<accept_tracker> {
  @override
  Widget build(BuildContext context) {
    //  final requests = Provider.of<List<Request>?>(context) ?? [];
    final workinOnItrequests = Provider.of<List<WorkingOnit>?>(context) ?? [];
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
        if (item.Status == 1) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Hello'),
            ),
            backgroundColor: Colors.grey,
            body: Column(
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
                SafeArea(
                    child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        shadowColor: Colors.red,
                        elevation: 10,
                        padding: const EdgeInsets.all(16.0),
                        primary: Color.fromARGB(255, 155, 34, 34),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        backgroundColor: Colors.amber[200]),
                    onPressed: () {
                      for (var item in workinOnItrequests) {
                        if (item.worker_ID == user?.uid) {}
                        DatabaseService()
                            .AcceptenceCollection
                            .doc(item.worker_ID)
                            .update({"Status": 2});
                      }
                    },
                    child: const Text('Press this when the job is done'),
                  ),
                )),
              ],
            ),
          );
        }
        if (item.Status == 0) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Hello'),
            ),
            backgroundColor: Colors.grey,
            body: Column(
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
