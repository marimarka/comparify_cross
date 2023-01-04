import 'dart:io';

import 'package:comparify_cross/ad_helper.dart';
import 'package:comparify_cross/home.dart';
import 'package:comparify_cross/scan_barcode_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUsPage> {
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
      // }
    } else if (index == 2) {}
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
    dynamic url;
    final playStorelogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset("assets/logo-google-play.png")),
        ));
    final contactUsLogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/contact_us.png")),
        ));
    final fbLogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/fb.png")),
        ));
    final instaLogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/insta.png")),
        ));
    final tiktokLogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/tiktok.png")),
        ));

    const playStoreTextSection = Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Rate us',
                style: TextStyle(color: const Color(0xFF0C46DD), fontSize: 20),
              ))),
    );
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
                style: TextStyle(color: const Color(0xFF0C46DD), fontSize: 20),
              ))),
    );

    const fbTextSection = Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Like us on Facebook',
                style: TextStyle(color: const Color(0xFF0C46DD), fontSize: 20),
              ))),
    );
    const instaTextSection = Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Follow us on Instagram',
                style: TextStyle(color: const Color(0xFF0C46DD), fontSize: 20),
              ))),
    );
    const tiktokTextSection = Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'TikTok: Comparify_lv',
                style: TextStyle(color: const Color(0xFF0C46DD), fontSize: 20),
              ))),
    );
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "Comparify",
              style: TextStyle(color: const Color(0xFF0C46DD)),
            ),
            backgroundColor: Colors.white,
            leading: const BackButton(color: Color(0xFF0C46DD))),
        body: Builder(builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Image(
                    image: AssetImage("assets/logo.png"),
                    height: 150,
                  ),
                  const SizedBox(
                      height: 70,
                      child: Text(
                          "    We ar developer family which realized some day that we need to compare prices. "
                          "So started implement such application. Hope it helps you to save money.",
                          style: TextStyle(
                              height: 1.5,
                              fontSize: 14,
                              color: const Color(0xFF0C46FF)))),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                      height: 85,
                      child: Text(
                          "    Мы семья разработчиков, которая однажды поняла, что нам нужно сравнивать цены. "
                          "Поэтому мы начали реализовывать такое приложение. Надеюсь, она поможет вам сэкономить деньги.",
                          style: TextStyle(
                              height: 1.5,
                              fontSize: 14,
                              color: const Color(0xFF0C46FF)))),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 70,
                    child: Text(
                        "    Mēs esam izstrādātāju ģimene, kas kādu dienu saprata, ka mums ir jāsalīdzina cenas. "
                        "Tāpēc sākam izstrādāt šādu aplikāciju. Cerams, ka tā palīdzēs jums ietaupīt naudu.",
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 14,
                            color: const Color(0xFF0C46FF))),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  InkWell(
                      onTap: () => launchUrl(url),
                      child: Row(children: <Widget>[
                        playStorelogoSection,
                        playStoreTextSection
                      ])),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 2),
                  InkWell(
                      onTap: () => launchUrl(
                          Uri.parse("mailto:marina.paberzze@gmail.com")),
                      child: Row(children: <Widget>[
                        contactUsLogoSection,
                        contactUsTextSection
                      ])),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 2),
                  InkWell(
                      onTap: () => _loadFB(),
                      child: Row(
                          children: <Widget>[fbLogoSection, fbTextSection])),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 2),
                  InkWell(
                      onTap: () => launchUrl(Uri.parse(
                          'https://www.instagram.com/_u/comparify.lv')),
                      child: Row(children: <Widget>[
                        instaLogoSection,
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
                ]),
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          backgroundColor: Colors.white,
          onTap: (index) => _changeTab(index),
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
                  AssetImage("assets/comparify.png"),
                  // color: Colors.grey,
                  size: 18,
                ),
                label: "Comparify"),
          ],
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
