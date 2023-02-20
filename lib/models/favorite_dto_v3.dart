class FavoriteDTOV3 {
  final List<int> productIds;
  final int size;
  final int page;

  FavoriteDTOV3(
      {required this.productIds, required this.size, required this.page});

  Map toJson() {
    return {
      'productIds': productIds,
      //this.productIds.map((i) => i.toJson()).toList()
      'size': size,
      'page': page
    };
  }
}
