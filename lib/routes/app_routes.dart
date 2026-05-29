import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/checkout/order_confirm_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/orders/order_history_screen.dart';
import '../screens/products/kids_screen.dart';
import '../screens/products/men_screen.dart';
import '../screens/products/product_detail_screen.dart';
import '../screens/products/women_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash/splash_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const SplashScreen(),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/home': (context) => const HomeScreen(),
      '/women': (context) => const WomenScreen(),
      '/men': (context) => const MenScreen(),
      '/kids': (context) => const KidsScreen(),
      '/product_detail': (context) => ProductDetailScreen(
            productId: ModalRoute.of(context)?.settings.arguments as String?,
          ),
      '/cart': (context) => const CartScreen(),
      '/checkout': (context) => const CheckoutScreen(),
      '/order_confirm': (context) => const OrderConfirmScreen(),
      '/order_history': (context) => const OrderHistoryScreen(),
      '/profile': (context) => const ProfileScreen(),
    };
  }
}
