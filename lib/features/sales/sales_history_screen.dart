import 'package:flutter/material.dart';
import '../../repositories/sales_repository.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  late Future<List<Map<String, dynamic>>> salesFuture;

  @override
  void initState() {
    super.initState();
    salesFuture = SalesRepository().getSales();
  }

  Future<void> refresh() async {
    setState(() {
      salesFuture = SalesRepository().getSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("POS Analytics"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: salesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final sales = snapshot.data ?? [];

          if (sales.isEmpty) {
            return const Center(child: Text("No sales data"));
          }

          /// 📊 METRICS CALCULATION
          final totalSales = sales.fold<double>(
            0,
            (sum, e) => sum + (e['total_amount'] as num).toDouble(),
          );

          final totalProfit = sales.fold<double>(
            0,
            (sum, e) => sum + (e['profit'] as num).toDouble(),
          );

          final totalOrders = sales.length;

          final avgOrderValue = totalOrders == 0 ? 0 : totalSales / totalOrders;

          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                /// 🧠 HEADER INSIGHT
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Business Overview",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        _getInsight(totalProfit, totalSales),
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// 📊 KPI DASHBOARD
                Row(
                  children: [
                    _kpiCard(
                      title: "Sales",
                      value: "${totalSales.toStringAsFixed(0)} ETB",
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    _kpiCard(
                      title: "Profit",
                      value: "${totalProfit.toStringAsFixed(0)} ETB",
                      color: Colors.green,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    _kpiCard(
                      title: "Orders",
                      value: "$totalOrders",
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    _kpiCard(
                      title: "Avg Order",
                      value: "${avgOrderValue.toStringAsFixed(0)} ETB",
                      color: Colors.purple,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// 📊 TABLE HEADER
                const Text(
                  "Sales Ledger",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                /// 📋 TABLE
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey.shade200,
                      ),
                      columns: const [
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Shoe")),
                        DataColumn(label: Text("Qty")),
                        DataColumn(label: Text("Total")),
                        DataColumn(label: Text("Profit")),
                      ],
                      rows: sales.map((sale) {
                        final profit = (sale['profit'] as num).toDouble();

                        final date =
                            sale['sold_at']?.toString().substring(0, 10) ?? "";

                        return DataRow(
                          cells: [
                            DataCell(Text(date)),
                            DataCell(Text(sale['shoe_name'] ?? "")),
                            DataCell(Text("${sale['quantity']}")),
                            DataCell(Text("${sale['total_amount']} ETB")),
                            DataCell(
                              Text(
                                "${profit.toStringAsFixed(0)} ETB",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: profit >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🧠 SMART INSIGHT TEXT
  String _getInsight(double profit, double sales) {
    if (profit > sales * 0.3) {
      return "🔥 High profit performance this period.";
    } else if (profit > 0) {
      return "📈 Stable sales with positive profit.";
    } else {
      return "⚠️ Low profit margin detected.";
    }
  }

  /// 📊 KPI CARD
  Widget _kpiCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
