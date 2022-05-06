import 'package:coffre_app/modules/users.dart';
import 'package:coffre_app/services/database.dart';
import 'package:coffre_app/services/storage.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MakeOrder extends StatefulWidget {
  const MakeOrder({Key? key, latitude, longitude, required this.profession})
      : super(key: key);
  final String profession;
  @override
  State<MakeOrder> createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {
  final _formKey = GlobalKey<FormState>();
  bool hasInternet = false;
  String? _currentName;
  String? _currentProfession;
  bool? _isWorker;
  String? dropdownValue = '0';
  String? Description;
  bool imageuploaded = false;
  var Path;
  var FileName = "no_image_in_firebase.png";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    var t;
    final Storage storage = Storage();
    final user = Provider.of<User>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(),
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
          child: StreamBuilder<UserData>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData? userData = snapshot.data;
                  return SingleChildScrollView(
                      child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: IntrinsicHeight(
                      child: Form(
                          key: _formKey,
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Color.fromARGB(255, 73, 3, 105),
                                  Color.fromARGB(255, 184, 110, 55)
                                ])),
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
                                TextFormField(
                                  maxLines: 5,
                                  initialValue: user.phoneNumber,
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 25.0, horizontal: 10.0),
                                    hoverColor: Colors.blue,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    labelText: 'Description of the problem',
                                    hintText: 'Enter Your problem Description',

                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black26, width: 5)),

                                    // Color when not in clicked
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(66, 136, 136, 136),
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
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(
                                            allowMultiple: false,
                                            type: FileType.custom,
                                            allowedExtensions: ['png', 'jpg']);
                                    if (result == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                  child: Text('Upload an image'),
                                ),
                                Visibility(
                                    visible: imageuploaded,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Image is uploaded succesfully",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 74, 243, 7),
                                              fontSize: 20),
                                        ),

                                        // FutureBuilder(
                                        //   future: storage.downloadURL(FileName),
                                        //   builder: (BuildContext context,
                                        //       AsyncSnapshot<String> snapshot) {
                                        //     if (snapshot.connectionState ==
                                        //             ConnectionState.done &&
                                        //         snapshot.hasData) {
                                        //       return Container(
                                        //         child: Image.network(
                                        //           snapshot.data!,
                                        //           fit: BoxFit.cover,
                                        //           color: Colors.grey,
                                        //           colorBlendMode:
                                        //               BlendMode.multiply,
                                        //         ),
                                        //       );
                                        //     }
                                        //     return Loading();
                                        //   },
                                        // ),

                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.center,
                                        //   children: imagePreviews,
                                        // ),
                                      ],
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
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black87),
                                  onPressed: () async {
                                    hasInternet =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    if (hasInternet) {
                                      final UUID = Uuid().v1();

                                      if (_formKey.currentState!.validate()) {
                                        if (FileName ==
                                            "no_image_in_firebase.png") {
                                          await DatabaseService().RaiseRequest(
                                              user.displayName.toString(),
                                              user.uid,
                                              DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              widget.profession,
                                              "no_image_in_firebase.png",
                                              Description,
                                              userData!.latitude,
                                              userData.longitude);
                                        }

                                        if (FileName !=
                                            "no_image_in_firebase.png") {
                                          await DatabaseService().RaiseRequest(
                                              user.displayName.toString(),
                                              user.uid,
                                              DateTime.now()
                                                  .millisecondsSinceEpoch,
                                              widget.profession,
                                              UUID,
                                              Description,
                                              userData!.latitude,
                                              userData.longitude);
                                          storage.uploudFile(Path, UUID).then(
                                              (value) => print('Uplouded'));
                                        }
                                      }
                                      Navigator.pop(context);
                                    } else {
                                      showSimpleNotification(
                                          Text('You have no connection!'),
                                          background: Colors.red);
                                    }
                                  },
                                  child: Text('Submit'),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ));
                } else {
                  return Loading();
                }
              }),
        ),
      ),
    );
  }
}
