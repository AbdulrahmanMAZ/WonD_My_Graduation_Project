// import 'package:coffre_app/modules/user.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:coffre_app/modules/users.dart';

class WorkerSettingsForm extends StatefulWidget {
  const WorkerSettingsForm({Key? key}) : super(key: key);

  @override
  _WorkerSettingsFormState createState() => _WorkerSettingsFormState();
}

class _WorkerSettingsFormState extends State<WorkerSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> professions = [
    'Hairdresser',
    'Mechanic',
    'Electrician',
    'plumber'
  ];

  String? _currentName;
  String? _currentProfession;
  bool? _isWorker;
  String? dropdownValue = '0';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text('${userData!.name} settings',
                        style: GoogleFonts.nothingYouCouldDo(
                            textStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 20,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w900))),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue: userData.name,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Your Name'),
                      validator: (val) =>
                          val!.isEmpty ? 'Please Enter a name' : null,
                      onChanged: (val) => setState(() {
                        _currentName = val;
                      }),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    //Drop Down.
                    DropdownButtonFormField(
                      // value: _currentProfession ?? userData.profession,
                      //  icon: Icon(Icons.arrow_downward),
                      items: professions.map((String e) {
                        return DropdownMenuItem(value: e, child: Text('$e'));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentProfession = newValue;
                        });
                      },
                    ),
                    //Slider
                    // Slider(
                    //     min: 100,
                    //     max: 900,
                    //     divisions: 8,
                    //     value:
                    //         (_currentStrength ?? userData.strngth)!.toDouble(),
                    //     activeColor: Colors
                    //         .brown[_currentStrength ?? userData.strngth as int],
                    //     inactiveColor: Colors
                    //         .brown[_currentStrength ?? userData.strngth as int],
                    //     onChanged: (e) {
                    //       setState(() {
                    //         _currentStrength = e.round();
                    //       });
                    //     }),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black87),
                      onPressed: () async {
                        Navigator.pop(context);
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService().UpdateWorker(
                              user.displayName.toString(),
                              user.uid,
                              _currentProfession);
                          print(user.uid);
                          // Navigator.pop(context);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ));
          } else {
            return Loading();
          }
        });
  }
}
