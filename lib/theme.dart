import 'package:flutter/material.dart';
import 'package:ketabook/constants.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Muli",
    primaryColor: kPrimaryColor,
    accentColor: kPrimaryColor,
    appBarTheme: lightAppBarTheme(),
    textTheme: lightTextTheme(),
    cardColor: Colors.white,
    hintColor: Colors.black,
    // iconTheme: IconThemeData(color: Colors.black),
    //cardTheme: CardTheme(shadowColor: Colors.black.withOpacity(0.4)),
    unselectedWidgetColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: ThemeData.dark().primaryColor,
    fontFamily: "Muli",
    primaryColor: kPrimaryColor,
    accentColor: kPrimaryColor,
    appBarTheme: darkAppBarTheme(),
    textTheme: darkTextTheme(),
    hintColor: Colors.white,
    cardColor: ThemeData.dark().primaryColor,
    // iconTheme: IconThemeData(color: Colors.white),
    //cardTheme: CardTheme(shadowColor: Colors.black),
    unselectedWidgetColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

TextTheme lightTextTheme() {
  return TextTheme(
    headline2: TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
    headline3: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.black),
    headline4: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    subtitle1: TextStyle(
      fontSize: 17,
      color: Colors.black87,
      fontWeight: FontWeight.w600,
    ),
    subtitle2: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.black.withOpacity(0.7),
    ),
    bodyText1: TextStyle(color: kLightTextColor),
    bodyText2: TextStyle(color: kLightTextColor),
    headline6: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontFamily: 'SfProText',
    ),
  );
}

TextTheme darkTextTheme() {
  return TextTheme(
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 15,
    ),
    headline3: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w500,
      fontSize: 20,
      color: Colors.white,
    ),
    headline4: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    subtitle1: TextStyle(
      fontSize: 17,
      color: Colors.white.withOpacity(0.9),
      fontWeight: FontWeight.w600,
    ),
    subtitle2: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.white.withOpacity(0.7),
    ),
    bodyText1: TextStyle(color: kLightTextColor),
    bodyText2: TextStyle(color: kLightTextColor),
    headline6: TextStyle(color: Colors.white),
  );
}

AppBarTheme lightAppBarTheme() {
  return AppBarTheme(
    color: Colors.white,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline5: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontFamily: 'SfProText',
        fontSize: 17,
      ),
    ),
  );
}

AppBarTheme darkAppBarTheme() {
  return AppBarTheme(
    color: ThemeData.dark().primaryColor,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
