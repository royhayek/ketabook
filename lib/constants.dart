import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFCCA09);
const kBackgroundColor = Color(0xFFF3F3F3);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
var kSecondaryColor = Colors.lightBlue.shade400;
var kCardBackgroundColor = Colors.black.withOpacity(0.6);
const kLightTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kNameNullError = "Please enter your name";
const String kShortNameError = "Name is too short";
const String kEmailNullError = "Please enter your email";
const String kInvalidEmailError = "Please enter a valid Email";
const String kPassNullError = "Please enter your password";
const String kShortPassError = "Password must be a min 6 characters";
const String kMatchPassError = "That password does not match our records";
const String kWrongEmailError = "That email does not match our records";
const String kWrongUsernameError = "That username does not match our records";
const String kEmailExistError = "Email Address already exist!";
const String kInvalidCredentials = "Invalid login credentials";
