import 'package:comparify_cross/models/products_dto_v2.dart';
import 'package:comparify_cross/models/retailer_price_dto_v2.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/helpers/retailer_price_card.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ProductsDTOV2 product;

  ProductCard(this.product);

  @override
  State<StatefulWidget> createState() {
    return ProductCardState(product);
  }
}

class ProductCardState extends State<ProductCard> {
  ProductsDTOV2 product;
  List retailerPriceList = [];

  ProductCardState(this.product);

  @override
  void initState() {
    retailerPriceList.add(RetailerPriceDTOV2(
        retailerName: 'Barbora',
        retailerUrl: product.barboraUrl,
        retailerPrice: product.barboraPrice,
        retailerLastUpdate: product.barboraLastUpdate));

    retailerPriceList.add(RetailerPriceDTOV2(
        retailerName: 'Rimi',
        retailerUrl: product.rimiUrl,
        retailerPrice: product.rimiPrice,
        retailerLastUpdate: product.rimiLastUpdate));

    retailerPriceList.add(RetailerPriceDTOV2(
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
      height: 130,
      width: 130,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Image.network(product.productImageUrl,
          errorBuilder: (context, exception, stackTrace) {
            return Image.asset("assets/no_image.png");
          },
        ),
      ),
    );

    final nameSection = Expanded(
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            product.productName,
            style: const TextStyle(fontSize: 22, color: ApiConstants.mainFontColor),
          )),
    );
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[imageSection, nameSection],
          ),
          Expanded(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: retailerPriceList.length,
                itemBuilder: (_, index) =>
                    RetailerPriceCard(retailerPriceList![index], index == 0)),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 150,
      height: 280,
      child: productCard,
    );
  }
}
