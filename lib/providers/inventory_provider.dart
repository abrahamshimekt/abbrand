import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/shoe_model.dart';
import '../repositories/inventory_repository.dart';

/// 📦 Repository Provider
final inventoryRepositoryProvider =
    Provider<InventoryRepository>((ref) {
  return InventoryRepository();
});

/// 🔥 REAL-TIME INVENTORY (FIXED)
final inventoryProvider =
    StreamProvider<List<ShoeModel>>((ref) {
  final supabase = Supabase.instance.client;

  final stream = supabase
      .from('shoes')
      .stream(primaryKey: ['id'])
      .eq('is_active', true)
      .order('created_at', ascending: false)
      .map((data) {
        return data
            .map((e) => ShoeModel.fromJson(e))
            .toList();
      });

  return stream;
});