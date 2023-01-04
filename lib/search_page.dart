import 'dart:async';

import 'package:comparify_cross/about_us_page.dart';
import 'package:comparify_cross/ad_helper.dart';
import 'package:comparify_cross/constants.dart';
import 'package:comparify_cross/home.dart';
import 'package:comparify_cross/models/products_dto_v2.dart';
import 'package:comparify_cross/product_card.dart';
import 'package:comparify_cross/scan_barcode_page.dart';
import 'package:comparify_cross/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  List<ProductsDTOV2> productList = [];
  Timer searchOnStoppedTyping = new Timer(const Duration(seconds: 2), () {});
  bool _isSearchRunning = false;

  List<ProductsDTOV2> _foundProducts = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = '';
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();
    _controller.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _onChangeHandler(String value) {
    var duration = const Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel());
    }
    setState(() =>
        searchOnStoppedTyping = new Timer(duration, () => _loadMore(value)));
  }

  void _loadMore(String name) async {
    setState(() {
      _isSearchRunning = true;
      productList.clear();
      _foundProducts.clear();
    });

    try {
      final url =
          "${ApiConstants.baseUrl}${ApiConstants.findByNamePageEndpoint}/${name!}";
      final res = await http.get(Uri.parse("$url"));

      final List<ProductsDTOV2> fetchedPosts =
          ApiService().parseProducts(res.body);
      if (fetchedPosts.isNotEmpty) {
        setState(() {
          _foundProducts.addAll(fetchedPosts);
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
              // TextButton(
              //   onPressed: () => Navigator.pop(context, 'Cancel'),
              //   child: const Text('Cancel'),
              // ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    setState(() {
      // FocusManager.instance.primaryFocus?.unfocus();
      _isSearchRunning = false;
    });
  }

  _changeTab(int index) {
    if (index == 0) {
      if (_interstitialAd != null) {
        _loadInterstitialAdAndCategoryPage();
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    } else if (index == 1) {
      if (_interstitialAd != null) {
        _loadInterstitialAdAndScanPage();
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ScanBarCodePage()));
      }
    } else if (index == 2) {
      if (_interstitialAd != null) {
        _loadInterstitialAdAndScanPage();
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutUsPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int _selectedTab = 0;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Comparify',
              style: TextStyle(color: const Color(0xFF0C46DD))),
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Color(0xFF0C46DD)
          )
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              _bannerAd != null
                  ? SizedBox(
                      height: _bannerAd!.size.height.toDouble(),
                      child: Align(
                        // alignment: Alignment.topCenter,
                        child: Container(
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ), // make container of your ads
                      ))
                  : const SizedBox(
                      height: 5,
                    ),
              TextField(
                controller: _controller,
                onChanged: (value) => _onChangeHandler(value),
                decoration: InputDecoration(
                  prefixIcon: const IconButton(
                    onPressed: null,
                    icon: ImageIcon(AssetImage("assets/search.png")),
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () => clearAll(),
                          icon: const ImageIcon(AssetImage("assets/clear.png")),
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: _foundProducts.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundProducts.length,
                        itemBuilder: (context, index) =>
                            ProductCard(_foundProducts![index]))
                    : const Text(
                        'Nav meklēšanas rezultāta',
                        style: TextStyle(fontSize: 24, color: Colors.black45),
                      ),
              ),
              if (_isSearchRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedTab,
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

  void clearAll() {
    _controller.clear();
    setState(() {
      productList.clear();
      _foundProducts.clear();
    });
  }

  void _loadInterstitialAdAndCategoryPage() {
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

  void _loadInterstitialAdAndScanPage() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              const ScanBarCodePage();
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
}
