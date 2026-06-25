import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../sales/sales_history_screen.dart';

class HomeScreen
    extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  int currentIndex = 0;

  final pages = const [
    DashboardScreen(),
    InventoryScreen(),
    SalesHistoryScreen(),
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar:
          NavigationBar(
        selectedIndex:
            currentIndex,

        onDestinationSelected:
            (index) {
          setState(() {
            currentIndex =
                index;
          });
        },

        destinations: const [

          NavigationDestination(
            icon:
                Icon(Icons.dashboard),
            label:
                'Dashboard',
          ),

          NavigationDestination(
            icon:
                Icon(Icons.inventory),
            label:
                'Inventory',
          ),

          NavigationDestination(
            icon:
                Icon(Icons.sell),
            label:
                'Sales',
          ),
        ],
      ),
    );
  }
}