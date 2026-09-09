class Product {
  final int id;
  final String name;
  final double price;
  final double oldPrice;
  final int discount;
  final double rating;
  final int reviewCount;
  final String category;
  final String imageUrl;
  final String description;
  final List<String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.specs,
  });
}
