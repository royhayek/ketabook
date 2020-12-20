import 'package:flutter/material.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/screens/account_screen/widgets/account_list_item.dart';
import 'package:ketabook/screens/information_screen/information_screen.dart';
import 'package:ketabook/screens/language_screen/language_screen.dart';
import 'package:ketabook/screens/login_screen/login_screen.dart';
import 'package:ketabook/screens/my_books_screen/my_books_screen.dart';
import 'package:ketabook/screens/orders_history_screen/orders_history_screen.dart';
import 'package:ketabook/screens/profile_screen/profile_screen.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static String routeName = "/account_screen";

  final String title;

  const AccountScreen({Key key, this.title}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  SessionManager prefs = SessionManager();
  String userId;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    var cart = Provider.of<CartProvider>(context, listen: false);
    userId = auth.user != null ? auth.user.id : null;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(16),
                  right: getProportionateScreenWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trans(context, 'settings'),
                    style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(30),
                          ),
                        ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(14)),
                  Text(
                    trans(context, 'account'),
                    style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(17),
                          ),
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(25)),
            Padding(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(16)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    userId == null
                        ? AccountListItem(
                            title: trans(context, 'sign_in'),
                            icon: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: SizeConfig.screenWidth / 22,
                            ),
                            onPressed: () => Navigator.popUntil(
                              context,
                              ModalRoute.withName(LoginScreen.routeName),
                            ),
                          )
                        : Container(),
                    userId != null
                        ? AccountListItem(
                            title: trans(context, 'my_profile'),
                            icon: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: SizeConfig.screenWidth / 22,
                            ),
                            onPressed: () => Navigator.pushNamed(
                              context,
                              ProfileScreen.routeName,
                            ),
                          )
                        : Container(),
                    userId != null
                        ? AccountListItem(
                            title: trans(context, 'my_books'),
                            icon: Icon(
                              Icons.book,
                              color: Colors.white,
                              size: SizeConfig.screenWidth / 22,
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyBooksScreen(),
                              ),
                            ),
                          )
                        : Container(),
                    userId != null
                        ? AccountListItem(
                            title: trans(context, 'order_history'),
                            icon: Icon(
                              Icons.history,
                              color: Colors.white,
                              size: SizeConfig.screenWidth / 22,
                            ),
                            onPressed: () => Navigator.pushNamed(
                              context,
                              OrdersHistoryScreen.routeName,
                            ),
                          )
                        : Container(),
                    AccountListItem(
                      title: trans(context, 'about_us'),
                      icon: Icon(
                        Icons.info,
                        color: Colors.white,
                        size: SizeConfig.screenWidth / 22,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InformationScreen(title: 'about_us'),
                        ),
                      ),
                    ),
                    AccountListItem(
                      title: trans(context, 'faq'),
                      icon: Icon(
                        Icons.contact_support,
                        color: Colors.white,
                        size: SizeConfig.screenWidth / 22,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationScreen(title: 'faq'),
                        ),
                      ),
                    ),
                    AccountListItem(
                      title: trans(context, 'terms_of_use'),
                      icon: Icon(
                        Icons.text_snippet,
                        color: Colors.white,
                        size: SizeConfig.screenWidth / 22,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InformationScreen(title: 'terms_of_use'),
                        ),
                      ),
                    ),
                    AccountListItem(
                      title: trans(context, 'contact_us'),
                      icon: Icon(
                        Icons.call,
                        color: Colors.white,
                        size: SizeConfig.screenWidth / 22,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InformationScreen(title: 'contact_us'),
                        ),
                      ),
                    ),
                    AccountListItem(
                      title: trans(context, 'language'),
                      icon: Icon(
                        Icons.language,
                        color: Colors.white,
                        size: SizeConfig.screenWidth / 22,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LanguageScreen(),
                        ),
                      ),
                    ),
                    userId != null
                        ? AccountListItem(
                            title: trans(context, 'logout'),
                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: SizeConfig.screenWidth / 22,
                            ),
                            onPressed: () {
                              prefs.clearUserId();
                              cart.clearUserCart();
                              auth.setUser(null);
                              Navigator.popAndPushNamed(
                                  context, LoginScreen.routeName);
                            },
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
