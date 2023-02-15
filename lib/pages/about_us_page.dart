import 'dart:io';

import 'package:comparify_cross/pages/favorites_page.dart';
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const StoreLinkPage()));
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const StoreLinkPage()));
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
              fit: BoxFit.contain, child: Image.asset("assets/comparify.png")),
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

    Widget playStoreTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("rateUs"),
                style: const TextStyle(
                    color: ApiConstants.mainFontColor, fontSize: 20),
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
                    color: ApiConstants.mainFontColor, fontSize: 20),
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

    Widget contactUsTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("contactUs"),
                style:
                    const TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
              ))),
    );

    Widget fbTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate('likeUsOnFacebook'),
                style:
                    const TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
              ))),
    );
    Widget instaTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("followUsOnInstagram"),
                style:
                    const TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
              ))),
    );
    Widget tiktokTextSection = Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                MultiLanguages.of(context)!.translate("tiktok"),
                style:
                    const TextStyle(color: ApiConstants.mainFontColor, fontSize: 20),
              ))),
    );
    return Scaffold(
        appBar: AppBar(
            title: Text(MultiLanguages.of(context)!.translate("comparify"),
                style: const TextStyle(color: ApiConstants.appBarFontColor)),
            backgroundColor: ApiConstants.buttonsAndMenuColor,
            automaticallyImplyLeading: ApiConstants.showTopBar),

            // title: Container(
            //     width: 25,
            //     height: 10,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(4),
            //         color: ApiConstants.mainBackgroundColor),
            //     child: Text(
            //       MultiLanguages.of(context)!.translate("comparify"),
            //       style: const TextStyle(
            //           // color: ApiConstants.mainFontColor,
            //           backgroundColor: ApiConstants.buttonsAndMenuColor),
            //     )),
            // automaticallyImplyLeading: ApiConstants.showTopBar,
            // backgroundColor: ApiConstants.buttonsAndMenuColor
        // ),
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
                    SizedBox(
                        height: 80,
                        child: Text(
                            MultiLanguages.of(context)!.translate("aboutTeam"),
                            style: const TextStyle(
                                height: 1.5,
                                fontSize: 16,
                                color: ApiConstants.mainFontColor))),
                    const Divider(
                      color: Colors.grey,
                    ),
                    InkWell(
                        onTap: () => Share.share(MultiLanguages.of(context)!
                            .translate("shareLinkAndroid")),
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
                        onTap: () => _sendEmail(),
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
            url!.toString());
      }
    } else {
      launchUrl(Uri.parse("mailto:marina.paberzze@gmail.com"));
    }
  }
}
