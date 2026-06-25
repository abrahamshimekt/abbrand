class ShoeModel {
  final String id;
  final String name;
  final String brand;
  final String size;
  final int quantity;
  final double buyingPrice;
  final double sellingPrice;
  final String? imageUrl;

  ShoeModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.size,
    required this.quantity,
    required this.buyingPrice,
    required this.sellingPrice,
    this.imageUrl,
  });

  factory ShoeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ShoeModel(
      id: json['id'],
      name: json['name'],
      brand: json['brand'] ?? '',
      size: json['size'] ?? '',
      quantity: json['quantity'] ?? 0,
      buyingPrice:
          (json['buying_price'] ?? 0).toDouble(),
      sellingPrice:
          (json['selling_price'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'name': name,
    'brand': brand,
    'size': size,
    'quantity': quantity,
    'buying_price': buyingPrice,
    'selling_price': sellingPrice,
    'image_url': imageUrl,
  };
}
}