import 'package:comparify/models/retailer_price_dto_v3.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/helpers/in_app_web_view.dart';
import 'package:comparify/pages/helpers/multi_languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';

class RetailerPriceCard extends StatefulWidget {
  final RetailerPriceDTOV3 product;
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
  RetailerPriceDTOV3 product;
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
    final tooltipSection = Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
        child: SizedBox(
          height: 10,
          width: 10,
          child: FittedBox(
              fit: BoxFit.contain,
              child:
                  product.retailerId == 1 ? TooltipSample() : const Text('')),
        ));
    final nameSection = SizedBox(
        height: 20,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(left: 3, top: 3, bottom: 3),
                child: Text(getRetailerName(product.retailerId),
                    style: TextStyle(
                        color: isFirst
                            ? ApiConstants.bestPriceFontColor
                            : ApiConstants.mainFontColor,
                        fontSize: ApiConstants.productCardFontSize,
                        fontWeight:
                            isFirst ? FontWeight.w600 : FontWeight.w400)))));
    // final priceSection = Padding(
    //   padding: const EdgeInsets.only(left: 10, right: 0),
    //   // child: Align(
    //   //     alignment: Alignment.centerRight,
    //   //     child: Padding(
    //   //         padding: const EdgeInsets.only(left: 20),
    //       child:
    // Text(,
    //           style: TextStyle(
    //               color: isFirst
    //                   ? ApiConstants.bestPriceFontColor
    //                   : ApiConstants.mainFontColor,
    //               fontSize: ApiConstants.productCardFontSize,
    //               fontWeight: isFirst ? FontWeight.w500 : FontWeight.w400)
    //       )
    // // ),
    //   // )
    // );
    final buyActionSection = Expanded(
      child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => InAppWebViewPage(
                  title: getRetailerName(product.retailerId),
                  uri: product.retailerUrl))),
          child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(left: 3, top: 3, bottom: 3, right: 4),
                  child: Text(
                      "${getFormattedPrice(product.retailerPrice)}      ${MultiLanguages.of(context)!.translate("toBuy")}",
                      style: TextStyle(
                          color: isFirst
                              ? ApiConstants.bestPriceFontColor
                              : ApiConstants.mainFontColor,
                          fontSize: ApiConstants.productCardFontSize,
                          fontWeight:
                              isFirst ? FontWeight.w600 : FontWeight.w400))))),
      // )
    );
    // final pricebuySection = SizedBox(
    //   height: 20,
    //     width: MediaQuery.of(context).size.width*0.3,
    //     child: Row(
    //         children: <Widget>[ priceSection, buyActionSection
    //         ])
    // );
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 2),
        child: Container(
            child: RetailerPriceRow(
          tooltipSection: tooltipSection,
          nameSection: nameSection,
          // priceSection: priceSection,
          priceBuyActionSection: buyActionSection,
          // ),
        )));
  }

  String getFormattedPrice(double price) {
    return currency.format(price) + currency.currencySymbol;
  }

  String getRetailerName(int retailerId) {
    if (retailerId == 1) {
      return 'Barbora';
    }
    if (retailerId == 2) {
      return "Rimi";
    }
    if (retailerId == 3) {
      return "Citro";
    }
    if (retailerId == 4) {
      return "PienaVeikals";
    }
    return "";
  }
}

class TooltipSample extends StatelessWidget {
  const TooltipSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: MultiLanguages.of(context)!.translate("barboraLoyalPrice"),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(),
        // boxShadow: 0 0 5 rgba(50, 50, 50, 0.75),
        color: ApiConstants.tooltipBackgroundColor,
      ),
      triggerMode: TooltipTriggerMode.tap,
      height: 50,
      padding:
          const EdgeInsets.only(left: 9, right: 9, top: 36.0, bottom: 36.0),
      preferBelow: false,
      textStyle:
          const TextStyle(fontSize: 18, color: ApiConstants.mainFontColor),
      showDuration: const Duration(seconds: 3),
      waitDuration: const Duration(seconds: 1),
      child: Text("*", // item.label ?? '',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Colors.black.withOpacity(0.6),
          )),
    );

    // return Tooltip(
    //   message:  ,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     gradient:
    //         const LinearGradient(colors: <Color>[Colors.white, Colors.black12]),
    //   ),
    //   height: 50,
    //   padding: const EdgeInsets.all(8.0),
    //   preferBelow: false,
    //   textStyle:
    //       const TextStyle(fontSize: 18, color: ApiConstants.mainFontColor),
    //   showDuration: const Duration(seconds: 3),
    //   waitDuration: const Duration(seconds: 1),
    //   child: ,
    //   ),
    // );
  }
}

class RetailerPriceRow extends StatelessWidget {
  const RetailerPriceRow({
    Key? key,
    required this.tooltipSection,
    required this.nameSection,
    // required this.priceSection,
    required this.priceBuyActionSection,
  }) : super(key: key);

  final Padding tooltipSection;
  final SizedBox nameSection;

  // final SizedBox priceSection;
  final Expanded priceBuyActionSection;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: ApiConstants.retailerPriceBackgroundColor,
        shadowColor: Colors.transparent,
        elevation: 0,
        child: SizedBox(
          height: 24,
          width: 304,
          child: Row(children: <Widget>[
            tooltipSection, nameSection, priceBuyActionSection
            // Expanded(flex: 1, child: tooltipSection),
            // Expanded(flex: 5, child: nameSection),
            // Expanded(flex: 2, child: priceSection),
            // Expanded(flex: 2, child: buyActionSection),
          ]),
        ));
  }
}
