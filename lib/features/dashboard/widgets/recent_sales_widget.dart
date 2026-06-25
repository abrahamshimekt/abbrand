import 'package:flutter/material.dart';

class RecentSalesWidget
    extends StatelessWidget {

  final List sales;

  const RecentSalesWidget({
    super.key,
    required this.sales,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              'Recent Sales',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            ...sales.take(5).map(
              (sale) => ListTile(
                contentPadding:
                    EdgeInsets.zero,
                title: Text(
                  '${sale['total_amount']} ETB',
                ),
                subtitle: Text(
                  'Profit: ${sale['profit']}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}