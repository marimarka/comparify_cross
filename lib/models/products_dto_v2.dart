class ProductsDTOV2 {
  final int id;
  final String productName;
  final String productCategory;
  final String productImageUrl;
  final String barboraUrl;
  final String barboraPrice;
  final String barboraLastUpdate;
  final String rimiUrl;
  final String rimiPrice;
  final String rimiLastUpdate;
  final String pienaVeikalsUrl;
  final String pienaVeikalsPrice;
  final String pienaVeikalsLastUpdate;

  ProductsDTOV2(
      {required this.id,
      required this.productName,
      required this.productCategory,
      required this.productImageUrl,
      required this.barboraUrl,
      required this.barboraPrice,
      required this.barboraLastUpdate,
      required this.rimiUrl,
      required this.rimiPrice,
      required this.rimiLastUpdate,
      required this.pienaVeikalsUrl,
      required this.pienaVeikalsPrice,
      required this.pienaVeikalsLastUpdate});

  factory ProductsDTOV2.fromJson(Map<String, dynamic> json) {
    return ProductsDTOV2(
        id: json['id'],
        productName: json['productName'],
        productCategory: json['productCategory'],
        productImageUrl: json['productImageUrl'],
        barboraUrl: json['barboraUrl'],
        barboraPrice: json['barboraPrice'],
        barboraLastUpdate: json['barboraLastUpdate'],
        rimiUrl: json['rimiUrl'],
        rimiPrice: json['rimiPrice'],
        rimiLastUpdate: json['rimiLastUpdate'],
        pienaVeikalsUrl: json['pienaVeikalsUrl'],
        pienaVeikalsPrice: json['pienaVeikalsPrice'],
        pienaVeikalsLastUpdate: json['pienaVeikalsLastUpdate']);
  }

  static List<ProductsDTOV2> fromJsonList(dynamic jsonList) {
    final productList = <ProductsDTOV2>[];
    if (jsonList == null) return productList;

    if (jsonList is List<dynamic>) {
      for (final json in jsonList) {
        productList.add(
          ProductsDTOV2.fromJson(json),
        );
      }
    }

    return productList;
  }
}
