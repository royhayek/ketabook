import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/cart_provider.dart';
import 'package:ketabook/routes.dart';
import 'package:ketabook/screens/splash_screen/splash_screen.dart';
import 'package:ketabook/theme.dart';
import 'package:ketabook/translation/app_localizations.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:ketabook/providers/data_provider.dart';
import 'package:ketabook/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppNotifier(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale, String language) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<AppNotifier>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Ketabook',
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          locale: _locale,
          supportedLocales: [
            Locale('en', 'EN'),
            Locale('ar', 'AR'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale.languageCode &&
                  locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
          builder: (context, child) {
            return Directionality(
              textDirection:
                  isEnglish(context) ? TextDirection.ltr : TextDirection.rtl,
              child: child,
            );
          },
          theme: AppTheme.lightTheme,
          initialRoute: SplashScreen.routeName,
          routes: routes,
        );
      },
    );
  }
}
