import 'package:flutter/widgets.dart';
import 'package:ketabook/screens/account_screen/account_screen.dart';
import 'package:ketabook/screens/book_details_screen/book_details_screen.dart';
import 'package:ketabook/screens/books_screen/books_screen.dart';
import 'package:ketabook/screens/checkout_screen/checkout_screen.dart';
import 'package:ketabook/screens/filter_screen/filter_screen.dart';
import 'package:ketabook/screens/information_screen/information_screen.dart';
import 'package:ketabook/screens/language_screen/language_screen.dart';
import 'package:ketabook/screens/my_books_screen/my_books_screen.dart';
import 'package:ketabook/screens/orders_history_screen/orders_history_screen.dart';
import 'package:ketabook/screens/packages_screen/packages_screen.dart';
import 'package:ketabook/screens/profile_screen/profile_screen.dart';
import 'package:ketabook/screens/faculties_screen/faculties_screen.dart';
import 'package:ketabook/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:ketabook/screens/login_screen/login_screen.dart';
import 'package:ketabook/screens/on_board_screen/on_board_screen.dart';
import 'package:ketabook/screens/register_screen/register_screen.dart';
import 'package:ketabook/screens/shopping_cart_screen/shopping_cart_screen.dart';
import 'package:ketabook/screens/splash_screen/splash_screen.dart';
import 'package:ketabook/screens/tabs_screen/tabs_screen.dart';
import 'package:ketabook/screens/universities_colleges_screen/universities_colleges_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  OnBoardScreen.routeName: (context) => OnBoardScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  TabsScreen.routeName: (context) => TabsScreen(),
  FacultiesScreen.routeName: (context) => FacultiesScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  BooksScreen.routeName: (context) => BooksScreen(),
  AccountScreen.routeName: (context) => AccountScreen(),
  OrdersHistoryScreen.routeName: (context) => OrdersHistoryScreen(),
  InformationScreen.routeName: (context) => InformationScreen(),
  LanguageScreen.routeName: (context) => LanguageScreen(),
  ShoppingCartScreen.routeName: (context) => ShoppingCartScreen(),
  FilterScreen.routeName: (context) => FilterScreen(),
  BookDetailsScreen.routeName: (context) => BookDetailsScreen(),
  CheckoutScreen.routeName: (context) => CheckoutScreen(),
  MyBooksScreen.routeName: (context) => MyBooksScreen(),
  PackagesScreen.routeName: (context) => PackagesScreen(),
  UniversitiesCollegesScreen.routeName: (context) =>
      UniversitiesCollegesScreen(),
};
