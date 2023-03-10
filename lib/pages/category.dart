import 'package:comparify_cross/pages/about_us_page.dart';
import 'package:comparify_cross/pages/helpers/ad_helper.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/helpers/product_card.dart';
import 'package:comparify_cross/pages/scan_barcode_page.dart';
import 'package:comparify_cross/pages/search_page.dart';
import 'package:comparify_cross/pages/store_link_page.dart';
import 'package:comparify_cross/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  final String categoriesName;
  final String imageUrl;

  Category({required this.categoriesName, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  _CategoryState createState() => _CategoryState(categoriesName, imageUrl);
}

class _CategoryState extends State<Category> {
  final String categoriesName;
  final String imageUrl;
  InterstitialAd? _interstitialAd;
  InterstitialAd? _interstitialAdAndOpenStorePage;

  int _selectedTab = 0;

  final _baseUrl =
      ApiConstants.baseUrl + ApiConstants.findByCategoryPageEndpoint;

  int _page = 0;

  final int _limit = 10;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  List productList = [];

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
        final _skipRecords = _page * _limit;
        final url = '$_baseUrl/$categoriesNumber/$_skipRecords/$_limit';
        final res = await http.get(Uri.parse("$url"));

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
              title: const Text('Kaut kas nog??ja greiz??'),
              content: const Text(
                  'Iesp??jams tagad mums ir probl??mas dab??t datus! L??dzu, m????ini v??l??k.'),
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
      final _skipRecords = _page * _limit;
      final url = '$_baseUrl/$categoriesNumber/$_skipRecords/$_limit';
      final res = await http.get(Uri.parse(url));
      setState(() {
        productList = ApiService().parseProducts(res.body);
        ;
      });
    } catch (err) {
      if (kDebugMode) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Kaut kas nog??ja greiz??'),
            content: const Text(
                'Iesp??jams tagad mums ir probl??mas dab??t datus! L??dzu, m????ini v??l??k.'),
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

  _CategoryState(@required this.categoriesName, @required this.imageUrl);

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
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
            title: Text(
              this.categoriesName,
              style: const TextStyle(color: ApiConstants.mainFontColor),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
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
        body: _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(color: ApiConstants.mainFontColor),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: productList.length,
                        controller: _controller,
                        itemBuilder: (_, index) =>
                            ProductCard(productList[index])),
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(color: ApiConstants.mainFontColor),
                      ),
                    ),
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: const Center(
                        child: Text('Saraksta beigas'),
                      ),
                    ),
                ],
              ),
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StoreLinkPage()));
       }
    } else if (index == 3) {
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

  int getCategoryNumber(String name) {
    if (name == 'Maize un konditoreja') return 1;
    if (name == 'Piena produkti un olas') return 2;
    if (name == 'Aug??i un d??rze??i') return 3;
    if (name == 'Ga??a, zivs un gatava kulin??rija') return 4;
    if (name == 'Bakaleja') return 5;
    if (name == 'Sald??ta p??rtika') return 6;
    if (name == 'Dz??rieni') return 7;
    if (name == 'Alkoholiskie dz??rieni') return 8;
    if (name == 'Z??dai??u un b??rnu preces') return 9;
    if (name == 'M??jai, t??r????anai un m??jdz??vniekiem') return 11;
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
}
