import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning', style: AppTextStyles.bodySmall),
                      Text(
                        'Aefni',
                        style: AppTextStyles.heading2.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: AppColors.textPrimary),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined,
                            color: AppColors.textPrimary),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textGrey),
                    const SizedBox(width: 10),
                    Text(
                      'Search for styles...',
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.refresh,
                            color: Colors.white54, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'NEW ARRIVAL',
                          style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white54, letterSpacing: 1.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Summer Sale',
                      style: AppTextStyles.heading1.copyWith(
                          color: Colors.white, fontSize: 26),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Up to 40% Off Select Styles',
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    'View all',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accent, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategory(
                      context, Icons.woman_outlined, 'WOMEN', '/women'),
                  _buildCategory(
                      context, Icons.man_outlined, 'MEN', '/men'),
                  _buildCategory(
                      context, Icons.face_outlined, 'KIDS', '/kids'),
                  _buildCategory(
                      context, Icons.diamond_outlined, 'LUXURY', null),
                  _buildCategory(
                      context, Icons.watch_outlined, 'ACCE', null),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Featured Collection',
                style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(height: 14),
              StreamBuilder<List<Product>>(
                stream: FirestoreService.streamProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final products = snapshot.data ?? [];
                  final featured =
                      products.length >= 2 ? products.take(2).toList() : products;
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                    children: featured.map((p) => _buildProductCard(context, p)).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildCategory(
    BuildContext context,
    IconData icon,
    String label,
    String? routeName,
  ) {
    return GestureDetector(
      onTap: () {
        if (routeName != null) {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final hasImage = product.imageUrl.isNotEmpty;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product_detail',
            arguments: product.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
          image: hasImage
              ? DecorationImage(
                  image: NetworkImage(product.imageUrl), fit: BoxFit.cover)
              : null,
        ),
        child: hasImage
            ? Stack(
                children: [
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        product.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          shadows: const [
                            Shadow(blurRadius: 4, color: Colors.black54)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: AppColors.surface, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border,
                          size: 16, color: AppColors.textGrey),
                    ),
                  ),
                ],
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 48, color: Colors.white54),
                ),
              ),
      ),
    );
  }
}
