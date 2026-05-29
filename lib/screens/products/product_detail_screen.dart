import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../services/firestore_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productId;
  const ProductDetailScreen({super.key, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSize = 0;
  final int _selectedColor = 0;
  int _quantity = 1;

  Product? _product;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    if (widget.productId == null) return;
    final product = await FirestoreService.getProductById(widget.productId!);
    if (mounted) {
      setState(() => _product = product ?? _fallbackProduct());
    }
  }

  Product _fallbackProduct() {
    return Product(
      id: 'unknown',
      name: 'Product',
      category: '',
      price: 0,
      imagePath: '',
      description: 'Product details not available.',
      sizes: ['S', 'M', 'L'],
      colors: ['Red'],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final p = _product!;
    final sizes = p.sizes.isNotEmpty ? p.sizes : ['S', 'M', 'L'];
    final hasImage = p.imageUrl.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 360,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          image: hasImage
                              ? DecorationImage(
                                  image: NetworkImage(p.imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: hasImage
                            ? null
                            : const Center(
                                child: Icon(Icons.image,
                                    size: 80, color: Colors.white54),
                              ),
                      ),
                      Positioned(
                        top: 48,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back,
                                color: AppColors.primary, size: 20),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 48,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.favorite,
                              color: AppColors.accent, size: 20),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                p.name,
                                style: AppTextStyles.heading2.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Rs. ${p.price.toStringAsFixed(0)}',
                                  style: AppTextStyles.heading2.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                                Text(
                                  'Rs. ${(p.price * 1.33).toStringAsFixed(0)}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '4.2',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(128 Reviews)',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p.description.isNotEmpty
                              ? p.description
                              : 'Premium quality product. Crafted from finest materials.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textGrey,
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SIZE',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: 11,
                                      letterSpacing: 1.5,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: sizes
                                        .asMap()
                                        .entries
                                        .map((e) {
                                          final active =
                                              _selectedSize == e.key;
                                          return GestureDetector(
                                            onTap: () => setState(
                                                () => _selectedSize = e.key),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: active
                                                    ? AppColors.primary
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: active
                                                      ? AppColors.primary
                                                      : Colors.grey.shade300,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  e.value,
                                                  style: AppTextStyles
                                                      .bodyMedium
                                                      .copyWith(
                                                    color: active
                                                        ? Colors.white
                                                        : AppColors.textGrey,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'QUANTITY',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 11,
                                    letterSpacing: 1.5,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _qtyButton(Icons.remove, () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                      }
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        '$_quantity',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    _qtyButton(
                                      Icons.add,
                                      () => setState(() => _quantity++),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Delivery time',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 11,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                Text(
                                  '2 - 4 Days',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TOTAL PRICE',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textGrey,
                      ),
                    ),
                    Text(
                      'Rs. ${(p.price * _quantity).toStringAsFixed(0)}',
                      style: AppTextStyles.heading2.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final size = sizes[_selectedSize];
                    final color =
                        p.colors.isNotEmpty ? p.colors[_selectedColor] : '';
                    await FirestoreService.addToCart(
                      productId: p.id,
                      name: p.name,
                      price: p.price,
                      imageUrl: p.imageUrl,
                      selectedSize: size,
                      selectedColor: color,
                      quantity: _quantity,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Added to Cart!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          action: SnackBarAction(
                            label: 'VIEW',
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, '/cart');
                            },
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.shopping_bag_outlined,
                      size: 18, color: Colors.white),
                  label: Text(
                    'ADD TO CART',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}
