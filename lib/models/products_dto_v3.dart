
import 'package:comparify/models/retailer_price_dto_v3.dart';

class ProductsDTOV3 {
  final int id;
  final String productName;
  final String productCategory;
  final String productImageUrl;
  final List<RetailerPriceDTOV3> retailersItems;

  ProductsDTOV3(
      {required this.id,
      required this.productName,
      required this.productCategory,
      required this.productImageUrl,
      required this.retailersItems
      });

  factory ProductsDTOV3.fromJson(Map<String, dynamic> jsonObject) {
    // List<ProductsDTOV3> parseProducts(String responseBody) {
    //   final parsedList = json.decode(jsonObject['retailersItems']).cast<Map<String, dynamic>>();
    // Iterable l = json.decode(jsonObject['retailersItems'][0]);
    // List<Post> posts = List<Post>.from(l.map((model)=> Post.fromJson(model)));

    // List< RetailerPriceDTOV3 > itemsList=
    // List< RetailerPriceDTOV3 >.from(l.map((i) => RetailerPriceDTOV3.fromJson(i))).toList();
    return ProductsDTOV3(
        id: jsonObject['id'],
        productName: jsonObject['productName'],
        productCategory: jsonObject['productCategory'],
        productImageUrl: jsonObject['productImageUrl'],
        retailersItems: fromJsonList(jsonObject['retailersItems']));
    // );
  }

  static List<RetailerPriceDTOV3> fromJsonList(dynamic jsonList) {
    final productList = <RetailerPriceDTOV3>[];
    if (jsonList == null) return productList;

    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        productList.add(
          RetailerPriceDTOV3.fromJson(json),
        );
      }
    }

    return productList;
  }
}
