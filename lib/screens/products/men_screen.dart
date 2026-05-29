import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class MenScreen extends StatefulWidget {
  const MenScreen({super.key});

  @override
  State<MenScreen> createState() => _MenScreenState();
}

class _MenScreenState extends State<MenScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Casual', 'Formal', 'Outerwear'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const BackButton(color: AppColors.textPrimary)
            : null,
        title: Text(
          'Men',
          style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/cart'),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: FirestoreService.streamProductsByCategory('Men'),
        builder: (context, snapshot) {
          final products = snapshot.data ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ..._filters.asMap().entries.map((entry) {
                        final active = _selectedFilter == entry.key;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedFilter = entry.key),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.accent
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                entry.value,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: active
                                      ? Colors.white
                                      : AppColors.textGrey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (products.isNotEmpty)
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, '/product_detail',
                        arguments: products.first.id),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 260,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCFE2F3),
                                  image: products.first.imageUrl.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              products.first.imageUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: products.first.imageUrl.isEmpty
                                    ? const Center(
                                        child: Icon(Icons.image,
                                            size: 64,
                                            color: Colors.white54),
                                      )
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          products.first.name,
                                          style: AppTextStyles.bodyLarge
                                              .copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'HERITAGE COLLECTION',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\$${products.first.price.toStringAsFixed(2)}',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite_border,
                                  size: 18, color: AppColors.textGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    final hasImage = p.imageUrl.isNotEmpty;
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, '/product_detail',
                          arguments: p.id),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      image: hasImage
                                          ? DecorationImage(
                                              image: NetworkImage(p.imageUrl),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        topRight: Radius.circular(14),
                                      ),
                                    ),
                                    child: hasImage
                                        ? null
                                        : const Center(
                                            child: Icon(Icons.image,
                                                size: 50,
                                                color: Colors.white38),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '\$${p.price.toStringAsFixed(2)}',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.favorite_border,
                                    size: 16, color: AppColors.textGrey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, '/product_detail'),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B8DB8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Formal Blazer',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      'BLACK LABEL COLLECTION',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontSize: 9,
                                        letterSpacing: 1.5,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '\$350.00',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
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
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
