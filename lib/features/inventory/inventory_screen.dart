import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/inventory_provider.dart';
import '../../providers/inventory_filter_provider.dart';
import '../inventory/widgets/shoe_card.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  Timer? _debounce;

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(inventoryFilterProvider.notifier).updateSearch(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shoes = ref.watch(inventoryProvider); // 🔥 STREAM (REAL-TIME)
    final filter = ref.watch(inventoryFilterProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// APP BAR
      appBar: AppBar(
        title: const Text("Inventory"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      /// FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-shoe'),
        icon: const Icon(Icons.add),
        label: const Text("Add Shoe"),
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search shoes...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// FILTERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                /// BRAND FILTER
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    initialValue: filter.brand,
                    decoration: const InputDecoration(
                      labelText: "Brand",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text("All Brands")),
                      DropdownMenuItem(value: "Nike", child: Text("Nike")),
                      DropdownMenuItem(value: "Adidas", child: Text("Adidas")),
                      DropdownMenuItem(value: "Puma", child: Text("Puma")),
                    ],
                    onChanged: (value) {
                      ref
                          .read(inventoryFilterProvider.notifier)
                          .updateBrand(value);
                    },
                  ),
                ),

                const SizedBox(width: 10),

                /// SIZE FILTER
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    initialValue: filter.size,
                    decoration: const InputDecoration(
                      labelText: "Size",
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text("All Sizes")),
                      ...List.generate(
                        15,
                        (i) => DropdownMenuItem(
                          value: 35 + i,
                          child: Text("${35 + i}"),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      ref
                          .read(inventoryFilterProvider.notifier)
                          .updateSize(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// LIST (REAL-TIME STREAM)
          Expanded(
            child: shoes.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),

              error: (e, _) =>
                  Center(child: Text("Error: ${e.toString()}")),

              data: (items) {
                final filtered = items.where((shoe) {
                  final matchesSearch =
                      filter.search.isEmpty ||
                      shoe.name.toLowerCase().contains(
                        filter.search.toLowerCase(),
                      );

                  final matchesBrand =
                      filter.brand == null ||
                      shoe.brand == filter.brand;

                  final matchesSize =
                      filter.size == null ||
                      shoe.size == filter.size.toString();

                  return matchesSearch &&
                      matchesBrand &&
                      matchesSize;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "No shoes found",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return ShoeCard(
                      shoe: filtered[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}