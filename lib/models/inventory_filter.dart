class InventoryFilter {
  final String search;
  final String? brand;
  final int? size;

  const InventoryFilter({
    this.search = '',
    this.brand,
    this.size,
  });

  InventoryFilter copyWith({
    String? search,
    String? brand,
    int? size,
    bool clearBrand = false,
    bool clearSize = false,
  }) {
    return InventoryFilter(
      search: search ?? this.search,
      brand: clearBrand ? null : (brand ?? this.brand),
      size: clearSize ? null : (size ?? this.size),
    );
  }
}