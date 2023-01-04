// import 'dart:io';
//
// import 'package:comparify_cross/ad_helper.dart';
// import 'package:comparify_cross/home.dart';
// import 'package:comparify_cross/scan_barcode_page.dart';
// import 'package:contactus/contactus.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class AboutUsPage extends StatefulWidget {
//   const AboutUsPage({Key? key}) : super(key: key);
//
//   @override
//   _AboutUsState createState() => _AboutUsState();
// }
//
// class _AboutUsState extends State<AboutUsPage> {
//   InterstitialAd? _interstitialAd;
//
//   int _selectedTab = 2;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadInterstitialAd();
//   }
//
//   @override
//   void dispose() {
//     _interstitialAd?.dispose();
//     super.dispose();
//   }
//
//   _changeTab(int index) {
//     if (index == 0) {
//       if (_interstitialAd != null) {
//         _interstitialAd?.show();
//       } else {
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => Home()));
//       }
//     } else if (index == 1) {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => ScanBarCodePage()));
//       // }
//     } else if (index == 2) {}
//   }
//
//   void _loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: AdHelper.interstitialAdUnitId,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           ad.fullScreenContentCallback = FullScreenContentCallback(
//             onAdDismissedFullScreenContent: (ad) {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => Home()));
//             },
//           );
//
//           setState(() {
//             _interstitialAd = ad;
//           });
//         },
//         onAdFailedToLoad: (err) {
//           print('Failed to load an interstitial ad: ${err.message}');
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     dynamic url;
//     final playStorelogoSection = Padding(
//         padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
//         child: SizedBox(
//           height: 25,
//           width: 25,
//           child: FittedBox(
//               fit: BoxFit.contain,
//               child: Image.asset("assets/logo-google-play.png")),
//         ));
//     final contactUsLogoSection = Padding(
//         padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
//         child: SizedBox(
//           height: 25,
//           width: 25,
//           child: FittedBox(
//               fit: BoxFit.contain, child: Image.asset("assets/tiktok.png")),
//         ));
//
//     final playStoreTextSection = const Expanded(
//       child: Padding(
//           padding: EdgeInsets.only(top: 8),
//           child: Text(
//             'Rate us on the Play Store',
//             style: TextStyle(color: Colors.green, fontSize: 20),
//           )),
//     );
//     if (Platform.isAndroid || Platform.isIOS) {
//       final appId =
//       Platform.isAndroid ? 'com.emmea.comparify' : 'YOUR_IOS_APP_ID';
//       url = Uri.parse(
//         Platform.isAndroid
//             ? "market://details?id=$appId"
//             : "https://apps.apple.com/app/id$appId",
//       );
//     }
//
//     final contactUsTextSection = const Expanded(
//       child: Padding(
//           padding: EdgeInsets.only(top: 8),
//           child: Text(
//             '@Comparify_lv',
//             style: TextStyle(color: Colors.green, fontSize: 20),
//           )),
//     );
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Comparify"),
//         ),
//         body: Builder(builder: (BuildContext context) {
//           return Container(
//             alignment: Alignment.center,
//             color: Colors.white,
//             child: Flex(
//                 direction: Axis.vertical,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   // Image(
//                   //   image: AssetImage("assets/logo.png"),
//                   //   height: 150,
//                   // ),
//                   // SizedBox(
//                   //     height: 70,
//                   //     child: Text(
//                   //         "    We ar developer family which realized some day that we need to compare prices. "
//                   //         "So started implement such application. Hope it helps you to save money.",
//                   //         style: TextStyle(height: 1.5, fontSize: 14))),
//                   //   SizedBox(
//                   //     height: 5,
//                   //   ),
//                   //   SizedBox(
//                   //       height: 85,
//                   //       child: Text(
//                   //           "    Мы семья разработчиков, которая однажды поняла, что нам нужно сравнивать цены. "
//                   //           "Поэтому мы начали реализовывать такое приложение. Надеюсь, она поможет вам сэкономить деньги.",
//                   //           style: TextStyle(height: 1.5, fontSize: 14))),
//                   //   SizedBox(
//                   //     height: 5,
//                   //   ),
//                   //   SizedBox(
//                   //     height: 70,
//                   //     child: Text(
//                   //         "    Mēs esam izstrādātāju ģimene, kas kādu dienu saprata, ka mums ir jāsalīdzina cenas. "
//                   //         "Tāpēc sākam izstrādāt šādu aplikāciju. Cerams, ka tā palīdzēs jums ietaupīt naudu.",
//                   //         style: TextStyle(height: 1.5, fontSize: 14)),
//                   //   ),
//
//                   //   const Divider(
//                   //     color: Colors.grey,
//                   //   ),
//                   //   const SizedBox(height: 5),
//                   ContactUs(companyName: "emmea.com",
//                       textColor: Colors.black,
//                       cardColor: Colors.white,
//                       companyColor: Colors.blueAccent,
//                       taglineColor: Colors.grey,
//                       email: "marina.paberzze@gmail.com",
//                       instagram: "comparify.lv",
//                       facebookHandle: "comparify.lv"
//                       ,logo: AssetImage("assets/logo.png")),
//
//                   Divider(
//                     color: Colors.grey,
//                   ),
//                   InkWell(
//                       onTap: () => launchUrl(url),
//                       child: Row(children: <Widget>[
//                         playStorelogoSection,
//                         playStoreTextSection
//                       ])),
//                   SizedBox(height: 5),
//                   Row(children: <Widget>[
//                     InkWell(
//                         onTap: () => launchUrl(url),
//                         child: Row(children: <Widget>[
//                           contactUsLogoSection,
//                           contactUsTextSection
//                         ]))
//                   ])
//                 ]
//             ),
//           );
//         }),
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedTab,
//           onTap: (index) => _changeTab(index),
//           selectedItemColor: Colors.blueAccent,
//           unselectedItemColor: Colors.grey,
//           items: const [
//             BottomNavigationBarItem(
//                 icon: ImageIcon(
//                   AssetImage("assets/catalogs.png"),
//                   // color: Colors.grey,
//                   size: 18,
//                 ),
//                 label: "Katalogs"),
//             BottomNavigationBarItem(
//                 icon: ImageIcon(
//                   AssetImage("assets/scanner.png"),
//                   // color: Colors.grey,
//                   size: 18,
//                 ),
//                 label: "Skeneris"),
//             BottomNavigationBarItem(
//                 icon: ImageIcon(
//                   AssetImage("assets/comparify.png"),
//                   // color: Colors.grey,
//                   size: 18,
//                 ),
//                 label: "Comparify"),
//           ],
//         ));
//   }
// }
