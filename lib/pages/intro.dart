import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatefulWidget {
  static String id = 'Intro';

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
          new MaterialPageRoute(builder: (context) => new Intro()));
    }
  }

  Future setSeenCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkFirstSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(color: ApiConstants.buttonsAndMenuColor),
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
    listSlides.add(ContentConfig(
      title: "Esam priecīgi redzēt Tevi!",
      styleTitle: titleStyle(),
      description:
          "Mēs esam izstrādātāju ģimene, kas kādu dienu saprata, ka mums ir jāsalīdzina cenas. Tāpēc sākam izstrādāt šādu aplikāciju.\n \n Ticam, ka tā palīdzēs jums ietaupīt naudu.",
      styleDescription:
          TextStyle(color: ApiConstants.mainFontColor, fontSize: 22),
      pathImage: "assets/intro/intro1.png",
      backgroundColor: Colors.white,
    ));
    listSlides.add(ContentConfig(
      title: "Preču katalogs",
      styleTitle: titleStyle(),
      description:
          "Preces ir sadalītas kategorijās. Nospiežot uz vajadzīgo kategoriju, redzēsi produktus. Skrollē zemāk un ielādāsies vairāk. Mums ir vairāk nekā 1000 preču cenas, ko vari salīdzināt trijos veikalos.\n Vari izmantot meklēšanu, lai ātrāk atrastu sev vajadzīgo preci.\n\n Kad redzi sev piemērotāku cenu, nospiež uz veikalu un pievieno grozā šo preci. Veikalā ielogojies, lai tavs grozs būtu gatavs pirkuma noformēšanai. \n\n Atgriezies Comparify, lai turpinātu pildīt grozu ar precēm pēc visizdevīgākām cenām.\n\n Ilgi spiežot uz * pie veikala, uzzināsi iespējamo cenas atšķirību ar veikalu.",
      styleDescription:
          TextStyle(color: ApiConstants.mainFontColor, fontSize: 22),
      pathImage: "assets/intro/intro2.png",
      backgroundColor: Colors.white,
    ));
    listSlides.add(ContentConfig(
      title: "Skeneris",
      styleTitle: titleStyle(),
      description:
          "Ja gribi atrast cenu konkrētai precei, ko turi rokās, noskenē barkodu, un redzēsi cenas, ko vari salīdzināt trijos veikalos. \n Mums ir ap 500 preces ar barkodu.",
      styleDescription:
          TextStyle(color: ApiConstants.mainFontColor, fontSize: 22),
      pathImage: "assets/intro/intro3.png",
      backgroundColor: Colors.white,
    ));
    listSlides.add(ContentConfig(
      title: "Veikali",
      styleTitle: titleStyle(),
      description:
          "Kad esi piepildījis grozus ar precēm pēc izdevīgākām cenām, vari ieiet veikalā, lai noformētu pirkumu. Ceram uz tavu atgriešanu mūsu Comparify aplikācijā.\n\n #Taupamkopaa",
      styleDescription:
          TextStyle(color: ApiConstants.mainFontColor, fontSize: 22),
      pathImage: "assets/intro/intro4.png",
      backgroundColor: Colors.white,
    ));
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
}
