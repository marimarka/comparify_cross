import 'dart:convert';

import 'package:comparify_cross/models/favorite_dto_v3.dart';
import 'package:comparify_cross/pages/helpers/ad_helper.dart';
import 'package:comparify_cross/pages/helpers/bottom.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'about_us_page.dart';
import 'helpers/multi_languages.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesPage> {
  InterstitialAd? _interstitialAd;
  InterstitialAd? _interstitialAdAndOpenStorePage;

  List<String> favoriteList = [];

  late ScrollController _controller;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  final _baseUrl = ApiConstants.baseUrl + ApiConstants.findByIds;

  int _page = 0;

  final int _limit = 10;

  int _selectedTab = 3;

  List favoriteProductList = [];

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
        final url = _baseUrl;
        List<int> productIds = [];
        favoriteList.forEach((element) {
          productIds.add(int.parse(element));
        });
        print('limits: ' + _limit.toString() + ' page: ' + _page.toString());
        FavoriteDTOV3 favoriteDTOV3 = FavoriteDTOV3(
            productIds: productIds, size: _limit, page: _page * _limit);
        var body = json.encode(favoriteDTOV3);

        var response = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"}, body: body);

        final List fetchedPosts = ApiService().parseProducts(response.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            favoriteProductList.addAll(fetchedPosts);
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
      // final skipRecords = _page * _limit;
      // // final url = '$_baseUrl/$skipRecords/$_limit';
      final url = _baseUrl;
      List<int> productIds = [];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        favoriteList = prefs.getStringList("favorites") ?? [];
      });

      favoriteList.forEach((element) {
        productIds.add(int.parse(element));
      });
      FavoriteDTOV3 favoriteDTOV3 =
          FavoriteDTOV3(productIds: productIds, size: _limit, page: 0);
      var body = json.encode(favoriteDTOV3);

      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      setState(() {
        favoriteProductList = ApiService().parseProducts(response.body);
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

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _loadInterstitialAdAndOpenStorePage();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
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
            context, MaterialPageRoute(builder: (context) => StoreLinkPage()));
      }
    } else if (index == 3) {
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
          title: Text(MultiLanguages.of(context)!.translate("favorites"),
              style: const TextStyle(
                  color: ApiConstants.appBarFontColor,
                  fontFamily: "Roboto",
                  fontSize: ApiConstants.titleFontSize,
                  fontWeight: FontWeight.w700)),
          backgroundColor: ApiConstants.buttonsAndMenuColor,
          automaticallyImplyLeading: ApiConstants.showTopBar,
        ),
        body: _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(
                    color: ApiConstants.buttonsAndMenuColor))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        key: const Key('items'),
                        itemCount: favoriteProductList.length,
                        controller: _controller,
                        itemBuilder: (_, index) => ProductCard(
                            favoriteProductList[index], favoriteList,
                            key:
                                Key(favoriteProductList[index].id.toString()))),
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
}
