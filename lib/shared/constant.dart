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
  hintText: 'Enter You Email',
  fillColor: Colors.white,
  filled: true,
  // Color when it is clicked
  border: OutlineInputBorder(
      borderSide: const BorderSide(
    color: AppColors.underlineColor,
    width: 0.5,
  )),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 105, 21, 216),
      width: 0.5,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 255, 17, 0),
      width: 0.6,
    ),
  ),
  label: Text(
    'Enter an E-Mail',
    style: const TextStyle(
      fontSize: 14,
      fontFamily: Constants.appFont,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
  ),
  prefixIcon: Icon(
    Icons.email,
    color: Colors.grey,
    size: 22,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: AppColors.backgroundColor,
      width: 0.5,
    ),
  ),
  // Color when not in clicked
  enabledBorder: OutlineInputBorder(
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
      borderSide: const BorderSide(
    color: AppColors.underlineColor,
    width: 0.5,
  )),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 105, 21, 216),
      width: 0.5,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 255, 17, 0),
      width: 0.6,
    ),
  ),
  label: Text(
    'Enter Your Name',
    style: const TextStyle(
      fontSize: 14,
      fontFamily: Constants.appFont,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
  ),
  prefixIcon: Icon(
    Icons.person,
    color: Colors.grey,
    size: 22,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: AppColors.backgroundColor,
      width: 0.5,
    ),
  ),
  // Color when not in clicked
  enabledBorder: OutlineInputBorder(
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
      borderSide: const BorderSide(
    color: AppColors.underlineColor,
    width: 0.5,
  )),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 105, 21, 216),
      width: 0.5,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 255, 17, 0),
      width: 0.6,
    ),
  ),
  label: Text(
    'Password',
    style: const TextStyle(
      fontSize: 14,
      fontFamily: Constants.appFont,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
  ),
  prefixIcon: Icon(
    Icons.lock,
    color: Colors.grey,
    size: 22,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: AppColors.backgroundColor,
      width: 0.5,
    ),
  ),
  // Color when not in clicked
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.underlineColor,
      width: 0.5,
    ),
  ),
);
