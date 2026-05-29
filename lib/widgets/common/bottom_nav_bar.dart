import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    String routeName;
    switch (index) {
      case 0:
        routeName = '/home';
        break;
      case 1:
        routeName = '/women'; // Using women screen as shop as per simple requirements
        break;
      case 2:
        routeName = '/cart';
        break;
      case 3:
        routeName = '/profile';
        break;
      default:
        routeName = '/home';
    }
    
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: AppColors.accent,
      unselectedItemColor: const Color(0xFFBDBDBD),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
