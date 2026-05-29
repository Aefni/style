class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imagePath;
  final String imageUrl;
  final String description;
  final List<String> sizes;
  final List<String> colors;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    this.imageUrl = '',
    required this.description,
    required this.sizes,
    required this.colors,
  });
}
