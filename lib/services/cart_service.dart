// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/cart_model.dart';

// class CartService {
//   static const String baseUrl = 'https://apexstore.space/api/cart';

//   static Future<Map<String, String>> _getHeaders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('user_token') ?? '';
//     return {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }

//   // Add item to cart
//   static Future<bool> addToCart(CartItem cartItem) async {
//     final headers = await _getHeaders();
//     final response = await http.post(
//       Uri.parse('$baseUrl/add/mens/${cartItem.productId}'),
//       headers: headers,
//       body: jsonEncode(cartItem.toJson()),
//     );

//     print("DEBUG: API Response Status Code: ${response.statusCode}");
//     print("DEBUG: API Response Body: ${response.body}");

//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       // More detailed logging if the request fails
//       print("Failed to add to cart. Response: ${response.body}");
//       return false;
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';

class CartService {
  static const String baseUrl = 'https://apexstore.space/api/cart';

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Add item to cart (for both men's and women's)
  static Future<bool> addToCart(CartItem cartItem, String category) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/add/$category/${cartItem.productId}'),
      headers: headers,
      body: jsonEncode(cartItem.toJson()),
    );

    print("DEBUG: API Response Status Code: ${response.statusCode}");
    print("DEBUG: API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      // More detailed logging if the request fails
      print("Failed to add to cart. Response: ${response.body}");
      return false;
    }
  }
}
