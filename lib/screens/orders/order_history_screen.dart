import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/firestore_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.streamOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('No orders yet', style: AppTextStyles.bodyLarge),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final data = orders[index].data() as Map<String, dynamic>;
              final items = data['items'] as List<dynamic>? ?? [];
              final total = data['total'] ?? 0;
              final status = data['status'] ?? 'Processing';
              final date = data['orderDate'] != null
                  ? (data['orderDate'] as Timestamp).toDate()
                  : DateTime.now();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${date.day}/${date.month}/${date.year}',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textGrey),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: status == 'Processing'
                                  ? Colors.orange.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: status == 'Processing'
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${items.length} item(s)',
                        style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${(total).toStringAsFixed(2)}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
