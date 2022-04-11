// import 'package:coffre_app/modules/user.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:coffre_app/modules/users.dart';
import 'package:uuid/uuid.dart';

import '../../../services/storage.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key, latitude, longitude}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
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
  String? Description;

  @override
  Widget build(BuildContext context) {
    var t;
    final Storage storage = Storage();
    var Path;
    var FileName;
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
                    Text('Service settings',
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
                      initialValue: userData!.name,
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
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField(
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['png', 'jpg']);
                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No Image is There'),
                            ),
                          );
                          return null;
                        }
                        Path = result.files.single.path!;
                        FileName = result.files.single.name;
                        print(Path + ' -- ' + FileName);
                      },
                      child: Text('pick Image'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Description of the problem',
                          hintText: 'Enter Your problem Description'),
                      onChanged: (val) => setState(() {
                        Description = val;
                      }),
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
                        final UUID = Uuid().v1();
                        Navigator.pop(context);
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService().RaiseRequest(
                              user.displayName.toString(),
                              user.uid,
                              DateTime.now().millisecondsSinceEpoch,
                              _currentProfession,
                              UUID,
                              Description,
                              userData.latitude,
                              userData.longitude);
                          print(Path);
                          storage
                              .uploudFile(Path, UUID)
                              .then((value) => print('Uplouded'));
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
