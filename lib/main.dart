import 'package:comparify/pages/first_choose_language_page.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/helpers/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // await Upgrader.clearSavedSettings(); // REMOVE this for release builds

  // if (Platform.isAndroid) {
  //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();

  static void setLocal(BuildContext context, Locale newLocale) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state!.changeLocale(newLocale);
  }
}

class MyAppState extends State<MyApp> {
  Locale locale = const Locale.fromSubtags(languageCode: 'lv');

  void changeLocale(Locale locale) {
    setState(() {
      this.locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final multiLanguages = MultiLanguages();
    final localeKey = await multiLanguages.readLocaleKey();
    if (localeKey == 'en') {
      locale = const Locale("en", "EN");
    } else if (localeKey == 'lv') {
      locale = const Locale.fromSubtags(languageCode: "lv");
    } else if (localeKey == 'ru') {
      locale = const Locale.fromSubtags(languageCode: "ru");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: const [
          Locale('en', 'EN'),
          Locale('lv', 'LV'),
          Locale('ru', 'RU')
        ],
        localizationsDelegates: [
          MultiLanguages.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: locale,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocaleLanguagle in supportedLocales) {
            if (supportedLocaleLanguagle.languageCode == locale?.languageCode &&
                supportedLocaleLanguagle.countryCode == locale?.countryCode) {
              return supportedLocaleLanguagle;
            }
          }
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Roboto",
          // primaryColor: Colors.white,
          scaffoldBackgroundColor: ApiConstants.mainBackgroundColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: UpgradeAlert(child: FirstChooseLanguagePage()));
  }
}
