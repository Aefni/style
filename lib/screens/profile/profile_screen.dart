import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.person_outline,
        'label': 'Edit Profile',
        'pink': false,
        'route': '',
      },
      {
        'icon': Icons.receipt_long_outlined,
        'label': 'My Orders',
        'pink': false,
        'route': '/orders',
      },
      {
        'icon': Icons.favorite_border,
        'label': 'Wishlist',
        'pink': false,
        'route': '',
      },
      {
        'icon': Icons.location_on_outlined,
        'label': 'Saved Addresses',
        'pink': false,
        'route': '',
      },
      {
        'icon': Icons.notifications_outlined,
        'label': 'Notifications',
        'pink': false,
        'route': '',
      },
      {
        'icon': Icons.lock_outline,
        'label': 'Change Password',
        'pink': false,
        'route': '',
      },
      {
        'icon': Icons.info_outline,
        'label': 'About',
        'pink': false,
        'route': '',
      },
      {
        'icon': Icons.logout,
        'label': 'Logout',
        'pink': true,
        'route': '/login',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 220,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1A0A0A),
                              Color(0xFF3D2B1A),
                              Color(0xFF1A0A1E),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    }
                                  },
                                ),
                                const Text(
                                  'Style',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Colors.white),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 28,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirestoreService.streamUserProfile(),
                            builder: (context, snapshot) {
                              String displayName = 'Aefni';
                              if (snapshot.hasData &&
                                  snapshot.data!.exists) {
                                final data = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                displayName =
                                    data['name'] ?? displayName;
                              }
                              return Text(
                                displayName,
                                style: AppTextStyles.heading1.copyWith(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children:
                          menuItems.asMap().entries.map((entry) {
                        final i = entry.key;
                        final item = entry.value;
                        final isPink = item['pink'] as bool;
                        final isLast = i == menuItems.length - 1;
                        final route = item['route'] as String;

                        return Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                if (route == '/login') {
                                  await AuthService.logout();
                                  if (context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      route,
                                      (r) => false,
                                    );
                                  }
                                } else if (route.isNotEmpty) {
                                  Navigator.pushNamed(context, route);
                                }
                              },
                              borderRadius:
                                  BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: isPink
                                            ? AppColors.accent
                                                .withValues(alpha: 0.1)
                                            : AppColors.background,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        size: 18,
                                        color: isPink
                                            ? AppColors.accent
                                            : AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        item['label'] as String,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: isPink
                                              ? AppColors.accent
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: isPink
                                          ? AppColors.accent
                                          : AppColors.textGrey,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (!isLast)
                              const Divider(
                                height: 1,
                                indent: 68,
                                endIndent: 16,
                                color: AppColors.border,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1A1A2E),
                            Color(0xFF3D1A5E)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Elite Membership',
                            style: AppTextStyles.heading2.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Enjoy exclusive early access\nto curated drops.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'COMING SOON',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          const BottomNavBar(currentIndex: 2), // Profile index
    );
  }
}
