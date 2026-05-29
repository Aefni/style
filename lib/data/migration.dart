import 'package:cloud_firestore/cloud_firestore.dart';
import 'dummy_data.dart';

Future<void> migrateProductsToFirestore() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  final allProducts = [
    ...DummyData.womenProducts,
    ...DummyData.menProducts,
    ...DummyData.kidsProducts,
  ];

  for (final product in allProducts) {
    final docRef = firestore.collection('products').doc(product.id);
    batch.set(docRef, {
      'name': product.name,
      'category': product.category,
      'price': product.price,
      'imagePath': product.imagePath,
      'imageUrl': '',
      'description': product.description,
      'sizes': product.sizes,
      'colors': product.colors,
    });
  }

  await batch.commit();
  print('Migration complete');
}
