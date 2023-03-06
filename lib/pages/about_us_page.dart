import 'dart:io';

import 'package:comparify/pages/choose_language_page.dart';
import 'package:comparify/pages/favorites_page.dart';
import 'package:comparify/pages/helpers/ad_helper.dart';
import 'package:comparify/pages/helpers/bottom.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/home.dart';
import 'package:comparify/pages/intro.dart';
import 'package:comparify/pages/scan_barcode_page.dart';
import 'package:comparify/pages/store_link_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helpers/multi_languages.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUsPage> {
  InterstitialAd? _interstitialAd;
  InterstitialAd? _interstitialAdAndOpenStorePage;

  final int _selectedTab = 4;

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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StoreLinkPage()));
      }
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FavoritesPage()));
    } else if (index == 4) {}
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StoreLinkPage()));
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

    final languagelogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/logo_lang.png")),
        ));
    final infologoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/logo_info.png")),
        ));
    final playStorelogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/logo_rate.png")),
        ));
    final sharelogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/logo_share.png")),
        ));
    final contactUsLogoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
              fit: BoxFit.contain, child: Image.asset("assets/logo_contact.png")),
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

    Widget playStoreTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("rateUs"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor, fontSize: ApiConstants.languageAndAboutFontSize),
              ))),
    );
    Widget languageTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("chooseLanguage"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor, fontSize: ApiConstants.languageAndAboutFontSize),
              ))),
    );
    Widget infoTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("howToUse"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor, fontSize: ApiConstants.languageAndAboutFontSize),
              ))),
    );
    Widget shareTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("shareApp"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor, fontSize: ApiConstants.languageAndAboutFontSize),
              ))),
    );
    if (Platform.isAndroid || Platform.isIOS) {
      final appId =
          Platform.isAndroid ? 'com.emmea.comparify' : '1665844023';
      url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
    }

    Widget contactUsTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("contactUs"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor, fontSize: ApiConstants.languageAndAboutFontSize),
              ))),
    );

    Widget fbTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate('likeUsOnFacebook'),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor, fontSize: ApiConstants.languageAndAboutFontSize),
              ))),
    );
    Widget instaTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("followUsOnInstagram"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor, fontSize: ApiConstants.languageAndAboutFontSize),
              ))),
    );
    Widget tiktokTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("tiktok"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor, fontSize: ApiConstants.languageAndAboutFontSize),
              ))),
    );
    return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: Text(MultiLanguages.of(context)!.translate("comparify"),
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
                Column(
                  children: <Widget>[
                    const Padding(
                        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: Image(
                          image: AssetImage("assets/new_long_logo.png"),
                          height: 30,
                        )),
                    SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                                MultiLanguages.of(context)!
                                    .translate("aboutTeam"),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    height: 1.1,
                                    fontSize: ApiConstants.productCardFontSize,
                                    color: ApiConstants.mainFontColor)))),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(children: <Widget>[
                          languagelogoSection,
                          languageTextSection,
                          InkWell(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ChooseLanguagePage())),
                              child: const ImageIcon(
                                  AssetImage("assets/go_futher.png")))
                        ])),
                    const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.grey,
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(children: <Widget>[
                          sharelogoSection,
                          shareTextSection,
                          InkWell(
                              onTap: () => Share.share(
                                  MultiLanguages.of(context)!
                                      .translate("shareLinkAndroid")),
                              child: const ImageIcon(
                                  AssetImage("assets/go_futher.png")))
                        ])),
                    const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.grey,
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(children: <Widget>[
                          infologoSection,
                          infoTextSection,
                          InkWell(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Intro())),
                              child: const ImageIcon(
                                  AssetImage("assets/go_futher.png")))
                        ])),
                    const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.grey,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(children: <Widget>[
                        playStorelogoSection,
                        playStoreTextSection,
                        InkWell(
                            onTap: () => launchUrl(url),
                            child: const ImageIcon(
                                AssetImage("assets/go_futher.png")))
                      ]),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.grey,
                        )),
                    const SizedBox(height: 2),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(children: <Widget>[
                          contactUsLogoSection,
                          contactUsTextSection,
                          InkWell(
                              onTap: () => _sendEmail(),
                              child: const ImageIcon(
                                  AssetImage("assets/go_futher.png")))
                        ])),
                    const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.grey,
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(children: <Widget>[
                          fbLogoSection,
                          fbTextSection,
                          InkWell(
                              onTap: () => _loadFB(),
                              child: const ImageIcon(
                                  AssetImage("assets/go_futher.png")))
                        ])),
                    const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.grey,
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(children: <Widget>[
                          instaLogoSection,
                          instaTextSection,
                          InkWell(
                              onTap: () => launchUrl(Uri.parse(
                                  'https://www.instagram.com/_u/comparify.lv')),
                              child: const ImageIcon(
                                  AssetImage("assets/go_futher.png")))
                        ])),
                    const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.grey,
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(children: <Widget>[
                          tiktokLogoSection,
                          tiktokTextSection,
                          InkWell(
                              onTap: () => launchUrl(Uri.parse(
                                  'https://www.tiktok.com/@comparify_lv')),
                              child: const ImageIcon(
                                  AssetImage("assets/go_futher.png")))
                        ])),
                    const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.grey,
                        )),
                    // const SizedBox(height: 2),
                  ],
                )
              ]));
        }),
        bottomNavigationBar: BottomMenu(
          selectedTab: _selectedTab,
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

  void _sendEmail() async {
    if (Platform.isIOS) {
      final url = Uri(
        scheme: 'mailto',
        path: 'marina.paberzze@gmail.com',
        query: 'subject=Comparify user email',
      );
      if (await canLaunchUrl(url)) {
        launchUrl(url);
      } else {
        print(MultiLanguages.of(context)!.translate("cantLaunch") +
            url.toString());
      }
    } else {
      launchUrl(Uri.parse("mailto:marina.paberzze@gmail.com"));
    }
  }
}
