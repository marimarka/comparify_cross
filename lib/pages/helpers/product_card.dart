import 'package:comparify_cross/models/products_dto_v3.dart';
import 'package:comparify_cross/models/retailer_price_dto_v3.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/helpers/retailer_price_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatefulWidget {
  final ProductsDTOV3 product;
  final List<String> favoriteList;

  ProductCard(this.product, this.favoriteList);

  @override
  State<StatefulWidget> createState() {
    return ProductCardState(product, favoriteList);
  }
}

class ProductCardState extends State<ProductCard> {
  ProductsDTOV3 product;
  List retailerPriceList = [];
  List<String> favoriteList;

  ProductCardState(this.product, this.favoriteList);

  @override
  void initState() {
    retailerPriceList.add(RetailerPriceDTOV3(
        retailerName: 'Barbora',
        retailerUrl: product.barboraUrl,
        retailerPrice: product.barboraPrice,
        retailerLastUpdate: product.barboraLastUpdate));

    retailerPriceList.add(RetailerPriceDTOV3(
        retailerName: 'Rimi',
        retailerUrl: product.rimiUrl,
        retailerPrice: product.rimiPrice,
        retailerLastUpdate: product.rimiLastUpdate));

    retailerPriceList.add(RetailerPriceDTOV3(
        retailerName: 'PienaVeikals',
        retailerUrl: product.pienaVeikalsUrl,
        retailerPrice: product.pienaVeikalsPrice,
        retailerLastUpdate: product.pienaVeikalsLastUpdate));

    retailerPriceList.sort((a, b) {
      var adate = 999999999999.99;
      if (double.tryParse(a.retailerPrice) != null &&
          a.retailerPrice != '0.00') {
        adate = double.parse(a.retailerPrice);
      }
      var bdate = 9999999999999.99;
      if (double.tryParse(b.retailerPrice) != null &&
          b.retailerPrice != '0.00') {
        bdate = double.parse(b.retailerPrice);
      }
      return adate.compareTo(bdate);
    });
    super.initState();
  }

  Widget get productCard {
    final imageSection = SizedBox(
        height: 100,
        width: 94,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 8),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image.network(
              product.productImageUrl,
              errorBuilder: (context, exception, stackTrace) {
                return Image.asset("assets/no_image.png");
              },
            ),
          ),
        ));

    final nameSection = SizedBox(
      height: 94,
      width: 172,
      child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 8),
              child: Text(
                product.productName,
                style: const TextStyle(
                    fontSize: 14,
                    color: ApiConstants.mainFontColor,
                    height: 1.6),
              ))),
    );

    var favorit = favoriteList.contains(product.id);
    final favoriteSection = Padding(
        padding: const EdgeInsets.only(
          right: 4,
        ),
        child: IconButton(
          icon: Image.asset(
            favorit ? 'assets/favorite_filled.png' : 'assets/favorits.png',
          ),
          iconSize: 30,
          onPressed: () {
            _addToFavorites(favoriteList, product.id);
          },
        ));
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 3, child: imageSection),
              Expanded(flex: 6, child: nameSection),
              Expanded(flex: 1, child: favoriteSection)
            ]

            // <Widget>[imageSection, nameSection, likeSection],
          ),
          Expanded(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // itemCount: product.retailersItems.length,
                itemCount: retailerPriceList.length,
                itemBuilder: (_, index) =>
                    RetailerPriceCard(retailerPriceList[index], index == 0)),
            // RetailerPriceCard(product.retailersItems[index], index == 0)),
          )
        ]));
  }

  void _addToFavorites(List<String> favoriteList, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (favoriteList.contains(id.toString())) {
      favoriteList.remove(id.toString());
    } else {
      favoriteList.add(id.toString());
    }
    await prefs.setStringList('favorites', favoriteList);
    setState(() {
      favoriteList = prefs.getStringList("favorites") ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 328,
      height: 220,
      child: productCard,
    );
  }
}
