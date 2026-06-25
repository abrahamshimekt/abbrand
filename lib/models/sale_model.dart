class SaleModel {
  final String id;
  final String shoeId;
  final int quantity;
  final double sellingPrice;
  final double totalAmount;
  final double profit;
  final DateTime soldAt;

  SaleModel({
    required this.id,
    required this.shoeId,
    required this.quantity,
    required this.sellingPrice,
    required this.totalAmount,
    required this.profit,
    required this.soldAt,
  });

  factory SaleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SaleModel(
      id: json['id'],
      shoeId: json['shoe_id'],
      quantity: json['quantity'],
      sellingPrice:
          (json['selling_price'] as num)
              .toDouble(),
      totalAmount:
          (json['total_amount'] as num)
              .toDouble(),
      profit:
          (json['profit'] as num)
              .toDouble(),
      soldAt:
          DateTime.parse(json['sold_at']),
    );
  }
}