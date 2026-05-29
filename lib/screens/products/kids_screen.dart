import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class KidsScreen extends StatefulWidget {
  const KidsScreen({super.key});

  @override
  State<KidsScreen> createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All Items', 'Boys', 'Girls', 'Toddler'];

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
          'Kids',
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
        stream: FirestoreService.streamProductsByCategory('Kids'),
        builder: (context, snapshot) {
          final products = snapshot.data ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D3A2E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Curated Joy',
                      style: AppTextStyles.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.asMap().entries.map((entry) {
                      final active = _selectedFilter == entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedFilter = entry.key),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 9),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
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
                    }).toList(),
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
                                height: 220,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5D5C5),
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
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Classic Indigo Wash',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                            fontSize: 12,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\$${products.first.price.toStringAsFixed(2)}',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontSize: 17,
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
                                                size: 48,
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
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
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
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Color(0xFFCFD8DC),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'School',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'Backpack',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$55.00',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
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
