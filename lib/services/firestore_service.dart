import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  static Future<List<Product>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Product(
        id: doc.id,
        name: data['name'] ?? '',
        category: data['category'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
        imagePath: data['imagePath'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        description: data['description'] ?? '',
        sizes: List<String>.from(data['sizes'] ?? []),
        colors: List<String>.from(data['colors'] ?? []),
      );
    }).toList();
  }

  static Stream<List<Product>> streamProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          category: data['category'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          imagePath: data['imagePath'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          description: data['description'] ?? '',
          sizes: List<String>.from(data['sizes'] ?? []),
          colors: List<String>.from(data['colors'] ?? []),
        );
      }).toList();
    });
  }

  static Stream<List<Product>> streamProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          category: data['category'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          imagePath: data['imagePath'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          description: data['description'] ?? '',
          sizes: List<String>.from(data['sizes'] ?? []),
          colors: List<String>.from(data['colors'] ?? []),
        );
      }).toList();
    });
  }

  static Future<Product?> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imagePath: data['imagePath'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      sizes: List<String>.from(data['sizes'] ?? []),
      colors: List<String>.from(data['colors'] ?? []),
    );
  }

  static Future<void> addToCart({
    required String productId,
    required String name,
    required double price,
    required String imageUrl,
    required String selectedSize,
    required String selectedColor,
    int quantity = 1,
  }) async {
    final uid = _userId;
    if (uid == null) return;

    final cartRef = _firestore.collection('users').doc(uid).collection('cart');
    final existing = await cartRef.where('productId', isEqualTo: productId).where('selectedSize', isEqualTo: selectedSize).where('selectedColor', isEqualTo: selectedColor).get();

    if (existing.docs.isNotEmpty) {
      await existing.docs.first.reference.update({
        'quantity': FieldValue.increment(quantity),
      });
    } else {
      await cartRef.add({
        'productId': productId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'selectedSize': selectedSize,
        'selectedColor': selectedColor,
        'quantity': quantity,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> removeFromCart(String cartItemId) async {
    final uid = _userId;
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(cartItemId)
        .delete();
  }

  static Future<void> updateCartQuantity(String cartItemId, int quantity) async {
    final uid = _userId;
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(cartItemId)
        .update({'quantity': quantity});
  }

  static Stream<QuerySnapshot> streamCart() {
    final uid = _userId;
    if (uid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .orderBy('addedAt', descending: true)
        .snapshots();
  }

  static Future<void> clearCart() async {
    final uid = _userId;
    if (uid == null) return;
    final cartItems = await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();
    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }

  static Future<void> placeOrder({
    required List<Map<String, dynamic>> items,
    required double total,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    final uid = _userId;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).collection('orders').add({
      'items': items,
      'total': total,
      'status': 'Processing',
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'orderDate': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> streamOrders() {
    final uid = _userId;
    if (uid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots();
  }

  static Future<void> saveUserProfile({
    required String name,
    required String email,
    String phone = '',
    String avatarUrl = '',
  }) async {
    final uid = _userId;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
    }, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final uid = _userId;
    if (uid == null) return null;
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  static Stream<DocumentSnapshot> streamUserProfile() {
    final uid = _userId;
    if (uid == null) return const Stream.empty();
    return _firestore.collection('users').doc(uid).snapshots();
  }
}
