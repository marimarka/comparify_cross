import 'package:comparify_cross/in_app_web_view.dart';
import 'package:comparify_cross/models/retailer_price_dto_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';

class RetailerPriceCard extends StatefulWidget {
  final RetailerPriceDTOV2 product;
  final bool isFirst;

  final MyInAppBrowser browser = new MyInAppBrowser();

  RetailerPriceCard(this.product, this.isFirst);

  @override
  RetailerPriceCardState createState() {
    return RetailerPriceCardState(product, isFirst);
  }
}

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}

class RetailerPriceCardState extends State<RetailerPriceCard> {
  RetailerPriceDTOV2 product;
  bool isFirst;

  final currency = NumberFormat.currency(
      locale: 'eu', customPattern: '#,##0.00', symbol: '€', decimalDigits: 2);

  var options = InAppBrowserClassOptions(
      crossPlatform: InAppBrowserOptions(hideUrlBar: false),
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)));

  RetailerPriceCardState(this.product, this.isFirst);

  @override
  Widget build(BuildContext context) {
    final logoSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 25,
          width: 25,
          child: FittedBox(
            fit: BoxFit.contain,
            child: product.retailerName == 'Barbora'
                ? Image.asset("assets/barbora_logo.png")
                : product.retailerName == 'Rimi'
                    ? Image.asset("assets/rimi_logo.png")
                    : Image.asset("assets/piena_veikals_logo.png"),
          ),
        ));

    final nameAndPriceSection = Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        isFirst == true
            ? product.retailerName == 'Barbora'
                ? Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(product.retailerName,
                        style:
                            const TextStyle(color: Colors.green, fontSize: 20)))
                : Text(product.retailerName,
                    style: const TextStyle(color: Colors.green, fontSize: 20))
            : product.retailerName == 'Barbora'
                ? Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(product.retailerName,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20)))
                : Text(product.retailerName,
                    style: const TextStyle(color: Colors.black, fontSize: 20)),
        isFirst == true
            ? Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(getFormattedPrice(product.retailerPrice),
                    style: const TextStyle(color: Colors.green, fontSize: 20)))
            : Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(getFormattedPrice(product.retailerPrice),
                    style: const TextStyle(color: Colors.black, fontSize: 20)))
      ],
    ));
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: product.retailerPrice == '-'
            ? Container(
                child: RetailerPriceRow(
                    logoSection: logoSection,
                    nameAndPriceSection: nameAndPriceSection))
            : InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => InAppWebViewPage(
                        title: product.retailerName,
                        uri: product.retailerUrl))),
                // launch(product.retailerUrl),
                child: RetailerPriceRow(
                    logoSection: logoSection,
                    nameAndPriceSection: nameAndPriceSection)));
  }

  String getFormattedPrice(String price) {
    if (double.tryParse(price) != null) {
      return currency.format(double.parse(price)) + currency.currencySymbol;
    }
    return price;
  }
}

class RetailerPriceRow extends StatelessWidget {
  const RetailerPriceRow({
    Key? key,
    required this.logoSection,
    required this.nameAndPriceSection,
  }) : super(key: key);

  final Padding logoSection;
  final Expanded nameAndPriceSection;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: const Color(0xFFF8F9F9),
        child: Row(children: <Widget>[logoSection, nameAndPriceSection]));
  }
}
