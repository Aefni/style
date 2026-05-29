import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/firestore_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPayment = 0;

  final _nameController = TextEditingController(text: 'Julianne Moore');
  final _phoneController = TextEditingController(text: '+1(555)000-0000');
  final _addressController =
      TextEditingController(text: '742 Evergreen Terrace');
  final _cityController = TextEditingController(text: 'Springfield');
  final _postalController = TextEditingController(text: '62704');

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
        title: Text(
          'Checkout',
          style:
              AppTextStyles.heading2.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
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
          final cartDocs = snapshot.data?.docs ?? [];
          double subtotal = 0;
          for (var doc in cartDocs) {
            final d = doc.data() as Map<String, dynamic>;
            subtotal +=
                (d['price'] ?? 0).toDouble() * (d['quantity'] ?? 1).toDouble();
          }
          final shipping = 0.0;
          final tax = subtotal * 0.08;
          final total = subtotal + shipping + tax;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Details',
                                  style: AppTextStyles.heading2.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Icon(Icons.local_shipping_outlined,
                                    color: AppColors.textGrey),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildField('FULL NAME', _nameController),
                            const SizedBox(height: 16),
                            _buildField('PHONE NUMBER', _phoneController,
                                keyboardType: TextInputType.phone),
                            const SizedBox(height: 16),
                            _buildField(
                                'SHIPPING ADDRESS', _addressController),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildField('CITY', _cityController),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildField(
                                      'POSTAL CODE', _postalController,
                                      keyboardType: TextInputType.number),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment Method',
                                  style: AppTextStyles.heading2.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Icon(Icons.payment_outlined,
                                    color: AppColors.textGrey),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildPaymentOption(
                              index: 0,
                              icon: Icons.payments_outlined,
                              iconColor: AppColors.accent,
                              title: 'Cash on Delivery',
                              subtitle: 'Pay when you receive',
                            ),
                            const Divider(
                                height: 24, color: AppColors.border),
                            _buildPaymentOption(
                              index: 1,
                              icon: Icons.credit_card_outlined,
                              iconColor: AppColors.textGrey,
                              title: 'Credit Card',
                              subtitle: 'Secure checkout',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () async {
                            final address =
                                '${_addressController.text}, ${_cityController.text}, ${_postalController.text}';
                            final items = cartDocs.map((doc) {
                              final d = doc.data() as Map<String, dynamic>;
                              return {
                                'productId': d['productId'] ?? '',
                                'name': d['name'] ?? '',
                                'price': d['price'] ?? 0,
                                'quantity': d['quantity'] ?? 1,
                                'selectedSize': d['selectedSize'] ?? '',
                                'selectedColor': d['selectedColor'] ?? '',
                                'imageUrl': d['imageUrl'] ?? '',
                              };
                            }).toList();

                            await FirestoreService.placeOrder(
                              items: items,
                              total: total,
                              deliveryAddress: address,
                              paymentMethod:
                                  _selectedPayment == 0 ? 'COD' : 'Credit Card',
                            );

                            await FirestoreService.clearCart();

                            if (context.mounted) {
                              Navigator.pushNamed(context, '/order_confirm');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'PLACE ORDER',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _summaryRow(
                                'Subtotal (${cartDocs.length} items)',
                                '\$${subtotal.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _summaryRow('Shipping', 'Free'),
                            const SizedBox(height: 8),
                            _summaryRow(
                                'Estimated tax',
                                '\$${tax.toStringAsFixed(2)}'),
                            const Divider(
                                height: 20, color: AppColors.border),
                            _summaryRow(
                                'Total Amount',
                                '\$${total.toStringAsFixed(2)}',
                                bold: true,
                                pink: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 14, color: AppColors.primary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final selected = _selectedPayment == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = index),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color:
                        selected ? AppColors.primary : AppColors.textGrey,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: selected ? AppColors.accent : AppColors.textGrey,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
    bool pink = false,
  }) {
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
            color: pink ? AppColors.accent : AppColors.primary,
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            fontSize: bold ? 16 : 13,
          ),
        ),
      ],
    );
  }
}
