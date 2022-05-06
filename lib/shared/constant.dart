import 'dart:math';

import 'package:flutter/material.dart';

class ScreenSettings {
  static Size _getScreenSize(BuildContext context) =>
      MediaQuery.of(context).size;

  static double _getScreenHeight(BuildContext context) =>
      _getScreenSize(context).height;
  static double _getScreenWidth(BuildContext context) =>
      _getScreenSize(context).width;
  static double setScreenHeight(BuildContext context, double height) =>
      _getScreenHeight(context) * height;
  static double setScreenWidth(BuildContext context, double width) =>
      _getScreenWidth(context) * width;
  static double getFullWidth() => double.maxFinite;
  static double getFulleight() => double.maxFinite;
}

class Constants {
  static const String xLogo = "assets/images/x-mark.png";
  static const String googleImg = "assets/images/google.png";
  static const String twitterImg = "assets/images/twitter.png";
  static const String facebookImg = "assets/images/facebook.png";
  static const String appFont = "Sofia Pro";
}

class AppColors {
  static const Color backgroundColor = Color.fromRGBO(66, 53, 83, 1);
  static const Color whiteColor = Colors.white;
  static const Color blacColor = Colors.black;
  static const Color logoColor = Color.fromRGBO(59, 0, 81, 1);
  static const Color underlineColor = Color.fromRGBO(132, 0, 238, 1);
  static const Color bodySectionColor = Color.fromRGBO(74, 61, 89, 1);
  static const Color Allbackgroundcolor = Color.fromARGB(37, 142, 187, 245);
}

InputDecoration textInputDecoration = InputDecoration(
  hintText: 'Ex: Worker@gmail.com',
  fillColor: Colors.white,
  filled: true,
  // Color when it is clicked
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        color: AppColors.underlineColor,
        width: 0.5,
      )),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 105, 21, 216),
      width: 0.5,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 255, 17, 0),
      width: 0.6,
    ),
  ),
  labelText: 'Enter an E-Mail',
  floatingLabelBehavior: FloatingLabelBehavior.never,
  prefixIcon: Icon(
    Icons.email,
    color: Colors.grey,
    size: 22,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: AppColors.backgroundColor,
      width: 0.5,
    ),
  ),
  // Color when not in clicked
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(
      color: AppColors.underlineColor,
      width: 0.5,
    ),
  ),
);

InputDecoration userInputDecoration = InputDecoration(
  hintText: 'Enter Your Name',
  fillColor: Colors.white,
  filled: true,
  // Color when it is clicked
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        color: AppColors.underlineColor,
        width: 0.5,
      )),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 105, 21, 216),
      width: 0.5,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 255, 17, 0),
      width: 0.6,
    ),
  ),
  labelText: 'Enter Your Name',
  floatingLabelBehavior: FloatingLabelBehavior.never,

  prefixIcon: Icon(
    Icons.person,
    color: Colors.grey,
    size: 22,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: AppColors.backgroundColor,
      width: 0.5,
    ),
  ),
  // Color when not in clicked
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(
      color: AppColors.underlineColor,
      width: 0.5,
    ),
  ),
);

InputDecoration passwordInputDecoration = InputDecoration(
  hintText: 'Enter You Password',
  fillColor: Colors.white,
  filled: true,

  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(
        color: AppColors.underlineColor,
        width: 0.5,
      )),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 105, 21, 216),
      width: 0.5,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 255, 17, 0),
      width: 0.6,
    ),
  ),
  labelText: 'Enter Your Nameee',
  floatingLabelBehavior: FloatingLabelBehavior.never,
  prefixIcon: Icon(
    Icons.lock,
    color: Colors.grey,
    size: 22,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: AppColors.backgroundColor,
      width: 0.5,
    ),
  ),
  // Color when not in clicked
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(
      color: AppColors.underlineColor,
      width: 0.5,
    ),
  ),
);

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

Positioned PositionedBackground(context) {
  Random rand = Random();
  double randNumber = rand.nextInt(10) / 10;
  return Positioned(
    top: -MediaQuery.of(context).size.height * .0,
    right: -MediaQuery.of(context).size.width * .2,
    child: Container(
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
                  colors: [
                Color.fromARGB(255, 59, 111, 179),
                Color.fromARGB(214, 156, 18, 145)
              ])),
        ),
      ),
    )),
  );
}
