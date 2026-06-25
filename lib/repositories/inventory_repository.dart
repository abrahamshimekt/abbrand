import '../models/shoe_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  /// 📦 GET ACTIVE SHOES (used only if needed manually)
  Future<List<ShoeModel>> getShoes() async {
    final data = await supabase
        .from('shoes')
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => ShoeModel.fromJson(e))
        .toList();
  }

  /// ➕ ADD SHOE
  Future<void> addShoe(Map<String, dynamic> shoe) async {
    await supabase.from('shoes').insert({
      ...shoe,
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// ✏️ UPDATE
  Future<void> updateShoe(String id, Map<String, dynamic> data) async {
    await supabase.from('shoes').update(data).eq('id', id);
  }

  /// ❌ SOFT DELETE
  Future<void> deactivateShoe(String id) async {
    await supabase.from('shoes').update({
      'is_active': false,
    }).eq('id', id);
  }

  /// 🗑 HARD DELETE
  Future<void> deleteShoe(String id) async {
    await supabase.from('shoes').delete().eq('id', id);
  }
}