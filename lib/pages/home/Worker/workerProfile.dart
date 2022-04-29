import 'package:coffre_app/modules/rating.dart';
import 'package:coffre_app/modules/requests.dart';
import 'package:coffre_app/pages/home/Worker/worker_home.dart';
import 'package:coffre_app/pages/home/Worker/worker_requests.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    worker_home(),
    Profile(),
    worker_requests()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usera = Provider.of<User?>(context);
    // final _myrates = Provider.of<List<Rate>?>(context) ?? [];

    // List<Rate> Rates = _myrates;

    // for (Rate item in Rates) {
    //   // Rates.add(item);
    // }
    // for (var item in Rates) {
    //   //   {
    //   //     a
    //   //   }
    //   //   ;
    // }
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<Rate>>(
          stream: DatabaseService(uid: usera?.uid).ratee,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              double avregeRating = 0;
              List<Rate>? userRate = snapshot.data;
              if (userRate != null) {
                for (var item in userRate) {
                  avregeRating += item.rate;
                }
              }
              return Text('${avregeRating / userRate!.length}');
            } else {
              return Loading();
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
