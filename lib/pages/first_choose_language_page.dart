import 'package:comparify/pages/first_intro.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/multi_languages.dart';

class FirstChooseLanguagePage extends StatefulWidget {
  FirstChooseLanguagePage({Key? key}) : super(key: key);

  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<FirstChooseLanguagePage> {
  MultiLanguages multiLanguages = MultiLanguages();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future checkFirstSeen() async {
    var locale = await multiLanguages.readLocaleKey();
    bool languageSet = locale != null && locale != "";
    if (languageSet) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new FirstIntro()));
    }
  }

  Future setSeenCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('localeKey', "");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkFirstSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  color: ApiConstants.buttonsAndMenuColor),
            );
          } else {
            return createChooseLanguagePage();
          }
        });
  }

  Widget createChooseLanguagePage() {
    Widget latvianTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("latvian"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor,
                    fontSize: ApiConstants.languageFontSize),
              ))),
    );
    Widget russianTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("russian"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor,
                    fontSize: ApiConstants.languageFontSize),
              ))),
    );
    Widget englishTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("english"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor,
                    fontSize: ApiConstants.languageFontSize),
              ))),
    );
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return Container(
          alignment: Alignment.center,
          child: ListView(children: <Widget>[
            Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(
                      MultiLanguages.of(context)!.translate("chooseLanguage"),
                      style: const TextStyle(
                          height: 1.5,
                          fontFamily: "Roboto",
                          fontSize: ApiConstants.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: ApiConstants.mainFontColor))),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                      onTap: () {
                        multiLanguages.setLocale(
                            context, const Locale("lv", "LV"));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FirstIntro()));
                        ;
                        // }
                      },
                      child: Row(children: <Widget>[
                        latvianTextSection,
                        const ImageIcon(AssetImage("assets/go_futher.png"),
                            color: ApiConstants.mainFontColor)
                      ]))),
              const Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      multiLanguages.setLocale(
                          context, const Locale("ru", "RU"));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FirstIntro()));
                    },
                    child: Row(children: <Widget>[
                      russianTextSection,
                      const ImageIcon(AssetImage("assets/go_futher.png"),
                          color: ApiConstants.mainFontColor)
                    ])),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                      onTap: () {
                        multiLanguages.setLocale(
                            context, const Locale("en", "EN"));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FirstIntro()));
                      },
                      child: Row(children: <Widget>[
                        englishTextSection,
                        const ImageIcon(AssetImage("assets/go_futher.png"),
                            color: ApiConstants.mainFontColor)
                      ]))),
              const Divider(
                color: Colors.grey,
              )
            ])
          ]));
    }));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
