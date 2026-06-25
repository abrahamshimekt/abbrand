import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Weekly Sales",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 250,

              child: LineChart(
                LineChartData(
                  borderData:
                      FlBorderData(
                    show: false,
                  ),

                  gridData:
                      FlGridData(
                    show: true,
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,

                      barWidth: 4,

                      spots: const [
                        FlSpot(
                            0, 5),
                        FlSpot(
                            1, 7),
                        FlSpot(
                            2, 4),
                        FlSpot(
                            3, 12),
                        FlSpot(
                            4, 9),
                        FlSpot(
                            5, 15),
                        FlSpot(
                            6, 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}