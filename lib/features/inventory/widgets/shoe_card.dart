import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/shoe_model.dart';
import 'sell_shoe_dialog.dart';

class ShoeCard extends StatelessWidget {
  final ShoeModel shoe;

  const ShoeCard({super.key, required this.shoe});

  void _openImage(BuildContext context) {
    if (shoe.imageUrl == null || shoe.imageUrl!.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.black,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 5,
            child: CachedNetworkImage(
              imageUrl: shoe.imageUrl!,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lowStock = shoe.quantity <= 5;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🖼️ BIG IMAGE SECTION (TOP FOCUS)
          GestureDetector(
            onTap: () => _openImage(context),
            child: Hero(
              tag: shoe.id,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: shoe.imageUrl != null && shoe.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: shoe.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image,
                            size: 50,
                          ),
                        ),
                ),
              ),
            ),
          ),

          /// 📦 INFO SECTION
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// NAME + BRAND
                Text(
                  shoe.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  shoe.brand,
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 10),

                /// PILLS
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _pill("Size ${shoe.size}", Colors.grey.shade200),

                    _pill(
                      "Stock ${shoe.quantity}",
                      lowStock ? Colors.red.shade100 : Colors.green.shade100,
                      textColor: lowStock ? Colors.red : Colors.green,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// PRICES
                Text("Buy: ${shoe.buyingPrice} ETB"),
                Text(
                  "Sell: ${shoe.sellingPrice} ETB",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                /// SELL BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => showSellDialog(context, shoe),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Sell"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color bg, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}