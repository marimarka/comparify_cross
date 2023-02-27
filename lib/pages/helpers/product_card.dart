import 'package:comparify/models/products_dto_v3.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/helpers/retailer_price_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatefulWidget {
  final ProductsDTOV3 product;
  final List<String> favoriteList;

  const ProductCard(this.product, this.favoriteList, {super.key});

  @override
  State<StatefulWidget> createState() {
    return ProductCardState(product, favoriteList);
  }
}

class ProductCardState extends State<ProductCard> {
  ProductsDTOV3 product;

  List<String> favoriteList;

  ProductCardState(this.product, this.favoriteList);

  @override
  void initState() {
    product.retailersItems.sort((a, b) {
      return a.retailerPrice.compareTo(b.retailerPrice);
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
            fit: BoxFit.contain,
            child: Image.network(
              product.productImageUrl,
              errorBuilder: (context, exception, stackTrace) {
                return Image.asset("assets/no_image.png");
              },
            ),
          ),
        ));
    double unitHeightValue = MediaQuery.of(context).size.width;
    const double multiplier = 0.04;
    final nameSection = SizedBox(
      height: 94,
      width: 172,

        // FittedBox(
        //   fit: BoxFit.fitWidth,
          // fit: BoxFit.scaleDown,
      child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 8),
              child: Text(
                product.productName,
                style: TextStyle(
                    // fontSize: 14,
                    fontSize: multiplier * unitHeightValue,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    color: ApiConstants.mainFontColor),
              ))),
    );

    var favorite = favoriteList.contains(product.id.toString());
    final favoriteSection = Padding(
        padding: const EdgeInsets.only(
          right: 4,
        ),
        child: IconButton(
          icon: Image.asset(
            favorite ? 'assets/favorite_saved.png' : 'assets/favorite_bold.png',
            color: ApiConstants.buttonsAndMenuColor,
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
        child: SizedBox(
            height: (100 + 38.0 * product.retailersItems.length),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(flex: 3, child: imageSection),
                    Expanded(flex: 6, child: nameSection),
                    Expanded(flex: 1, child: favoriteSection)
                  ]),
              Expanded(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: product.retailersItems.length,
                    itemBuilder: (_, index) => RetailerPriceCard(
                        product.retailersItems[index],
                        index == 0 && (product.retailersItems.length < 2
                            ? true
                            : product.retailersItems[index].retailerPrice !=
                                product.retailersItems[1].retailerPrice))),
              )
            ])));
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
      width: MediaQuery.of(context).size.width,// * 0.85,
      child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: productCard)
    );
  }
}
