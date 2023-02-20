import 'package:comparify_cross/pages/about_us_page.dart';
import 'package:comparify_cross/pages/favorites_page.dart';
import 'package:comparify_cross/pages/helpers/ad_helper.dart';
import 'package:comparify_cross/pages/helpers/bottom.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/helpers/multi_languages.dart';
import 'package:comparify_cross/pages/home.dart';
import 'package:comparify_cross/pages/scan_barcode_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreLinkPage extends StatefulWidget {
  const StoreLinkPage({Key? key}) : super(key: key);

  @override
  StoreLinkState createState() => StoreLinkState();
}

class StoreLinkState extends State<StoreLinkPage> {
  InterstitialAd? _interstitialAd;

  final int _selectedTab = 2;

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
          context, MaterialPageRoute(builder: (context) => FavoritesPage()));
    } else if (index == 4) {
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
    return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: Text(MultiLanguages.of(context)!.translate("stores"),
                style: const TextStyle(
                    color: ApiConstants.appBarFontColor,
                    fontFamily: "Roboto",
                    fontSize: ApiConstants.titleFontSize,
                    fontWeight: FontWeight.w700)),
            backgroundColor: ApiConstants.buttonsAndMenuColor,
            automaticallyImplyLeading: ApiConstants.showTopBar),
        body: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            child: ListView(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(20), //
                  child: Text(
                      MultiLanguages.of(context)!.translate("createOrder"),
                      style: const TextStyle(
                          fontSize: ApiConstants.titleFontSize,
                          color: ApiConstants.mainFontColor))),
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
                                      color: ApiConstants.mainFontColor,
                                      fontSize: 20)))))),
              const SizedBox(height: 2),
              InkWell(
                  onTap: () => launchUrl(
                      Uri.parse("https://www.rimi.lv/e-veikals/lv/checkout"),
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
                            child: Image.asset("assets/store_rimi_logo.png"),
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
                                    color: ApiConstants.mainFontColor,
                                    fontSize: 20))))),
              ),
            ]),
          );
        }),
        bottomNavigationBar: BottomMenu(
          selectedTab: _selectedTab,
          changeTab: (int value) {
            _changeTab(value);
          },
        ));
  }
}
