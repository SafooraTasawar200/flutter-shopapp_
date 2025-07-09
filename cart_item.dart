// lib/cart_item.dart

class CartItem {
  final String productName;
  final String brand;
  final String imageUrl;
  final String color;
  final String price;
  int quantity;
  final String? storage; // Added storage for cart item

  CartItem({
    required this.productName,
    required this.brand,
    required this.imageUrl,
    required this.color,
    required this.price,
    required this.quantity,
    this.storage, // Optional storage
  });

  // Method to convert CartItem to a map for easy printing/debugging
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'brand': brand,
      'imageUrl': imageUrl,
      'color': color,
      'price': price,
      'quantity': quantity,
      'storage': storage,
    };
  }
}