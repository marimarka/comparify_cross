import 'dart:io';

import 'package:comparify_cross/pages/helpers/ad_helper.dart';
import 'package:comparify_cross/pages/helpers/bottom.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/home.dart';
import 'package:comparify_cross/pages/scan_barcode_page.dart';
import 'package:comparify_cross/pages/store_link_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_us_page.dart';
import 'helpers/multi_languages.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesPage> {
  InterstitialAd? _interstitialAd;
  InterstitialAd? _interstitialAdAndOpenStorePage;

  int _selectedTab = 3;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _loadInterstitialAdAndOpenStorePage();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAdAndOpenStorePage?.dispose();
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
      if (_interstitialAdAndOpenStorePage != null) {
        _interstitialAdAndOpenStorePage?.show();
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StoreLinkPage()));
      }
    } else if (index == 3) {
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

  void _loadInterstitialAdAndOpenStorePage() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StoreLinkPage()));
            },
          );

          setState(() {
            _interstitialAdAndOpenStorePage = ad;
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
    dynamic url;

    final tiktokLogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/tiktok.png")),
        ));


    if (Platform.isAndroid || Platform.isIOS) {
      final appId =
          Platform.isAndroid ? 'com.emmea.comparify' : 'YOUR_IOS_APP_ID';
      url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
    }

    const contactUsTextSection = Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Contact Us',
                style:
                    TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
              ))),
    );

    const fbTextSection = Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Like us on Facebook',
                style:
                    TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
              ))),
    );
    const instaTextSection = Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Follow us on Instagram',
                style:
                    TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
              ))),
    );
    const tiktokTextSection = Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'TikTok: Comparify_lv',
                style:
                    TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
              ))),
    );
    return Scaffold(
        appBar: AppBar(
            title: Text(MultiLanguages.of(context)!.translate("comparify"),
                style: const TextStyle(color: ApiConstants.appBarFontColor)),
            backgroundColor: ApiConstants.buttonsAndMenuColor,
            automaticallyImplyLeading: ApiConstants.showTopBar),
        body: Builder(builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              child: ListView(children: <Widget>[
                Column(
                  children: <Widget>[
                    const Image(
                      image: AssetImage("assets/logo.png"),
                      height: 150,
                    ),
                    const SizedBox(
                        height: 80,
                        child: Text(
                            "    We ar developer family which realized some day that we need to compare prices. "
                            "So started implement such application. Hope it helps you to save money.",
                            style: TextStyle(
                                height: 1.5,
                                fontSize: 16,
                                color: ApiConstants.mainFontColor))),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                        height: 95,
                        child: Text(
                            "    Мы семья разработчиков, которая однажды поняла, что нам нужно сравнивать цены. "
                            "Поэтому мы начали реализовывать такое приложение. Надеюсь, она поможет вам сэкономить деньги.",
                            style: TextStyle(
                                height: 1.5,
                                fontSize: 16,
                                color: ApiConstants.mainFontColor))),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 95,
                      child: Text(
                          "    Mēs esam izstrādātāju ģimene, kas kādu dienu saprata, ka mums ir jāsalīdzina cenas. "
                          "Tāpēc sākam izstrādāt šādu aplikāciju. Cerams, ka tā palīdzēs jums ietaupīt naudu.",
                          style: TextStyle(
                              height: 1.5,
                              fontSize: 16,
                              color: ApiConstants.mainFontColor)),
                    ),
                  const Divider(
                      color: Colors.grey,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                        onTap: () => _loadFB(),
                        child: Row(
                            children: <Widget>[fbTextSection])),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                        onTap: () => launchUrl(Uri.parse(
                            'https://www.instagram.com/_u/comparify.lv')),
                        child: Row(children: <Widget>[
                          instaTextSection
                        ])),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                        onTap: () => launchUrl(
                            Uri.parse('https://www.tiktok.com/@comparify_lv')),
                        child: Row(children: <Widget>[
                          tiktokLogoSection,
                          tiktokTextSection
                        ]))
                  ],
                )
              ]));
        }),
        bottomNavigationBar: BottomMenu(
          selectedTab: _selectedTab,
          // onClicked: onClicked,
          changeTab: (int value) {
            _changeTab(value);
          },
        ));
  }

  void _loadFB() async {
    String fbProtocolUrl;
    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/comparify.lv';
    } else {
      fbProtocolUrl = 'fb://page/comparify.lv';
    }

    String fallbackUrl = 'https://www.facebook.com/comparify.lv';

    try {
      bool launched = await launch(fbProtocolUrl, forceWebView: false);

      if (!launched) {
        await launch(fallbackUrl, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl);
    }
  }
}
