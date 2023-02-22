import 'package:comparify/models/products_dto_v3.dart';
import 'package:comparify/pages/about_us_page.dart';
import 'package:comparify/pages/favorites_page.dart';
import 'package:comparify/pages/helpers/bottom.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/helpers/product_card.dart';
import 'package:comparify/pages/home.dart';
import 'package:comparify/pages/search_page.dart';
import 'package:comparify/pages/store_link_page.dart';
import 'package:comparify/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/ad_helper.dart';
import 'helpers/multi_languages.dart';

class ScanBarCodePage extends StatefulWidget {
  const ScanBarCodePage({Key? key}) : super(key: key);

  @override
  ScanBarCodePageState createState() => ScanBarCodePageState();
}

class ScanBarCodePageState extends State {
  InterstitialAd? _interstitialAd;
  InterstitialAd? _interstitialAdAndOpenStorePage;

  final int _selectedTab = 1;

  String _scanBarcode = 'Unknown';
  bool callDone = false;
  List<ProductsDTOV3> foundProduct = [];
  List<String> favoriteList = [];

  Future<void> barcodeScan() async {
    setState(() {
      callDone = false;
    });
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    try {
      final url =
          "${ApiConstants.baseUrl}${ApiConstants.findByCodePageEndpoint}/${_scanBarcode}";
      final res = await http.get(Uri.parse("$url"));

      final List<ProductsDTOV3> fetchedPosts = ApiService().parseProducts(res.body);
      if (fetchedPosts.isNotEmpty) {
        setState(() {
          foundProduct.add(fetchedPosts[0]);
          callDone = true;
        });
      }
    } catch (err) {
      if (kDebugMode) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(MultiLanguages.of(context)!.translate("smthFailed")),
            content: Text(
                MultiLanguages.of(context)!.translate("smthFailedMessage")),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _preferences();
    _loadInterstitialAd();
    _loadInterstitialAdAndOpenStorePage();
    barcodeScan();
  }

  void _preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteList = prefs.getStringList("favorites") ?? [];
    });
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
      setState(() {
        foundProduct.clear();
      });
      barcodeScan();
    } else if (index == 2) {
      if (_interstitialAdAndOpenStorePage != null) {
        _interstitialAdAndOpenStorePage?.show();
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
            automaticallyImplyLeading: ApiConstants.showTopBar,
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchPage())),
                  icon: const ImageIcon(
                    AssetImage("assets/search.png"),
                    color: ApiConstants.mainFontColor,
                    size: 18,
                  ))
            ]),
        body: foundProduct.isEmpty && callDone
            ? const Center(
                child: CircularProgressIndicator(
                  color: ApiConstants.buttonsAndMenuColor,
                ),
              )
            : !callDone
                ? AlertDialog(
                    title: Text(MultiLanguages.of(context)!.translate("hey")),
                    content: Text(
                        MultiLanguages.of(context)!.translate("pleaseScan")),
                    // actions: <Widget>[
                    //   TextButton(
                    //     onPressed: () => Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //             builder: (_) => const SearchPage())),
                    //     child: const Text('Doties uz meklēšanu'),
                    //   ),
                    //   TextButton(
                    //     onPressed: () => barcodeScan(),
                    //     child: const Text('OK'),
                    //   ),
                    // ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: foundProduct.length,
                            // controller: _controller,
                            itemBuilder: (_, index) =>
                                ProductCard(foundProduct[index], favoriteList)),
                      ),
                    ],
                  ),
        bottomNavigationBar: BottomMenu(
          selectedTab: _selectedTab,
          changeTab: (int value) {
            _changeTab(value);
          },
        ));
  }
}
