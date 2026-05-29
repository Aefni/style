import '../models/product_model.dart';

class DummyData {
  static List<Product> womenProducts = [
    Product(id: 'w1', name: 'Floral Midi Dress', category: 'Women', price: 4500, imagePath: 'assets/images/products/women/product_w1.png', description: 'Sample description', sizes: ['S', 'M', 'L'], colors: ['Red', 'Blue']),
    Product(id: 'w2', name: 'Summer Crop Top', category: 'Women', price: 1800, imagePath: 'assets/images/products/women/product_w2.png', description: 'Sample description', sizes: ['S', 'M', 'L'], colors: ['White', 'Black']),
    Product(id: 'w3', name: 'Casual Blazer', category: 'Women', price: 8900, imagePath: 'assets/images/products/women/product_w3.png', description: 'Sample description', sizes: ['S', 'M', 'L'], colors: ['Grey']),
    Product(id: 'w4', name: 'Linen Maxi Skirt', category: 'Women', price: 3100, imagePath: 'assets/images/products/women/product_w4.png', description: 'Sample description', sizes: ['S', 'M', 'L'], colors: ['Beige']),
    Product(id: 'w5', name: 'Silk Scarf Set', category: 'Women', price: 2200, imagePath: 'assets/images/products/women/product_w5.png', description: 'Sample description', sizes: ['Free'], colors: ['Multi']),
    Product(id: 'w6', name: 'Evening Gown', category: 'Women', price: 14500, imagePath: 'assets/images/products/women/product_w6.png', description: 'Sample description', sizes: ['M', 'L'], colors: ['Navy']),
  ];

  static List<Product> menProducts = [
    Product(id: 'm1', name: 'Oxford Slim Shirt', category: 'Men', price: 3200, imagePath: 'assets/images/products/men/product_m1.png', description: 'Sample description', sizes: ['M', 'L', 'XL'], colors: ['Blue', 'White']),
    Product(id: 'm2', name: 'Slim Fit Jeans', category: 'Men', price: 5500, imagePath: 'assets/images/products/men/product_m2.png', description: 'Sample description', sizes: ['32', '34', '36'], colors: ['Blue', 'Black']),
    Product(id: 'm3', name: 'Winter Parka', category: 'Men', price: 12900, imagePath: 'assets/images/products/men/product_m3.png', description: 'Sample description', sizes: ['L', 'XL'], colors: ['Olive']),
    Product(id: 'm4', name: 'Cotton Polo Tee', category: 'Men', price: 1950, imagePath: 'assets/images/products/men/product_m4.png', description: 'Sample description', sizes: ['M', 'L', 'XL'], colors: ['Red', 'Navy']),
    Product(id: 'm5', name: 'Track Joggers', category: 'Men', price: 4100, imagePath: 'assets/images/products/men/product_m5.png', description: 'Sample description', sizes: ['M', 'L'], colors: ['Black', 'Grey']),
    Product(id: 'm6', name: 'Formal Blazer', category: 'Men', price: 11500, imagePath: 'assets/images/products/men/product_m6.png', description: 'Sample description', sizes: ['40', '42'], colors: ['Charcoal']),
  ];

  static List<Product> kidsProducts = [
    Product(id: 'k1', name: 'Denim Dungaree', category: 'Kids', price: 1600, imagePath: 'assets/images/products/kids/product_k1.png', description: 'Sample description', sizes: ['3-4Y', '5-6Y'], colors: ['Blue']),
    Product(id: 'k2', name: 'Floral Frock', category: 'Kids', price: 1200, imagePath: 'assets/images/products/kids/product_k2.png', description: 'Sample description', sizes: ['2-3Y', '4-5Y'], colors: ['Pink']),
    Product(id: 'k3', name: 'Pajama Set', category: 'Kids', price: 950, imagePath: 'assets/images/products/kids/product_k3.png', description: 'Sample description', sizes: ['4-5Y', '6-7Y'], colors: ['Yellow']),
    Product(id: 'k4', name: 'Boys Tee Pack', category: 'Kids', price: 1450, imagePath: 'assets/images/products/kids/product_k4.png', description: 'Sample description', sizes: ['5-6Y', '7-8Y'], colors: ['Assorted']),
    Product(id: 'k5', name: 'Cartoon Socks Set', category: 'Kids', price: 450, imagePath: 'assets/images/products/kids/product_k5.png', description: 'Sample description', sizes: ['Free'], colors: ['Assorted']),
    Product(id: 'k6', name: 'School Backpack', category: 'Kids', price: 2100, imagePath: 'assets/images/products/kids/product_k6.png', description: 'Sample description', sizes: ['Standard'], colors: ['Red', 'Blue']),
  ];
}
