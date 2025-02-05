class CartItem {
  final String productId;
  final int quantity;
  final String color;
  final String? size; 
  final String createdAt;
  final String updatedAt;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.color,
    this.size, 
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'color': color,
      'size': size,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
