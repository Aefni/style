import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_strings.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class StyleApp extends StatelessWidget {
  const StyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: AppRoutes.getRoutes(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
