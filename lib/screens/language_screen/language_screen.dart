import 'package:flutter/material.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/main.dart';
import 'package:ketabook/screens/language_screen/widgets/language_list_item.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  static String routeName = "/language_screen";

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  SessionManager prefs = SessionManager();
  AppNotifier application;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
  }

  void _changeLanguage(String language) {
    Locale _temp;
    switch (language) {
      case 'en':
        _temp = Locale('en', 'US');
        prefs.setLanguage('English');
        MyApp.setLocale(context, _temp, 'English');
        application.setCurrentLanguage('English');
        break;
      case 'ar':
        _temp = Locale('ar', 'AR');
        prefs.setLanguage('Arabic');
        MyApp.setLocale(context, _temp, 'Arabic');
        application.setCurrentLanguage('Arabic');
        break;
      default:
        _temp = Locale('en', 'US');
        prefs.setLanguage('English');
        MyApp.setLocale(context, _temp, 'English');
        application.setCurrentLanguage('English');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trans(context, 'language'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(30),
                      ),
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              LanguageListItem(
                onTap: () => _changeLanguage('en'),
                title: trans(context, 'english'),
                icon: 'assets/images/ic_english.png',
              ),
              Divider(height: 0, thickness: 1, color: Color(0xFFEFEFF4)),
              LanguageListItem(
                onTap: () => _changeLanguage('ar'),
                title: trans(context, 'arabic'),
                icon: 'assets/images/ic_arabic.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
