import 'package:flutter/material.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/providers/data_provider.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/main.dart';
import 'package:ketabook/screens/login_screen/login_screen.dart';
import 'package:ketabook/screens/on_board_screen/on_board_screen.dart';
import 'package:ketabook/screens/tabs_screen/tabs_screen.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:provider/provider.dart';
import 'package:ketabook/models/book.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SessionManager prefs = SessionManager();
  AppNotifier application;
  AuthProvider auth;
  CartProvider cart;
  bool disabled = false;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
    auth = Provider.of<AuthProvider>(context, listen: false);
    cart = Provider.of<CartProvider>(context, listen: false);

    _retrieveData();
  }

  _retrieveData() async {
    double totalPrice = 0.0;
    List<Book> cartBooks = [];

    prefs.getLanguage().then((language) {
      if (language == 'English') {
        application.setCurrentLanguage('English');
        MyApp.setLocale(context, Locale('en', 'US'), 'English');
      } else if (language == 'Arabic') {
        application.setCurrentLanguage('Arabic');
        MyApp.setLocale(context, Locale('ar', 'AR'), 'Arabic');
      } else {
        application.setCurrentLanguage('English');
        MyApp.setLocale(context, Locale('en', 'US'), 'English');
      }
    });

    await HttpService().getUserInfo().then((user) {
      if (user != null && user.id != null) {
        auth.setUser(user);
        print(user.statusCode);
        if (user.statusCode == '3') {
          setState(() {
            disabled = true;
          });
        }
      } else {
        setState(() {
          disabled = true;
          prefs.clearUserId();
        });
      }
    });

    await HttpService().getUniversities(context);

    if (auth.user != null) {
      Provider.of<DataProvider>(context, listen: false).fetchLimitedRecentBooks(
          context: context, id: auth.user != null ? auth.user.id : '');
    } else {
      Provider.of<DataProvider>(context, listen: false)
          .fetchLimitedRecentBooks(context: context, id: '');
    }

    await HttpService().getSlideshowImages(context).then((value) {
      application.addSlideShowImages(value);
    });

    if (auth.user != null)
      await HttpService().getCart().then((c) {
        if (c != null) {
          setState(() {
            cart.setUserCart(c);
          });
          c.forEach((ct) async {
            totalPrice += double.parse(ct.priceService);
            await HttpService().getBook(ct.bookId).then((book) {
              setState(() {
                cartBooks.add(book);
              });
            });
          });
          cart.setUserCartBooks(cartBooks);
          cart.setCartTotalPrice(totalPrice);
        }
      });

    prefs.checkFirstTime().then((firstTime) async {
      if (firstTime == null) {
        await prefs.setFirstTime(false);
        Navigator.pushReplacementNamed(context, OnBoardScreen.routeName);
      } else {
        await prefs.getUserId().then((value) async {
          if (value != null && !disabled)
            Navigator.pushReplacementNamed(context, TabsScreen.routeName);
          else
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Text(
          'Ketabook',
          style: Theme.of(context).textTheme.headline6.merge(
                TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.w400,
                ),
              ),
        ),
      ),
    );
  }
}
