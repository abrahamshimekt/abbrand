import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_provider.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/summary_cards.dart';
import 'widgets/sales_chart.dart';
import 'widgets/top_products_chart.dart';

class DashboardScreen
    extends ConsumerWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final dashboard =
        ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor:
          const Color(0xfff5f6fa),

      body: SafeArea(
        child: dashboard.when(
          loading: () =>
              const Center(
            child:
                CircularProgressIndicator(),
          ),

          error: (e, _) =>
              Center(
            child: Text(
              e.toString(),
            ),
          ),

          data: (data) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(
                  dashboardProvider,
                );
              },

              child:
                  SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding:
                    const EdgeInsets.all(
                  16,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    const DashboardHeader(),

                    const SizedBox(
                      height: 24,
                    ),

                    GridView.builder(
                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      itemCount: 4,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            2,

                        crossAxisSpacing:
                            12,

                        mainAxisSpacing:
                            12,

                        childAspectRatio:
                            1.05,
                      ),

                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        final cards = [
                          SummaryCard(
                            title:
                                'Stock',
                            value: data
                                .totalStock
                                .toString(),
                            icon: Icons
                                .inventory_2,
                          ),

                          SummaryCard(
                            title:
                                'Revenue',
                            value:
                                '${data.totalRevenue.toStringAsFixed(0)} ETB',
                            icon: Icons
                                .payments,
                          ),

                          SummaryCard(
                            title:
                                'Profit',
                            value:
                                '${data.totalProfit.toStringAsFixed(0)} ETB',
                            icon: Icons
                                .trending_up,
                          ),

                          SummaryCard(
                            title:
                                'Inventory',
                            value:
                                '${data.totalInventoryValue.toStringAsFixed(0)} ETB',
                            icon:
                                Icons.store,
                          ),
                        ];

                        return cards[index];
                      },
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    const SalesChart(),

                    const SizedBox(
                      height: 24,
                    ),

                    const TopProductsChart(),

                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}