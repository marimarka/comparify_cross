import 'package:comparify_cross/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intro_slider/slide_object.dart';

class Intro extends StatefulWidget {
  static String id = 'Intro';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IntroState();
  }
}

class IntroState extends State<Intro> {
  List<Slide> listSlides = [];

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      return Home.id;
    } else {
      // Set the flag to true at the end of onboarding screen if everything is successfull and so I am commenting it out
      await prefs.setBool('seen', false);
      return Intro.id;
    }
  }

  // Future checkFirstSeen() async {
  //   bool _seen = (prefs.getBool('seen') ?? false);
  //   print('seen: ' + _seen.toString());
  //
  //   if (_seen) {
  //     Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(builder: (context) => new Home()));
  //   } else {
  //     await prefs.setBool('seen', false);
  //     Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(builder: (context) => new Intro()));
  //   }
  // }

  // @override
  // void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkFirstSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // return MaterialApp(
            //   initialRoute: snapshot.data,
            //   routes: {
            //     Intro.id: (context) => Intro(),
            //     Home.id: (context) => Home(),
            //   },
            // );
            return IntroSlider(
              slides: listSlides,
              onSkipPress: onSkipPress,
              onDonePress: onPressedDone,
            );
          }
        });
    // }
    // TODO: implement build
    // return IntroSlider(
    //   slides: listSlides,
    //   onSkipPress: onSkipPress,
    //   onDonePress: onPressedDone,
    // );
  }

  @override
  void initState() {
    super.initState();
    listSlides.add(Slide(
      title: "Esam priecīgi redzēt Tevi!",
      description:
          "Mēs esam izstrādātāju ģimene, kas kādu dienu saprata, ka mums ir jāsalīdzina cenas. "
          "Tāpēc sākam izstrādāt šādu aplikāciju.\n \n Ticam, ka tā palīdzēs jums ietaupīt naudu.",
      pathImage: "assets/intro/intro1.png",
      backgroundColor: const Color(0xFF0c46DD),
    ));
    listSlides.add(Slide(
      title: "Preču katalogs",
      description:
          "Preces ir sadalītas kategorijās. Nospiežot uz vajadzīgo kategoriju, redzēsi produktus. "
          "Skrollē zemāk un ielādāsies vairāk. Mums ir vairāk nekā 1000 preču cenas, ko vari salīdzināt trijos veikalos.\n "
          "Vari izmantot meklēšanu, lai ātrāk atrastu sev vajadzīgo preci.\n\n"
          " Kad redzi sev piemērotāku cenu, nospiež uz veikalu un pievieno grozā šo preci. "
          "Atgriezies Comparify, lai turpinātu pildīt grozu ar precēm pēc visizdevīgākām cenām.\n\n"
          "Ilgi spiežot uz * pie veikala, uzzināsi iespējamo cenas atšķirību ar veikalu.",
      pathImage: "assets/intro/intro2.png",
      backgroundColor: const Color(0xFF0c46DD),
    ));
    listSlides.add(Slide(
      title: "Skeneris",
      description:
          "Ja gribi atrast cenu konkrētai precei, ko turi rokās, noskenē barkodu, "
          "un redzēsi cenas, ko vari salīdzināt trijos veikalos. \n Mums ir ap 500 preces ar barkodu.",
      pathImage: "assets/intro/intro3.png",
      backgroundColor: Color(0xFF0c46DD),
    ));
    listSlides.add(Slide(
      title: "Veikali",
      description:
          "Kad esi piepildījis grozus ar precēm pēc izdevīgākām cenām, "
          "vari ieiet veikalā, lai noformētu pirkumu. Ceram uz tavu atgriešanu mūsu Comparify aplikācijā.\n\n"
          "#Taupamkopaa",
      pathImage: "assets/intro/intro4.png",
      backgroundColor: Color(0xFF0c46DD),
    ));
  }

  onPressedDone() {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new Home()));
    setState(() {
      // SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
      // prefs.setBool('seen', true);
    });
  }

  onSkipPress() {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new Home()));
    setState(() {
      // SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
      // prefs.setBool('seen', true);
    });
  }
}
