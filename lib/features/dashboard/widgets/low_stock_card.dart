import 'package:flutter/material.dart';

class LowStockCard
    extends StatelessWidget {

  final List lowStockShoes;

  const LowStockCard({
    super.key,
    required this.lowStockShoes,
  });

  @override
  Widget build(
      BuildContext context) {

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Low Stock Alert",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            ...lowStockShoes.map(
              (shoe) => ListTile(
                leading:
                    const Icon(
                  Icons.warning,
                ),

                title:
                    Text(shoe.name),

                trailing:
                    Text(
                  shoe.quantity
                      .toString(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}