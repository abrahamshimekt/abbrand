import 'package:supabase_flutter/supabase_flutter.dart';

class SalesRepository {
  final supabase = Supabase.instance.client;

  Future<void> sellShoe({
    required String shoeId,
    required String shoeName,
    required String size,
    required int currentStock,
    required int quantity,
    required double buyingPrice,
    required double sellingPrice,
  }) async {
    if (quantity <= 0) {
      throw Exception("Quantity must be greater than zero");
    }

    if (quantity > currentStock) {
      throw Exception("Not enough stock available");
    }

    final remainingStock = currentStock - quantity;
    final totalAmount = sellingPrice * quantity;
    final profit = (sellingPrice - buyingPrice) * quantity;

    // 1. Save sales history FIRST (important)
    await supabase.from('sales').insert({
      'shoe_id': shoeId,
      'shoe_name': shoeName,
      'size': size,
      'quantity': quantity,
      'buying_price': buyingPrice,
      'selling_price': sellingPrice,
      'total_amount': totalAmount,
      'profit': profit,
    });

    // 2. Update shoe instead of deleting
    await supabase
        .from('shoes')
        .update({'quantity': remainingStock, 'is_active': remainingStock > 0})
        .eq('id', shoeId);
  }

  Future<List<Map<String, dynamic>>> getSales() async {
    final data = await supabase
        .from('sales')
        .select()
        .order('sold_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}
