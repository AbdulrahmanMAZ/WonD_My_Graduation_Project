import 'dart:ui';

import 'package:coffre_app/pages/authenricate/authenticate.dart';
import 'package:coffre_app/shared/constant.dart';
import 'package:coffre_app/shared/loading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../services/auth.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Register extends StatefulWidget {
//  const Register({Key? key}) : super(key: key);

  final Function toggleView;
  Register({required this.toggleView});
  // final List<String> professions = [
  //   'Hairdresser',
  //   'Mechanic',
  //   'Electrician',
  //   'plumber'
  // ];

  var proffessionsIdentifier = {
    "ميكب ارتست / حلاق": "Hairdresser",
    "كهربائي": "Electrician",
    "سباكة": "plumber",
    "ميكانيكي": "Mechanic",
    "Hair Dresser": "Hairdresser",
    "Electrician": "Electrician",
    "Plumber": "plumber",
    "Mechanic": "Mechanic"
  };

  //  final Dixt<String> professions = [
  //   'Hairdresser',
  //   'Mechanic',
  //   'Electrician',
  //   'plumber'
  // ];
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthSrrvice _auth = AuthSrrvice();
  bool _passwordVisible = true;
  bool _RepasswordVisible = true;
  final _formKey = GlobalKey<FormState>();
  String? _currentProfession = 'Customer';
  String email = '';
  String password = '';
  String Re_password = '';
  String username = '';
  String Phone_Number = '';
  String error = '';
  bool loading = false;

  bool isWorker = false;
  bool isShop = false;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Worker ',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 82, 69, 99)),
          children: [
            TextSpan(
              text: 'on',
              style: TextStyle(
                  color: Color.fromARGB(255, 187, 174, 174), fontSize: 30),
            ),
            TextSpan(
              text: ' Duty',
              style: TextStyle(
                  color: Color.fromARGB(213, 47, 11, 94), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        widget.toggleView();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.haveAccount,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              AppLocalizations.of(context)!.loginButton,
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> professions = [
      AppLocalizations.of(context)!.hairDresser,
      AppLocalizations.of(context)!.electrician,
      AppLocalizations.of(context)!.mechanic,
      AppLocalizations.of(context)!.plumber
    ];
    final height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                        reverse: true,
                        child: Stack(
                          children: [
                            Container(
                              // padding:
                              //     EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(height: 15),
                                      _title(),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .registerWelcomeParagraph,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: Constants.appFont,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      //Username text field
                                      // TextFormField(
                                      //     decoration: textInputDecoration.copyWith(),
                                      //     validator: (val) =>
                                      //         val!.isEmpty ? 'enter a value' : null,
                                      //     onChanged: (val) {
                                      //       setState(() {
                                      //         username = val;
                                      //       });
                                      //     }),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!
                                                .fullname,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              decoration:
                                                  userInputDecoration.copyWith(
                                                      labelText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .enterName,
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .enterName),
                                              validator: (val) => val!.isEmpty
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .enterEmail
                                                  : null,
                                              onChanged: (val) {
                                                setState(() {
                                                  username = val;
                                                });
                                              }),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),

                                      // E-Mail text field
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!.email,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              decoration:
                                                  textInputDecoration.copyWith(
                                                      labelText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .enterEmail,
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .enterEmail),
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .deny(RegExp("[ ]")),
                                              ],
                                              validator: (val) {
                                                if (val != null &&
                                                    val.isEmpty) {
                                                  return AppLocalizations.of(
                                                          context)!
                                                      .enterEmail;
                                                }
                                                if (val != null &&
                                                    !EmailValidator.validate(
                                                        val)) {
                                                  return AppLocalizations.of(
                                                          context)!
                                                      .validEmail;
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onChanged: (val) {
                                                setState(() {
                                                  email = val;
                                                });
                                              }),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!
                                                .phoneNumber,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                              ],
                                              decoration:
                                                  userInputDecoration.copyWith(
                                                      hintText: AppLocalizations
                                                              .of(context)!
                                                          .phoneNumberExample,
                                                      labelText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .enterPhoneNumber),
                                              validator: (val) {
                                                if (val != null &&
                                                    val.isEmpty) {
                                                  return AppLocalizations.of(
                                                          context)!
                                                      .enterPhoneNumber;
                                                } else if (val != null &&
                                                        val.length > 9 ||
                                                    val != null &&
                                                        val.length < 9) {
                                                  return AppLocalizations.of(
                                                          context)!
                                                      .notValidPhoneNumber;
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onChanged: (val) {
                                                setState(() {
                                                  Phone_Number = val;
                                                });
                                              }),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      //Password text field
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!
                                                .enterPass,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            controller: _pass,
                                            decoration: InputDecoration(
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .shorPass,
                                              fillColor: Colors.white,
                                              filled: true,
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _passwordVisible =
                                                        !_passwordVisible;
                                                  });
                                                },
                                                icon: Icon(_passwordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .underlineColor,
                                                    width: 0.5,
                                                  )),

                                              // Color when it is clicked
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 105, 21, 216),
                                                  width: 0.5,
                                                ),
                                              ),
                                              labelText:
                                                  AppLocalizations.of(context)!
                                                      .enterPass,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: Colors.grey,
                                                size: 22,
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 255, 17, 0),
                                                  width: 0.6,
                                                ),
                                              ),

                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                  color:
                                                      AppColors.underlineColor,
                                                  width: 0.5,
                                                ),
                                              ),

                                              // Color when not in clicked
                                            ),
                                            validator: (val) => val!.length < 8
                                                ? AppLocalizations.of(context)!
                                                    .shorPass
                                                : null,
                                            obscureText: _passwordVisible,
                                            onChanged: (val) {
                                              setState(() {
                                                password = val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      //Reapet Password
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!
                                                .reEnterPass,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              controller: _confirmPass,
                                              decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .reEnterPass,
                                                fillColor: Colors.white,
                                                filled: true,
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _RepasswordVisible =
                                                          !_RepasswordVisible;
                                                    });
                                                  },
                                                  icon: Icon(_RepasswordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide(
                                                      color: AppColors
                                                          .underlineColor,
                                                      width: 0.5,
                                                    )),

                                                // Color when it is clicked
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 105, 21, 216),
                                                    width: 0.5,
                                                  ),
                                                ),
                                                labelText: AppLocalizations.of(
                                                        context)!
                                                    .reEnterPass,
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: Colors.grey,
                                                  size: 22,
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 17, 0),
                                                    width: 0.6,
                                                  ),
                                                ),

                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 245, 243, 247),
                                                    width: 0.5,
                                                  ),
                                                ),

                                                // Color when not in clicked
                                              ),
                                              validator: (val) {
                                                if (val!.isEmpty)
                                                  return AppLocalizations.of(
                                                          context)!
                                                      .empty;
                                                if (val != _pass.text)
                                                  return AppLocalizations.of(
                                                          context)!
                                                      .notMatchPass;
                                                return null;
                                              },
                                              obscureText: _RepasswordVisible),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor:
                                                Colors.white),
                                        child: CheckboxListTile(
                                          tileColor: Colors.white,
                                          checkColor:
                                              Color.fromARGB(255, 139, 43, 143),
                                          activeColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                          selectedTileColor: Colors.amber,
                                          title: Text(
                                            AppLocalizations.of(context)!
                                                .asWorker,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          value: this.isWorker,
                                          onChanged: (value) {
                                            setState(() {
                                              this.isWorker = value as bool;
                                            });
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: isWorker,
                                        child: DropdownButtonFormField(
                                          dropdownColor:
                                              Color.fromARGB(255, 89, 25, 97),
                                          value: professions[0],
                                          //  icon: Icon(Icons.arrow_downward),
                                          items: professions.map((String e) {
                                            return DropdownMenuItem(
                                                value: e,
                                                child: Text(
                                                  '$e ',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          207, 255, 255, 255)),
                                                ));
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _currentProfession =
                                                  widget.proffessionsIdentifier[
                                                      newValue] as String;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),

                                      // Register Button
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size.fromHeight(50),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            primary:
                                                Color.fromARGB(228, 51, 2, 61),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            // elevation: 3,
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                loading = true;
                                              });
                                              dynamic result = await _auth
                                                  .RegisterWithEmailAndPassword(
                                                      username,
                                                      email,
                                                      password,
                                                      isWorker,
                                                      _currentProfession
                                                          as String,
                                                      '+966' + Phone_Number);
                                              print(result);
                                              if (result == null) {
                                                setState(() {
                                                  loading = false;
                                                  error = AppLocalizations.of(
                                                          context)!
                                                      .incorrectInfo;
                                                });
                                              }
                                              // print(email);
                                              // print(password);
                                            }
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .register,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 22,
                                              fontFamily: Constants.appFont,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      _loginAccountLabel(),
                                      Text(error)
                                    ],
                                  )),

                              //     //Button for anonyoums

                              // child: ElevatedButton(
                              //   onPressed: () async {
                              //     dynamic result = await _auth.signINAnon();
                              //     if (result == null) {
                              //       print('Sorry you are not logged in');
                              //     } else {
                              //       print('You are looged in ');
                              //       print(result);
                              //     }
                              //   },
                              //   child: Text('Anonymuos Sign In'),
                              // )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, height);
    path.lineTo(size.width, 0);

    /// [Top Left corner]
    var secondControlPoint = Offset(0, 0);
    var secondEndPoint = Offset(width * .5, height * .3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    /// [Left Middle]
    var fifthControlPoint = Offset(width * .3, height * .2);
    var fiftEndPoint = Offset(width * .23, height * .1);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy,
        fiftEndPoint.dx, fiftEndPoint.dy);

    /// [Bottom Left corner]
    var thirdControlPoint = Offset(0, height);
    var thirdEndPoint = Offset(width, height);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
      angle: -pi / 3.5,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xfffbb448), Color(0xffe46b10)])),
        ),
      ),
    ));
  }
}
