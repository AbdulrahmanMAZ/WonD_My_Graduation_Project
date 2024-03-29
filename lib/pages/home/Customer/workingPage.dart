import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Customer/cust_home.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/appbar.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class workingpage extends StatefulWidget {
  final AcceptedRequest item;
  const workingpage(AcceptedRequest this.item, {Key? key}) : super(key: key);

  @override
  State<workingpage> createState() => _workingpageState();
}

class _workingpageState extends State<workingpage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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

  String? userFeedback;
  double Rating = 0;

  @override
  Widget build(BuildContext context) {
    //  final requests = Provider.of<List<WorkingOnit>?>(context) ?? [];
    //final workinOnItrequests = Provider.of<List<WorkingOnit>?>(context) ?? [];
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

      if (item.Cust_ID == user?.uid) {
        if (item.Status == 2) {
          return Scaffold(
            appBar: MyCustomAppBar(
              name: "Rating",
              widget: [],
            ),
            backgroundColor: AppColors.Allbackgroundcolor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'How was the service of the worker',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: RatingBar.builder(
                      initialRating: 3,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: Colors.red,
                            );
                          case 1:
                            return Icon(
                              Icons.sentiment_dissatisfied,
                              color: Colors.redAccent,
                            );
                          case 2:
                            return Icon(
                              Icons.sentiment_neutral,
                              color: Colors.amber,
                            );
                          case 3:
                            return Icon(
                              Icons.sentiment_satisfied,
                              color: Colors.lightGreen,
                            );
                          case 4:
                            return Icon(
                              Icons.sentiment_very_satisfied,
                              color: Colors.green,
                            );
                        }
                        return Text('gg');
                      },
                      onRatingUpdate: (rating) {
                        Rating = rating;
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 5,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 10.0),
                    hoverColor: Colors.blue,
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    labelText: 'ُEnter Your Feedback',
                    hintText: 'Enter Your Feedback',

                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 5)),

                    // Color when not in clicked
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(66, 136, 136, 136), width: 5.0),
                    ),
                  ),
                  onChanged: (val) => setState(() {
                    userFeedback = val;
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      DatabaseService(uid: item.worker_ID).Ratethis(
                          Rating, item.Cust_ID, userFeedback, item.Cust_name);
                      DatabaseService()
                          .AcceptenceCollection
                          .doc(item.worker_ID)
                          .delete() // <-- Delete
                          .then((_) => print('Deleted'))
                          .catchError(
                              (error) => print('Delete failed: $error'));
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Cust_Home()));
                    },
                    child: Text('Submit Rating and feedback'))
                // TextButton(onPressed: (){, child: child)
              ],
            ),
          );
        }
        if (item.Status == 1) {
          return Scaffold(
            appBar: MyCustomAppBar(name: "Working on It", widget: []),
            backgroundColor: AppColors.Allbackgroundcolor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                    child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: Text(
                      'Waiting for  ${item.worker_name} To finsh the job',
                      style: GoogleFonts.actor(
                          textStyle: TextStyle(
                              color: Color.fromARGB(209, 255, 255, 255),
                              fontSize: 20,
                              letterSpacing: .5,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                )),
                Loading(),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Provide the worker with this code when he finsh the work',
                  style: GoogleFonts.actor(
                      textStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w900)),
                ),
                Card(
                  child: Text(
                    '${item.OTP}',
                    style: GoogleFonts.abel(
                        textStyle: TextStyle(
                            color: Color.fromARGB(255, 194, 31, 186),
                            fontSize: 40,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          );
        }
      }
    }
    return Scaffold(
      appBar: MyCustomAppBar(name: 'No Oeders', widget: []),
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
