import 'package:comparify/pages/about_us_page.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/helpers/multi_languages.dart';
import 'package:comparify/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class Intro extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return IntroState();
  }
}

class IntroState extends State<Intro> {
  List<ContentConfig> listSlides = [];

  Color activeColor = Colors.white;
  Color inactiveColor = const Color(0xff0c46dd);

  Color indicatorActiveColor = const Color(0xff0c46dd);
  Color indicatorInactiveColor = const Color(0xFFCFE6FF);

  double sizeIndicator = 10;

  @override
  Widget build(BuildContext context) {
    createIntros();
    return Container(
      child: IntroSlider(
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
        )
    );
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
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => new AboutUsPage()));
  }

  onSkipPress() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => new AboutUsPage()));
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
