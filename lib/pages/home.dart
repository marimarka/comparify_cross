import 'package:comparify_cross/pages/about_us_page.dart';
import 'package:comparify_cross/pages/categories.dart';
import 'package:comparify_cross/pages/choose_language_page.dart';
import 'package:comparify_cross/pages/favorites_page.dart';
import 'package:comparify_cross/pages/helpers/ad_helper.dart';
import 'package:comparify_cross/pages/helpers/bottom.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/scan_barcode_page.dart';
import 'package:comparify_cross/pages/search_page.dart';
import 'package:comparify_cross/pages/store_link_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'helpers/multi_languages.dart';

class Home extends StatefulWidget {
  static String id = 'Home';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State {
  final int _selectedTab = 0;
  InterstitialAd? _interstitialAd;

  final List _pages = [
    const Categories(),
    const ScanBarCodePage(),
    StoreLinkPage(),
    FavoritesPage(),
    AboutUsPage(),
  ];

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
    } else if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ScanBarCodePage()));
    } else if (index == 2) {
      if (_interstitialAd != null) {
        _interstitialAd!.show();
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StoreLinkPage()));
      }
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
                  MaterialPageRoute(builder: (context) => StoreLinkPage()));
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
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset("assets/new_logo.png", width: 26, height: 24),
              Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                      MultiLanguages.of(context)!.translate("comparify"),
                      style: const TextStyle(
                          color: ApiConstants.nameFontColor,
                          fontWeight: FontWeight.bold))),
            ],
          ),
          backgroundColor: ApiConstants.mainBackgroundColor,
          automaticallyImplyLeading: ApiConstants.showTopBar,
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchPage())),
                icon: const ImageIcon(
                  AssetImage("assets/search.png"),
                  color: ApiConstants.mainFontColor,
                  size: 18,
                )),
            Theme(
                data: Theme.of(context).copyWith(
                    textTheme: TextTheme().apply(bodyColor: ApiConstants.mainFontColor),
                    dividerColor: ApiConstants.mainFontColor,
                    iconTheme: IconThemeData(color: ApiConstants.mainFontColor)),
                child: PopupMenuButton<int>(
                  color: ApiConstants.mainBackgroundColor,
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                        value: 0,
                        child: Text(MultiLanguages.of(context)!
                            .translate("chooseLanguage"),
                        style: TextStyle(color: ApiConstants.mainFontColor),)),
                  ],
                  onSelected: (item) => selectedItem(context, item),
                ))
          ],
        ),
        body: _pages[_selectedTab],
        bottomNavigationBar: BottomMenu(
          selectedTab: _selectedTab,
          changeTab: (int value) {
            _changeTab(value);
          },
        ));
  }

  void selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChooseLanguagePage()));
        break;
      // case 1:
      //   print("Privacy Clicked");
      //   break;
      // case 2:
      //   print("User Logged out");
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => LoginPage()),
      //           (route) => false);
      //   break;
    }
  }
}
