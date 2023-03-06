import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/helpers/multi_languages.dart';
import 'package:comparify/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstIntro extends StatefulWidget {
  static String id = 'Intro';

  @override
  State<StatefulWidget> createState() {
    return FirstIntroState();
  }
}

class FirstIntroState extends State<FirstIntro> {
  List<ContentConfig> listSlides = [];

  Color activeColor = Colors.white;
  Color inactiveColor = const Color(0xff0c46dd);

  Color indicatorActiveColor = const Color(0xff0c46dd);
  Color indicatorInactiveColor = const Color(0xFFCFE6FF);

  double sizeIndicator = 10;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    print(_seen);
    if (_seen) {

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Home()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new FirstIntro()));
    }
  }

  Future setSeenCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
  }

  @override
  Widget build(BuildContext context) {
    createIntros();
    return FutureBuilder(
        future: checkFirstSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                  color: ApiConstants.buttonsAndMenuColor),
            );
          } else {
            return IntroSlider(
              listContentConfig: listSlides,
              skipButtonStyle: myButtonStyle(),
              doneButtonStyle: myButtonStyle(),
              nextButtonStyle: myButtonStyle(),
              onSkipPress: onSkipPress,
              onDonePress: onPressedDone,
              indicatorConfig: IndicatorConfig(
                sizeIndicator: sizeIndicator,
                indicatorWidget: Container(
                  width: sizeIndicator,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: indicatorInactiveColor),
                ),
                activeIndicatorWidget: Container(
                  width: sizeIndicator + 15,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: indicatorActiveColor),
                ),
                spaceBetweenIndicator: 15,
                typeIndicatorAnimation: TypeIndicatorAnimation.sliding,
              ),
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
  }

  TextStyle titleStyle() => const TextStyle(
      color: ApiConstants.mainFontColor,
      fontSize: 22,
      fontWeight: FontWeight.bold);

  onPressedDone() {
    setSeenCheck();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => new Home()));
  }

  onSkipPress() {
    setSeenCheck();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => new Home()));
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      foregroundColor: MaterialStateProperty.all<Color>(activeColor),
      backgroundColor: MaterialStateProperty.all<Color>(inactiveColor),
    );
  }

  void createIntros(){
     listSlides.add(ContentConfig(
      title: MultiLanguages.of(context)!.translate("intro1Title"),
      styleTitle: titleStyle(),
      description: MultiLanguages.of(context)!.translate("intro1Text"),
      styleDescription: const TextStyle(
          color: ApiConstants.mainFontColor,
          fontSize: ApiConstants.languageAndAboutFontSize),
      pathImage: "assets/intro/intro1.png",
      backgroundColor: ApiConstants.mainBackgroundColor,
    ));
    listSlides.add(ContentConfig(
      title: MultiLanguages.of(context)!.translate("intro2Title"),
      styleTitle: titleStyle(),
      description: MultiLanguages.of(context)!.translate("intro2Text"),
      styleDescription: const TextStyle(
          color: ApiConstants.mainFontColor,
          fontSize: ApiConstants.languageAndAboutFontSize),
      pathImage: "assets/intro/intro2.png",
      backgroundColor: ApiConstants.mainBackgroundColor,
    ));
    listSlides.add(ContentConfig(
      title: MultiLanguages.of(context)!.translate("intro3Title"),
      styleTitle: titleStyle(),
      description: MultiLanguages.of(context)!.translate("intro3Text"),
      styleDescription: const TextStyle(
          color: ApiConstants.mainFontColor,
          fontSize: ApiConstants.languageAndAboutFontSize),
      pathImage: "assets/intro/intro3.png",
      backgroundColor: ApiConstants.mainBackgroundColor,
    ));
    listSlides.add(ContentConfig(
      title: MultiLanguages.of(context)!.translate("intro4Title"),
      styleTitle: titleStyle(),
      description: MultiLanguages.of(context)!.translate("intro4Text"),
      styleDescription: const TextStyle(
          color: ApiConstants.mainFontColor,
          fontSize: ApiConstants.languageAndAboutFontSize),
      pathImage: "assets/intro/intro4.png",
      backgroundColor: ApiConstants.mainBackgroundColor,
    ));
  }
}
