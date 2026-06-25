import 'package:flutter/material.dart';
import '../../models/shoe_model.dart';
import '../../repositories/sales_repository.dart';

class SellShoeScreen extends StatefulWidget {
  final ShoeModel shoe;

  const SellShoeScreen({super.key, required this.shoe});

  @override
  State<SellShoeScreen> createState() => _SellShoeScreenState();
}

class _SellShoeScreenState extends State<SellShoeScreen> {
  final qtyController = TextEditingController(text: '1');

  bool loading = false;

  Future<void> completeSale() async {
    try {
      final qty = int.tryParse(qtyController.text) ?? 0;

      if (qty <= 0) {
        throw Exception('Quantity must be greater than 0');
      }

      if (qty > widget.shoe.quantity) {
        throw Exception('Not enough stock');
      }

      setState(() => loading = true);

      await SalesRepository().sellShoe(
        shoeId: widget.shoe.id,
        shoeName: widget.shoe.name,
        size: widget.shoe.size,
        currentStock: widget.shoe.quantity,
        quantity: qty,
        buyingPrice: widget.shoe.buyingPrice,
        sellingPrice: widget.shoe.sellingPrice,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sale completed successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profit = widget.shoe.sellingPrice - widget.shoe.buyingPrice;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Sell Shoe"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// SHOE INFO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shoe.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Brand: ${widget.shoe.brand}",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    children: [
                      _pill("Stock: ${widget.shoe.quantity}", Colors.blue),
                      _pill("Size: ${widget.shoe.size}", Colors.grey),
                      _pill(
                        "Profit: ${profit.toStringAsFixed(0)} ETB",
                        profit > 0 ? Colors.green : Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Selling Price: ${widget.shoe.sellingPrice} ETB",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// QUANTITY INPUT CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quantity to Sell",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter quantity",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      prefixIcon: const Icon(Icons.shopping_cart),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Max available: ${widget.shoe.quantity}",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// SELL BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: loading ? null : completeSale,
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(
                  loading ? "Processing..." : "Complete Sale",
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
