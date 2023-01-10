import 'package:comparify_cross/models/products_dto_v2.dart';
import 'package:comparify_cross/pages/about_us_page.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/helpers/product_card.dart';
import 'package:comparify_cross/pages/home.dart';
import 'package:comparify_cross/pages/search_page.dart';
import 'package:comparify_cross/pages/store_link_page.dart';
import 'package:comparify_cross/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import 'helpers/ad_helper.dart';

class ScanBarCodePage extends StatefulWidget {
  const ScanBarCodePage({Key? key}) : super(key: key);

  @override
  _ScanBarCodePageState createState() => _ScanBarCodePageState();
}

class _ScanBarCodePageState extends State {
  InterstitialAd? _interstitialAd;

  int _selectedTab = 1;

  String _scanBarcode = 'Unknown';
  bool callDone = false;
  List<ProductsDTOV2> foundProduct = [];

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
          "${ApiConstants.baseUrl}${ApiConstants.findByCodePageEndpoint}/${_scanBarcode!}";
      final res = await http.get(Uri.parse("$url"));

      final List<ProductsDTOV2> fetchedPosts =
          ApiService().parseProducts(res.body);
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
            title: const Text('Kaut kas nogāja greizī'),
            content: const Text(
                'Iespējams tagad mums ir problēmas dabūt datus! Lūdzu, mēģini vēlāk.'),
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
    _loadInterstitialAd();
    barcodeScan();
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
      setState(() {
        foundProduct.clear();
      });
      barcodeScan();
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StoreLinkPage()));
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
            title: const Text("Comparify"),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            actions: [
              // Navigate to the Search Screen
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchPage())),
                  icon: const ImageIcon(
                    AssetImage("assets/search.png"),
                    color: Colors.black45,
                    size: 18,
                  ))
            ]),
        body: foundProduct.isEmpty && callDone
            ? const Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFF0C46DD),
                ),
              )
            : !callDone
                ? AlertDialog(
                    title: const Text('Paziņojums'),
                    content: const Text(
                        'Lūdzu, noskenē kodu vai meklē pēc nosaukuma.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SearchPage())),
                        child: const Text('Doties uz meklēšanu'),
                      ),
                      TextButton(
                        onPressed: () => barcodeScan(),
                        child: const Text('OK'),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: foundProduct.length,
                            // controller: _controller,
                            itemBuilder: (_, index) =>
                                ProductCard(foundProduct![index])),
                      ),
                    ],
                  ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedTab,
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
                  AssetImage("assets/store.png"),
                  // color: Colors.grey,
                  size: 18,
                ),
                label: "Veikali"),
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
}
