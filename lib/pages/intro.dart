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

      // print("1");
      // return Home.id;
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Intro()));

      // print("2");
      // // Set the flag to true at the end of onboarding screen if everything is successfull and so I am commenting it out
      // await prefs.setBool('seen', true);
      // return Intro.id;
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
                  CircularProgressIndicator(color: ApiConstants.mainFontColor),
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
      title: "Esam priec??gi redz??t Tevi!",
      styleTitle: titleStyle(),
      description:
          "M??s esam izstr??d??t??ju ??imene, kas k??du dienu saprata, ka mums ir j??sal??dzina cenas. "
          "T??p??c s??kam izstr??d??t ????du aplik??ciju.\n \n Ticam, ka t?? pal??dz??s jums ietaup??t naudu.",
      styleDescription:
          TextStyle(color: ApiConstants.mainFontColor, fontSize: 22),
      pathImage: "assets/intro/intro1.png",
      backgroundColor: Colors.white,
    ));
    listSlides.add(ContentConfig(
      title: "Pre??u katalogs",
      styleTitle: titleStyle(),
      description:
          "Preces ir sadal??tas kategorij??s. Nospie??ot uz vajadz??go kategoriju, redz??si produktus. "
          "Skroll?? zem??k un iel??d??sies vair??k. Mums ir vair??k nek?? 1000 pre??u cenas, ko vari sal??dzin??t trijos veikalos.\n "
          "Vari izmantot mekl????anu, lai ??tr??k atrastu sev vajadz??go preci.\n\n"
          " Kad redzi sev piem??rot??ku cenu, nospie?? uz veikalu un pievieno groz?? ??o preci. "
          " Veikal?? ielogojies, lai tavs grozs b??tu gatavs pirkuma noform????anai. \n\n"
          "Atgriezies Comparify, lai turpin??tu pild??t grozu ar prec??m p??c visizdev??g??k??m cen??m.\n\n"
          "Ilgi spie??ot uz * pie veikala, uzzin??si iesp??jamo cenas at????ir??bu ar veikalu.",
      styleDescription:
          TextStyle(color: ApiConstants.mainFontColor, fontSize: 22),
      pathImage: "assets/intro/intro2.png",
      backgroundColor: Colors.white,
    ));
    listSlides.add(ContentConfig(
      title: "Skeneris",
      styleTitle: titleStyle(),
      description:
          "Ja gribi atrast cenu konkr??tai precei, ko turi rok??s, nosken?? barkodu, "
          "un redz??si cenas, ko vari sal??dzin??t trijos veikalos. \n Mums ir ap 500 preces ar barkodu.",
      styleDescription:
          TextStyle(color: ApiConstants.mainFontColor, fontSize: 22),
      pathImage: "assets/intro/intro3.png",
      backgroundColor: Colors.white,
    ));
    listSlides.add(ContentConfig(
      title: "Veikali",
      styleTitle: titleStyle(),
      description:
          "Kad esi piepild??jis grozus ar prec??m p??c izdev??g??k??m cen??m, "
          "vari ieiet veikal??, lai noform??tu pirkumu. Ceram uz tavu atgrie??anu m??su Comparify aplik??cij??.\n\n"
          "#Taupamkopaa",
      styleDescription:
          TextStyle(color: ApiConstants.mainFontColor, fontSize: 22),
      pathImage: "assets/intro/intro4.png",
      backgroundColor: Colors.white,
    ));
  }

  TextStyle titleStyle() => TextStyle(
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
