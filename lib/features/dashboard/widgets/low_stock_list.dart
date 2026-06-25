import 'package:flutter/material.dart';

class LowStockList
    extends StatelessWidget {

  final List shoes;

  const LowStockList({
    super.key,
    required this.shoes,
  });

  @override
  Widget build(BuildContext context) {

    if (shoes.isEmpty) {
      return const Card(
        child: Padding(
          padding:
              EdgeInsets.all(16),
          child: Text(
            'No low stock items',
          ),
        ),
      );
    }

    return Column(
      children: shoes.map((shoe) {

        return Card(
          child: ListTile(
            leading:
                const Icon(
              Icons.warning,
            ),
            title:
                Text(
              shoe['name'],
            ),
            subtitle:
                Text(
              'Remaining: ${shoe['quantity']}',
            ),
          ),
        );
      }).toList(),
    );
  }
}