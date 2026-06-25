import 'package:flutter/material.dart';

import '../../../models/shoe_model.dart';
import '../../../repositories/sales_repository.dart';

Future<void> showSellDialog(BuildContext context, ShoeModel shoe) async {
  final quantityController = TextEditingController(text: '1');

  final sellingPriceController = TextEditingController(
    text: shoe.sellingPrice.toString(),
  );

  bool loading = false;

  int quantity = 1;

  double actualPrice = shoe.sellingPrice;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final total = quantity * actualPrice;

          final profit = (actualPrice - shoe.buyingPrice) * quantity;

          final discount = shoe.sellingPrice - actualPrice;

          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.shopping_cart_checkout),
                const SizedBox(width: 8),
                Expanded(child: Text(shoe.name)),
              ],
            ),

            content: SizedBox(
              width: 350,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Stock: ${shoe.quantity}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Default Price: ${shoe.sellingPrice.toStringAsFixed(0)} ETB",
                    ),

                    Text(
                      "Buying Price: ${shoe.buyingPrice.toStringAsFixed(0)} ETB",
                    ),

                    const SizedBox(height: 16),

                    /// Quantity
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Quantity Sold",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      onChanged: (value) {
                        setState(() {
                          quantity = int.tryParse(value) ?? 1;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    /// Selling Price
                    TextField(
                      controller: sellingPriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Actual Selling Price",
                        prefixText: "ETB ",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.price_change),
                      ),
                      onChanged: (value) {
                        setState(() {
                          actualPrice =
                              double.tryParse(value) ?? shoe.sellingPrice;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Discount"),
                                Text("${discount.toStringAsFixed(0)} ETB"),
                              ],
                            ),

                            const Divider(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total"),
                                Text(
                                  "${total.toStringAsFixed(0)} ETB",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Profit"),
                                Text(
                                  "${profit.toStringAsFixed(0)} ETB",
                                  style: TextStyle(
                                    color: profit >= 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            actions: [
              TextButton(
                onPressed: loading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                child: const Text("Cancel"),
              ),

              ElevatedButton.icon(
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: Text(loading ? "Processing..." : "Complete Sale"),
                onPressed: loading
                    ? null
                    : () async {
                        try {
                          final qty = int.parse(quantityController.text);

                          final soldPrice = double.parse(
                            sellingPriceController.text,
                          );

                          if (qty <= 0) {
                            throw Exception('Quantity must be greater than 0');
                          }

                          if (qty > shoe.quantity) {
                            throw Exception('Not enough stock available');
                          }

                          setState(() {
                            loading = true;
                          });

                          await SalesRepository().sellShoe(
                            shoeId: shoe.id,
                            shoeName: shoe.name,
                            size: shoe.size,
                            currentStock: shoe.quantity,
                            quantity: qty,
                            buyingPrice: shoe.buyingPrice,
                            sellingPrice: soldPrice,
                          );

                          if (!context.mounted) {
                            return;
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${shoe.name} sold successfully"),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
              ),
            ],
          );
        },
      );
    },
  );
}
