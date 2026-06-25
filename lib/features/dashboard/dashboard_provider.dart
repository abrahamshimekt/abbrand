import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dashboard_model.dart';

final dashboardProvider = FutureProvider<DashboardModel>((ref) async {
  final supabase = Supabase.instance.client;

  final shoes = await supabase.from('shoes').select();

  final sales = await supabase.from('sales').select();

  int totalStock = 0;
  double inventoryValue = 0;
  double revenue = 0;
  double profit = 0;

  for (final shoe in shoes) {
    final quantity = (shoe['quantity'] ?? 0) as num;

    final buyingPrice = (shoe['buying_price'] ?? 0).toDouble();

    totalStock += quantity.toInt();
    inventoryValue += quantity * buyingPrice;
  }

  for (final sale in sales) {
    revenue += (sale['total_amount'] ?? 0).toDouble();

    profit += (sale['profit'] ?? 0).toDouble();
  }

  return DashboardModel(
    totalStock: totalStock,
    totalInventoryValue: inventoryValue,
    totalRevenue: revenue,
    totalProfit: profit,
  );
});
