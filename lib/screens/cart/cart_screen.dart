import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/firestore_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();

  double _subtotal(List<QueryDocumentSnapshot> docs) {
    double total = 0;
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      total += (data['price'] ?? 0).toDouble() * (data['quantity'] ?? 1).toDouble();
    }
    return total;
  }

  double get _shipping => 12.00;
  double _total(List<QueryDocumentSnapshot> docs) => _subtotal(docs) + _shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const BackButton(color: AppColors.primary)
            : null,
        title: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService.streamCart(),
          builder: (context, snapshot) {
            final count = snapshot.data?.docs.length ?? 0;
            return Text(
              'My Cart ($count)',
              style: AppTextStyles.heading2.copyWith(
                  fontWeight: FontWeight.w600),
            );
          },
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.shopping_bag_outlined,
                color: AppColors.primary),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.streamCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartDocs = snapshot.data?.docs ?? [];

          if (cartDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Your cart is empty',
                      style: AppTextStyles.bodyLarge),
                ],
              ),
            );
          }

          final subtotal = _subtotal(cartDocs);
          final total = _total(cartDocs);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...cartDocs.asMap().entries.map((entry) {
                        final doc = entry.value;
                        final data = doc.data() as Map<String, dynamic>;
                        final itemId = doc.id;
                        final imageUrl = data['imageUrl'] ?? '';
                        final hasImage = imageUrl.isNotEmpty;

                        return Dismissible(
                          key: Key(itemId),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            color: Colors.red.shade100,
                            child: const Icon(Icons.delete_outline,
                                color: Colors.red),
                          ),
                          onDismissed: (_) {
                            FirestoreService.removeFromCart(itemId);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    image: hasImage
                                        ? DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: hasImage
                                      ? null
                                      : const Center(
                                          child: Icon(Icons.checkroom,
                                              size: 36,
                                              color: Colors.white54),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? '',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Size: ${data['selectedSize'] ?? ''} • Color: ${data['selectedColor'] ?? ''}',
                                        style: AppTextStyles.bodySmall
                                            .copyWith(
                                          fontSize: 11,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '\$${(data['price'] ?? 0).toStringAsFixed(2)}',
                                        style: AppTextStyles.bodyLarge
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    _qtyBtn(Icons.remove, () {
                                      final qty = data['quantity'] ?? 1;
                                      if (qty <= 1) {
                                        FirestoreService.removeFromCart(
                                            itemId);
                                      } else {
                                        FirestoreService.updateCartQuantity(
                                            itemId, qty - 1);
                                      }
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        '${data['quantity'] ?? 1}',
                                        style: AppTextStyles.bodyLarge
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    _qtyBtn(Icons.add, () {
                                      final qty = data['quantity'] ?? 1;
                                      FirestoreService.updateCartQuantity(
                                          itemId, qty + 1);
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _promoController,
                                decoration: InputDecoration(
                                  hintText: 'Promo Code',
                                  hintStyle: AppTextStyles.bodyMedium
                                      .copyWith(color: AppColors.textGrey),
                                  border: InputBorder.none,
                                ),
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              child: Text(
                                'APPLY',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Summary',
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _summaryRow(
                                'Subtotal',
                                '\$${subtotal.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _summaryRow(
                                'Shipping',
                                '\$${_shipping.toStringAsFixed(2)}'),
                            const Divider(
                                height: 20, color: AppColors.border),
                            _summaryRow(
                                'Total',
                                '\$${total.toStringAsFixed(2)}',
                                bold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'PROCEED TO CHECKOUT →',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: bold ? AppColors.primary : AppColors.textGrey,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 15 : 13,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primary,
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            fontSize: bold ? 15 : 13,
          ),
        ),
      ],
    );
  }
}
