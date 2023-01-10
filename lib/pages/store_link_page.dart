import 'package:comparify_cross/pages/about_us_page.dart';
import 'package:comparify_cross/pages/helpers/ad_helper.dart';
import 'package:comparify_cross/pages/home.dart';
import 'package:comparify_cross/pages/scan_barcode_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreLinkPage extends StatefulWidget {
  StoreLinkPage({Key? key}) : super(key: key);

  @override
  _StoreLinkState createState() => _StoreLinkState();
}

class _StoreLinkState extends State<StoreLinkPage> {
  InterstitialAd? _interstitialAd;

  int _selectedTab = 2;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  _changeTab(int index) {
    if (index == 0) {
      if (_interstitialAd != null) {
        _interstitialAd?.show();
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    } else if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ScanBarCodePage()));
    } else if (index == 2) {
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutUsPage()));
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // const bVTextSection = Expanded(
    //   child: Text(
    //       'B veikalā',
    //       style: TextStyle(color: Color(0xFF0C46DD), fontSize: 20)
    //   // Padding(
    //   //     padding: EdgeInsets.only(top: 8),
    //   //     child: Padding(
    //   //         padding: EdgeInsets.only(bottom: 10, left: 10),
    //   //         child: Text(
    //   //           'B veikalā',
    //   //           style: TextStyle(color: const Color(0xFF0C46DD), fontSize: 20),
    //   //         ))),
    // ));
    // final rVTextSection = Expanded(
    //   child: //Padding(
    //       // padding: EdgeInsets.only(top: 8,bottom: 10, left: 10),
    //       // child:
    //       Image.asset("assets/store_rimi_logo.png")
    //       // Padding(
    //       //     padding: EdgeInsets.only(),
    //       //     child: Text(
    //       //       'R veikalā',
    //       //       style: TextStyle(color: const Color(0xFF0C46DD), fontSize: 20),
    //       //     ))
    //
    // );
    // const pVTextSection = Expanded(
    //   child: Padding(
    //       padding: EdgeInsets.only(top: 8),
    //       child: Padding(
    //           padding: EdgeInsets.only(bottom: 10, left: 10),
    //           child: Text(
    //             'P veikalā',
    //             style: TextStyle(color: const Color(0xFF0C46DD), fontSize: 20),
    //           ))),
    // );
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "Comparify",
              style: TextStyle(color: const Color(0xFF0C46DD)),
            ),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false),
            // leading: const BackButton(color: Color(0xFF0C46DD))),
        body: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                      height: 40,
                      child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("Noformē pirkumus: ",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: const Color(0xFF0C46FF))))),
                  InkWell(
                      onTap: () => launchUrl(
                          Uri.parse("https://www.barbora.lv/grozs"),
                          mode: LaunchMode.externalApplication),
                      child: Container(
                          height: 100,
                          width: double.infinity,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Text('Barbora veikalā',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF0C46DD),
                                          fontSize: 20)))))),
                  const SizedBox(height: 2),
                  InkWell(
                      onTap: () => launchUrl(
                          Uri.parse(
                              "https://www.rimi.lv/e-veikals/lv/checkout"),
                          mode: LaunchMode.externalApplication),
                      child: Container(
                          height: 150,
                          width: double.infinity,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child:
                                    Image.asset("assets/store_rimi_logo.png"),
                              )))),
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: () => launchUrl(
                        Uri.parse(
                            "https://pienaveikals.lv/index.php?route=checkout/cart"),
                        mode: LaunchMode.externalApplication),
                    child: Container(
                        height: 100,
                        width: double.infinity,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text('PienaVeikals veikalā',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xFF0C46DD),
                                        fontSize: 20))))),
                  ),
                  //Row(children: <Widget>[pVTextSection])),
                ]),
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          backgroundColor: Colors.white,
          onTap: (index) => _changeTab(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0C46DD),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/catalogs.png"),
                  // color: Colors.grey,
                  size: 18,
                ),
                label: "Katalogs"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/scanner.png"),
                  // color: Colors.grey,
                  size: 18,
                ),
                label: "Skeneris"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/store.png"),
                  // color: Colors.grey,
                  size: 18,
                ),
                label: "Veikali"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/comparify.png"),
                  // color: Colors.grey,
                  size: 18,
                ),
                label: "Comparify"),
          ],
        ));
  }
}
