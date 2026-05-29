import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class WomenScreen extends StatefulWidget {
  const WomenScreen({super.key});

  @override
  State<WomenScreen> createState() => _WomenScreenState();
}

class _WomenScreenState extends State<WomenScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['New Arrivals', 'Bestsellers', 'Dress'];

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
          'Women',
          style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
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
        stream: FirestoreService.streamProductsByCategory('Women'),
        builder: (context, snapshot) {
          final products = snapshot.data ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURATED SELECTION',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGrey,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'New Arrivals',
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 26,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ..._filters.asMap().entries.map((entry) {
                        final i = entry.key;
                        final label = entry.value;
                        final active = _selectedFilter == i;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedFilter = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.accent
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                label,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: active
                                      ? Colors.white
                                      : AppColors.textGrey,
                                  fontSize: 12,
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
                const SizedBox(height: 20),
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
                                height: 280,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0E0E0),
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
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'WISHLISTED',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      products.first.name,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '\$${products.first.price.toStringAsFixed(2)}',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontSize: 16,
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
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: AppColors.accent,
                                size: 18,
                              ),
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
                        child: Column(
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
                                            color: Colors.white54),
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
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '\$${p.price.toStringAsFixed(2)}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A1A6E), Color(0xFF7B3FA0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'THE GALA COLLECTION',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white54,
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Evening Gown',
                        style: AppTextStyles.heading2.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$850.00',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/product_detail');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'QUICK VIEW',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
