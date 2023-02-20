class RetailerPriceDTOV3 {
  final int retailerId;
  final String retailerUrl;
  final double retailerPrice;

  // final String retailerLastUpdate;

  RetailerPriceDTOV3(
      {required this.retailerId,
      required this.retailerUrl,
      required this.retailerPrice});

  factory RetailerPriceDTOV3.fromJson(Map<String, dynamic> json) {
    return RetailerPriceDTOV3(
        retailerId: json['retailerId'],
        retailerUrl: json['retailerUrl'],
        retailerPrice: json['retailerPrice']);
  }
}
