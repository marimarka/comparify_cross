import 'package:comparify_cross/pages/about_us_page.dart';
import 'package:comparify_cross/pages/categories.dart';
import 'package:comparify_cross/pages/helpers/ad_helper.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/scan_barcode_page.dart';
import 'package:comparify_cross/pages/search_page.dart';
import 'package:comparify_cross/pages/store_link_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  static String id = 'Home';

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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
            width: 130,
            height: 27,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFF0C46DD)),
            child: const Center(
              child: Text(
                "Comparify",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, backgroundColor: Color(0xFF0C46DD),
                fontSize: 16),
                )
            )
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              icon: const ImageIcon(
                AssetImage("assets/search.png"),
                color: ApiConstants.mainFontColor,
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
      ),
    );
  }
}
