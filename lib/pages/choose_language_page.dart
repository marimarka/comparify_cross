import 'package:comparify/pages/about_us_page.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/home.dart';
import 'package:flutter/material.dart';

import 'helpers/multi_languages.dart';

class ChooseLanguagePage extends StatefulWidget {
  ChooseLanguagePage({Key? key}) : super(key: key);

  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguagePage> {
  MultiLanguages multiLanguages = MultiLanguages();

  @override
  Widget build(BuildContext context) {
    Widget latvianTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("latvian"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor,
                    fontSize: ApiConstants.languageAndAboutFontSize),
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
                    fontSize: ApiConstants.languageAndAboutFontSize),
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
                    fontSize: ApiConstants.languageAndAboutFontSize),
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Home()));
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AboutUsPage()));
                    },
                    child: Row(children: <Widget>[
                      russianTextSection,
                      const ImageIcon(AssetImage("assets/go_futher.png"),
                          color: ApiConstants.mainFontColor)
                    ]),
                  )),
              const Divider(
                color: Colors.grey,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                      onTap: () {
                        multiLanguages.setLocale(
                            context, const Locale("en", "EN"));
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Home()));
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
