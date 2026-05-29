import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class OrderConfirmScreen extends StatelessWidget {
  const OrderConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Green checkmark
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFF2ECC71),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Order Placed!',
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Thank you for curating with Style.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              // Order ID
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ORDER ID: #SH-9283-XO',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Estimated delivery
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESTIMATED DELIVERY',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10,
                        letterSpacing: 1.5,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          color: Colors.grey[500],
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thursday, Oct 12',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'Standard Boutique Shipping',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Item thumbnails
              Row(
                children: [
                  _thumbnail(const Color(0xFF2D3436)),
                  const SizedBox(width: 8),
                  _thumbnail(const Color(0xFF636E72)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '+1',
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'ITEM',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          letterSpacing: 1.5,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Continue Shopping button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // This securely wipes the checkout navigation stack completely and drops us home!
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/home', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'CONTINUE SHOPPING',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // View Order History button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Go to orders!
                    Navigator.pushReplacementNamed(context, '/orders');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'VIEW ORDER HISTORY',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbnail(Color color) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.checkroom, color: Colors.white38, size: 30),
      ),
    );
  }
}
