import 'package:comparify_cross/models/retailer_price_dto_v3.dart';
import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/pages/helpers/in_app_web_view.dart';
import 'package:comparify_cross/pages/helpers/multi_languages.dart';
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
              child: product.retailerId == 1
                  ? const TooltipSample()
                  : const Text('')),
        ));

    final nameSection = SizedBox(
        height: 20,
        width: 220,
        child: Align(
            alignment: Alignment.centerLeft,
            // child: Padding(
            //     padding: const EdgeInsets.only(left: 3),
                child: Text(getRetailerName(product.retailerId),
                    style: TextStyle(
                        color: isFirst
                            ? ApiConstants.bestPriceFontColor
                            : ApiConstants.mainFontColor,
                        fontSize: ApiConstants.productCardFontSize,
                        fontWeight:
                            isFirst ? FontWeight.w500 : FontWeight.w400)))
    // )
    );
    final priceSection = SizedBox(
      width: 41,
      height: 20,
      child: Align(
          alignment: Alignment.centerRight,
          // child: Padding(
          //     padding: const EdgeInsets.only(left: 10),
          child: Text(getFormattedPrice(product.retailerPrice),
              style: TextStyle(
                  color: isFirst
                      ? ApiConstants.bestPriceFontColor
                      : ApiConstants.mainFontColor,
                  fontSize: ApiConstants.productCardFontSize,
                  fontWeight: isFirst ? FontWeight.w500 : FontWeight.w400))),
      // )
    );
    final buyActionSection = Expanded(
      child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => InAppWebViewPage(
                  title: getRetailerName(product.retailerId),
                  uri: product.retailerUrl))),
          child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(left: 3, right: 12),
                  child: Text(MultiLanguages.of(context)!.translate("toBuy"),
                      style: TextStyle(
                          color: isFirst
                              ? ApiConstants.bestPriceFontColor
                              : ApiConstants.mainFontColor,
                          fontSize: ApiConstants.productCardFontSize,
                          fontWeight:
                              isFirst ? FontWeight.w500 : FontWeight.w400))))),
    );
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
            child: RetailerPriceRow(
          tooltipSection: tooltipSection,
          nameSection: nameSection,
          priceSection: priceSection,
          buyActionSection: buyActionSection,
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
      message: 'Neattēlo Paldies kartes individuāla piedāvājuma atlaides',
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient:
            const LinearGradient(colors: <Color>[Colors.white, Colors.black12]),
      ),
      height: 50,
      padding: const EdgeInsets.all(8.0),
      preferBelow: false,
      textStyle:
          const TextStyle(fontSize: 18, color: ApiConstants.mainFontColor),
      showDuration: const Duration(seconds: 3),
      waitDuration: const Duration(seconds: 1),
      child: const Text(
        '*',
        style: TextStyle(color: ApiConstants.mainFontColor),
      ),
    );
  }
}

class RetailerPriceRow extends StatelessWidget {
  const RetailerPriceRow({
    Key? key,
    required this.tooltipSection,
    required this.nameSection,
    required this.priceSection,
    required this.buyActionSection,
  }) : super(key: key);

  final Padding tooltipSection;
  final SizedBox nameSection;
  final SizedBox priceSection;
  final Expanded buyActionSection;

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
            tooltipSection, nameSection, priceSection, buyActionSection
            // Expanded(flex: 1, child: tooltipSection),
            // Expanded(flex: 5, child: nameSection),
            // Expanded(flex: 2, child: priceSection),
            // Expanded(flex: 2, child: buyActionSection),
          ]),
        ));
  }
}
