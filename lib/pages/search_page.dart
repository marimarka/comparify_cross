import 'dart:async';

import 'package:comparify_cross/models/products_dto_v2.dart';
import 'package:comparify_cross/pages/about_us_page.dart';
import 'package:comparify_cross/pages/helpers/ad_helper.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/helpers/product_card.dart';
import 'package:comparify_cross/pages/home.dart';
import 'package:comparify_cross/pages/scan_barcode_page.dart';
import 'package:comparify_cross/pages/store_link_page.dart';
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
  InterstitialAd? _interstitialAdAndOpenStorePage;

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
    _loadInterstitialAdAndStoreLinkPage();
    _loadInterstitialAdAndCategoryPage();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _controller.dispose();
    _interstitialAd?.dispose();
    _interstitialAdAndOpenStorePage?.dispose();
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
          "${ApiConstants.baseUrl}${ApiConstants.findByNamePageEndpoint}/${name}";
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
      _isSearchRunning = false;
    });
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
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutUsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    int _selectedTab = 0;

    return Scaffold(
        appBar: AppBar(
            title:
                const Text('Comparify', style: TextStyle(color: ApiConstants.mainFontColor)),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              _bannerAd != null
                  ? SizedBox(
                      height: _bannerAd!.size.height.toDouble(),
                      child: Align(
                        child: Container(
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      ))
                  : const SizedBox(
                      height: 5,
                    ),
              TextField(
                cursorColor: ApiConstants.mainFontColor,
                controller: _controller,
                onChanged: (value) => _onChangeHandler(value),
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: ApiConstants.mainFontColor),
                  ),
                  prefixIcon: const IconButton(
                    onPressed: null,
                    icon: ImageIcon(AssetImage("assets/search.png")),
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () => clearAll(),
                          icon: const ImageIcon(AssetImage("assets/clear.png")),
                          color: ApiConstants.mainFontColor)
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
                            ProductCard(_foundProducts[index]))
                    : const Text(
                        'Nav meklēšanas rezultāta',
                        style: TextStyle(fontSize: 24, color: Colors.black45),
                      ),
              ),
              if (_isSearchRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: ApiConstants.mainFontColor),
                  ),
                ),
            ],
          ),
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

  void _loadInterstitialAdAndStoreLinkPage() {
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
}
