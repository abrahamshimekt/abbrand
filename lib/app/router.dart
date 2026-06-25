import 'package:go_router/go_router.dart';
import '../features/inventory/add_shoe_screen.dart';
import '../features/inventory/inventory_screen.dart';
import '../features/navigation/home_screen.dart';
import '../features/sales/sell_shoe_screen.dart';
import '../models/shoe_model.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const InventoryScreen(),
    ),
    GoRoute(
      path: '/add-shoe',
      builder: (context, state) => const AddShoeScreen(),
    ),
    GoRoute(
      path: '/sell-shoe',
      builder: (context, state) {
        return SellShoeScreen(shoe: state.extra as ShoeModel);
      },
    ),
  ],
);
