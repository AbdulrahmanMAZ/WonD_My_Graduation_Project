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
  const SettingsForm({Key? key, latitude, longitude, required this.profession})
      : super(key: key);
  final String profession;

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // final List<String> professions = [
  //   'Hairdresser',
  //   'Mechanic',
  //   'Electrician',
  //   'plumber'
  // ];

  String? _currentName;
  String? _currentProfession;
  bool? _isWorker;
  String? dropdownValue = '0';
  String? Description;
  bool imageuploaded = false;
  var Path;
  var FileName;

  @override
  Widget build(BuildContext context) {
    var t;
    final Storage storage = Storage();
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Form(
                key: _formKey,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Text('Request a Service',
                          style: GoogleFonts.nothingYouCouldDo(
                              textStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 20,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w900))),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Welcome ${userData!.name} to the requesting page",
                          style: GoogleFonts.actor(
                              textStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 20,
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w900))),
                      SizedBox(
                        height: 20,
                      ),

                      //Drop Down.
                      Text(
                        "You are Requesting: ${widget.profession}",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // TextField(
                      //   enabled: false,
                      //   style: TextStyle(fontSize: 12),
                      //   decoration: InputDecoration(
                      //       filled: true,
                      //       fillColor: Colors.white,
                      //       border: InputBorder.none,
                      //       labelText: 'Your image name',
                      //       hintText: ''),
                      //   onChanged: (val) => setState(() {
                      //     Description = val;
                      //   }),
                      // ),

                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hoverColor: Colors.blue,
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          labelText: 'Description of the problem',
                          hintText: 'Enter Your problem Description',

                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black26, width: 5)),

                          // Color when not in clicked
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(66, 136, 136, 136),
                                width: 5.0),
                          ),
                        ),
                        onChanged: (val) => setState(() {
                          Description = val;
                        }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Upload an Image for the problem"),
                      IconButton(
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
                          setState(() {
                            Path = result.files.single.path!;
                            FileName = result.files.single.name;
                            setState(() {
                              this.imageuploaded = true;
                            });
                          });
                          print(Path + ' -- ' + FileName);
                          ;
                        },
                        icon: Icon(Icons.upload_file),
                      ),
                      Visibility(
                          visible: imageuploaded,
                          child: Text(
                            "Photo is uploaded",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 20),
                          )),
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
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.black87),
                        onPressed: () async {
                          final UUID = Uuid().v1();
                          Navigator.pop(context);
                          if (_formKey.currentState!.validate()) {
                            await DatabaseService().RaiseRequest(
                                user.displayName.toString(),
                                user.uid,
                                DateTime.now().millisecondsSinceEpoch,
                                widget.profession,
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
                  ),
                ));
          } else {
            return Loading();
          }
        });
  }
}
