import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Home.dart';

class Cart extends StatefulWidget {
  static const String id = 'cart';

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Fetch cart items from the API
  Future<void> _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, 'login');
      return;
    }

    final response = await http.get(
      Uri.parse('https://apexstore.space/api/cart'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['cart_items'] != null && data['cart_items'] is List) {
        setState(() {
          cartItems = List<Map<String, dynamic>>.from(data['cart_items']);
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load cart items')),
      );
    }
  }

  Future<void> _removeItemFromCart(String cartId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, 'login');
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('https://apexstore.space/api/cart/remove/$cartId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems.removeWhere((item) => (item.containsKey('_id') ? item['_id'] : item['id']) == cartId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removed from cart')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove item')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showBillingDetailsDialog(double subtotal, double shippingCost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Billing Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _proceedToPayment();
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _proceedToPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, 'login');
      return;
    }

    if (_fullNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all billing details.')),
      );
      return;
    }

    // Create the request body
    Map<String, dynamic> checkoutData = {
      "full_name": _fullNameController.text,
      "address": _addressController.text,
      "phone": _phoneController.text,
      "shipping_cost": 500.00, // Ensure shipping cost is included
      "callback_url": "https://apexstore.space/api/checkout/success" // Add callback URL
    };

    try {
      final response = await http.post(
        Uri.parse('https://apexstore.space/api/checkout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(checkoutData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        if (responseData['url'] != null) {
          String paymentUrl = responseData['url'];
          print('Payment URL: $paymentUrl'); // Debug log

          // Open the Stripe payment URL
          if (await canLaunch(paymentUrl)) {
            await launch(paymentUrl);

            // Clear the cart items after redirecting to Stripe
            setState(() {
              cartItems.clear();
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Redirected to payment page. Your cart is cleared.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open payment page. Please try again.')),
            );
          }
        } else {
          print('Error: No payment URL received'); // Debug log
          print('Response Data: $responseData'); // Debug log
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment failed: No payment URL received.')),
          );
        }
      } else {
        print('Error: ${response.statusCode}, ${response.body}'); // Debug log
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double shippingCost = 500.00;
    final double subtotal = cartItems.fold(0.0, (sum, item) => sum + (double.tryParse(item['product']['productPrice'].toString()) ?? 0) * item['quantity']);
    final double estimatedTotal = subtotal + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: cartItems.isEmpty
                        ? const Center(child: Text('Your cart is empty!'))
                        : ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              final product = item['product'];
                              final cartId = item.containsKey('_id') ? item['_id'] : item['id'];

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      'https://apexstore.space/images/${product['productImage']}',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    product['productName'],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('\$${product['productPrice']} x ${item['quantity']}'),
                                      if (item['size'] != null) Text('Size: ${item['size']}'),
                                      if (item['color'] != null) Text('Color: ${item['color']}'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeItemFromCart(cartId),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  if (cartItems.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Shipping:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'LKR 500.00',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Estimated Total:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$${estimatedTotal.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _showBillingDetailsDialog(subtotal, shippingCost),
                            child: const Text('Checkout'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

