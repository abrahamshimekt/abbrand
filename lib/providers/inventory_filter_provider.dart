import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/inventory_filter.dart';

class InventoryFilterNotifier
    extends Notifier<InventoryFilter> {

  @override
  InventoryFilter build() {
    return const InventoryFilter();
  }

  void updateSearch(String value) {
    state = state.copyWith(
      search: value,
    );
  }

  void updateBrand(String? value) {
    state = state.copyWith(
      brand: value,
    );
  }

  void updateSize(int? value) {
    state = state.copyWith(
      size: value,
    );
  }

  void clear() {
    state = const InventoryFilter();
  }
}

final inventoryFilterProvider =
    NotifierProvider<
        InventoryFilterNotifier,
        InventoryFilter>(
  InventoryFilterNotifier.new,
);