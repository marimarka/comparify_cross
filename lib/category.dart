import 'package:comparify_cross/about_us_page.dart';
import 'package:comparify_cross/ad_helper.dart';
import 'package:comparify_cross/constants.dart';
import 'package:comparify_cross/product_card.dart';
import 'package:comparify_cross/scan_barcode_page.dart';
import 'package:comparify_cross/search_page.dart';
import 'package:comparify_cross/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  final String categoriesName;

  Category({required this.categoriesName, Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState(categoriesName);
}

class _CategoryState extends State<Category> {
  final String categoriesName;
  InterstitialAd? _interstitialAd;

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
              title: const Text('Kaut kas nogāja greizī'),
              content: const Text('Iespējams tagad mums ir problēmas dabūt datus! Lūdzu, mēģini vēlāk.'),
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
            title: const Text('Kaut kas nogāja greizī'),
            content: const Text('Iespējams tagad mums ir problēmas dabūt datus! Lūdzu, mēģini vēlāk.'),
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
      _isFirstLoadRunning = false;
    });
  }

  _CategoryState(@required this.categoriesName);

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _loadInterstitialAd();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              this.categoriesName,
              style: TextStyle(color: const Color(0xFF0C46DD)),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              // Navigate to the Search Screen
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchPage())),
                  icon: const ImageIcon(
                    AssetImage("assets/search.png"),
                    // color: Colors.grey,
                    size: 18,
                  ))
            ]),
        body: _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: productList.length,
                        controller: _controller,
                        itemBuilder: (_, index) =>
                            ProductCard(productList![index])),
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
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
          selectedItemColor: Colors.blueAccent,
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

  _changeTab(int index) {
    if (index == 0) {
      if (_interstitialAd != null) {
        _interstitialAd?.show();
      } else {
        Navigator.pop(context);
      }
    } else if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ScanBarCodePage()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutUsPage()));
    }
  }

  int getCategoryNumber(String name) {
    if (name == 'Maize un konditoreja') return 1;
    if (name == 'Piena produkti un olas') return 2;
    if (name == 'Augļi un dārzeņi') return 3;
    if (name == 'Gaļa, zivs un gatava kulinārija') return 4;
    if (name == 'Bakaleja') return 5;
    if (name == 'Saldēta pārtika') return 6;
    if (name == 'Dzērieni') return 7;
    if (name == 'Alkoholiskie dzērieni') return 8;
    if (name == 'Zīdaiņu un bērnu preces') return 9;
    if (name == 'Mājai, tīrīšanai un mājdzīvniekiem') return 11;
    return 0;
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
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
