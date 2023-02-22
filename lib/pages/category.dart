import 'package:comparify/pages/about_us_page.dart';
import 'package:comparify/pages/favorites_page.dart';
import 'package:comparify/pages/helpers/ad_helper.dart';
import 'package:comparify/pages/helpers/bottom.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/helpers/product_card.dart';
import 'package:comparify/pages/scan_barcode_page.dart';
import 'package:comparify/pages/search_page.dart';
import 'package:comparify/pages/store_link_page.dart';
import 'package:comparify/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/multi_languages.dart';

class Category extends StatefulWidget {
  final String categoriesName;
  final String imageUrl;

  const Category(
      {required this.categoriesName, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  CategoryState createState() => CategoryState(categoriesName, imageUrl);
}

class CategoryState extends State<Category> {
  final String categoriesName;
  final String imageUrl;
  InterstitialAd? _interstitialAd;
  InterstitialAd? _interstitialAdAndOpenStorePage;

  List<String> favoriteList = [];

  final int _selectedTab = 0;

  final _baseUrl =
      ApiConstants.baseUrl + ApiConstants.findByCategoryPageEndpoint;

  int _page = 0;

  final int _limit = 10;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  List productList = [];

  void _preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteList = prefs.getStringList("favorites") ?? [];
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _page += 1;

      try {
        final categoriesNumber = getCategoryNumber(categoriesName);
        final skipRecords = _page * _limit;
        final url = '$_baseUrl/$categoriesNumber/$skipRecords/$_limit';
        final res = await http.get(Uri.parse(url));

        final List fetchedPosts = ApiService().parseProducts(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            productList.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
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

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final categoriesNumber = getCategoryNumber(categoriesName);
      final skipRecords = _page * _limit;
      final url = '$_baseUrl/$categoriesNumber/$skipRecords/$_limit';
      final res = await http.get(Uri.parse(url));
      setState(() {
        productList = ApiService().parseProducts(res.body);
      });
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

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  CategoryState(this.categoriesName, this.imageUrl);

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _preferences();
    _firstLoad();
    _loadInterstitialAd();
    _loadInterstitialAdAndStoreLinkPage();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAdAndOpenStorePage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: Text(MultiLanguages.of(context)!.translate(categoriesName),
                style: const TextStyle(color: ApiConstants.appBarFontColor,
                fontFamily: "Roboto", fontSize: ApiConstants.titleFontSize,
                fontWeight: FontWeight.w700)),
            backgroundColor: ApiConstants.buttonsAndMenuColor,
            automaticallyImplyLeading: ApiConstants.showTopBar,
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchPage())),
                  icon: const ImageIcon(
                    AssetImage("assets/search.png"),
                    color: ApiConstants.appBarFontColor,
                    size: 18,
                  ))
            ]),
        body: _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(
                    color: ApiConstants.buttonsAndMenuColor),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        key: const Key('items'),
                        itemCount: productList.length,
                        controller: _controller,
                        itemBuilder: (_, index) =>
                            ProductCard(productList[index], favoriteList,
                                key: Key(productList[index].id.toString()))),
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: ApiConstants.buttonsAndMenuColor),
                      ),
                    ),
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Center(
                        child: Text(
                            MultiLanguages.of(context)!.translate("endOfList")),
                      ),
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

  _changeTab(int index) {
    if (index == 0) {
      if (_interstitialAd != null) {
        _interstitialAd?.show();
      } else {
        Navigator.pop(context);
      }
    } else if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ScanBarCodePage()));
    } else if (index == 2) {
      if (_interstitialAdAndOpenStorePage != null) {
        _interstitialAdAndOpenStorePage!.show();
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StoreLinkPage()));
      }
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FavoritesPage()));
    } else if (index == 4) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutUsPage()));
    }
  }

  void _loadInterstitialAdAndStoreLinkPage() {
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

  int getCategoryNumber(String name) {
    if (name == "breadCatalog") return 1;
    if (name == "milkCatalog") return 2;
    if (name == "vegetablesCatalog") {
      return 3;
    }
    if (name == "meatCatalog") return 4;
    if (name == "bacaley") return 5;
    if (name == "iced") return 6;
    if (name == "drinks") return 7;
    if (name == "alcoDrinks") return 8;
    if (name == "babiesGoods") return 9;
    if (name == "houseGoods") return 11;
    return 0;
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pop(context);
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
