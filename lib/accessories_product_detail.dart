import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'cart.dart';
import 'package:clothing_store3/models/cart_model.dart'; // Import the CartItem model
import 'package:clothing_store3/services/cart_service.dart'; // Import the CartService class

class AccessoryProductDetail extends StatefulWidget {
  static const String id = 'AccessoryProductDetail';

  const AccessoryProductDetail({super.key});

  @override
  _AccessoryDetailState createState() => _AccessoryDetailState();
}

class _AccessoryDetailState extends State<AccessoryProductDetail> {
  int _quantity = 1;
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    String imageUrl = args['productImage'];
    bool isNetworkImage = Uri.parse(imageUrl).isAbsolute;

    return Scaffold(
      appBar: AppBar(
        title: Text(args['productName']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: isNetworkImage
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Image.asset(imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            _productDetails(args, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _productDetails(Map<String, dynamic> args, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            args['productName'],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          // Price
          Text(
            '${args['productPrice']}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 10),
          // Product Description
          Text(
            args['productDescription'],
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          // Color Selection
          Text('Color:', style: const TextStyle(fontSize: 16)),
          DropdownButton<String>(
            value: _selectedColor,
            hint: const Text('Choose Color', style: TextStyle(fontSize: 16)),
            onChanged: (String? newValue) {
              setState(() {
                _selectedColor = newValue;
              });
            },
            items: <String>['Red', 'Blue', 'Green', 'Black']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          // Quantity Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quantity:', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                  ),
                  Text('$_quantity', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _addToCart(args['_id']),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(String productId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  if (token == null) {
    Navigator.pushNamed(context, Login.id);
    return;
  }

  if (productId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid product ID")),
    );
    return;
  }

  // Creating CartItem instance for accessories (size is passed as null)
  CartItem cartItem = CartItem(
    productId: productId,
    quantity: _quantity,
    color: _selectedColor ?? "",
    size: null, // Size is null for accessories
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
  );

  // Call the CartService to add the item to the cart
  bool success = await CartService.addToCart(cartItem, 'accessories');

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product added to cart successfully!")),
    );
    // Navigate to the Cart page after successful addition
    Navigator.pushNamed(context, Cart.id);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to add product to cart")),
    );
  }
}
}
