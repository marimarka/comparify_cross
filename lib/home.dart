import 'package:comparify_cross/about_us_page.dart';
import 'package:comparify_cross/ad_helper.dart';
import 'package:comparify_cross/bar_code_scanner.dart';
import 'package:comparify_cross/categories.dart';
import 'package:comparify_cross/scan_barcode_page.dart';
import 'package:comparify_cross/search_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State {
  int _selectedTab = 0;
  InterstitialAd? _interstitialAd;

  final List _pages = [
    const Categories(),
    const ScanBarCodePage(),
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ScanBarCodePage()));
      // }
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutUsPage()));
    }

    // setState(() {
    //   _selectedTab = index;
    // });
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pop(this.context);
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        // shadowColor: const Color(0xFF0C46DD),
        actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              icon: const ImageIcon(
                AssetImage("assets/search.png"),
                color: Colors.black45,
                size: 18,
              ))
        ],
        centerTitle: true,
      ),
      body: _pages[_selectedTab],
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
                AssetImage("assets/comparify.png"),
                // color: Colors.grey,
                size: 18,
              ),
              label: "Comparify"),
        ],
      ),
    );
  }
}
