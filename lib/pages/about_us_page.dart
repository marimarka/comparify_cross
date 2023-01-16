import 'dart:io';

import 'package:comparify_cross/pages/helpers/ad_helper.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/home.dart';
import 'package:comparify_cross/pages/scan_barcode_page.dart';
import 'package:comparify_cross/pages/store_link_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUsPage> {
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
    } else if (index == 3) {}
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

    final playStorelogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset("assets/comparify.png")),
        ));
    final sharelogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/share.png")),
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
                'Rate Comparify',
                style:
                    TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
              ))),
    );
    const shareTextSection = Expanded(
      child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Share app',
                style:
                    TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
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
        // appBar: AppBar(
        //     title: Container(
        //         width: 25,
        //         height: 10,
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(4),
        //             color: const Color(0xFF0C46DD)),
        //         child: const Text(
        //           "Comparify",
        //           style: TextStyle(
        //               color: Colors.white, backgroundColor: Color(0xFF0C46DD)),
        //         )),
        //     automaticallyImplyLeading: false,
        //     backgroundColor: Colors.white),
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
                    InkWell(
                        onTap: () => Share.share(
                            'Download Comparify on https://play.google.com/store/apps/details?id=com.emmea.comparify'),
                        child: Row(children: <Widget>[
                          sharelogoSection,
                          shareTextSection
                        ])),
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
                        onTap: () => _sendEmail() ,
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
                  ],
                )
              ]));
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
                  size: 18,
                ),
                label: "Preces"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/scanner.png"),
                  size: 18,
                ),
                label: "Skeneris"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/store.png"),
                  size: 18,
                ),
                label: "Veikali"),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage("assets/comparify.png"),
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

  void _sendEmail() async {
    String emailUrl;

    final url = Uri(
      scheme: 'mailto',
      path: 'marina.paberzze@gmail.com',
      query: 'subject=Comparify user email',
    );
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      print("Can't launch $url");
    }
    // if (Platform.isIOS) {
    //   emailUrl = "message://marina.paberzze@gmail.com";
    // } else {
    //   emailUrl = "mailto:marina.paberzze@gmail.com";
    // }

    // try {
    //   bool launched = await launch(emailUrl, forceWebView: false);
    //
    //   if (!launched) {
    //     await launch(emailUrl, forceWebView: false);
    //   }
    // } catch (e) {
    //   await launch(emailUrl);
    // }
  }
}
