import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'women_product_detail.dart';

class Womens extends StatefulWidget {
  static const String id = 'Womens';

  @override
  _WomensState createState() => _WomensState();
}

class _WomensState extends State<Womens> {
  List<dynamic> _womensProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWomensProducts();
  }

  Future<void> _fetchWomensProducts() async {
    final url = Uri.parse('https://apexstore.space/api/products');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _womensProducts = data["data"]
              .where((product) => product["category"] == "Women")
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (error) {
      print("Error fetching products: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/womens_banner.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Exclusive Women\'s Collection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text: 'Offers ',
                        style: TextStyle(color: Colors.orange)),
                    TextSpan(
                        text: 'Just for You',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Offer cards (same as before)
              Container(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildOfferCard(
                        '20% off on Croptop',
                        'assets/images/womens_offer1.jpg',
                        isDarkMode),
                    _buildOfferCard(
                        'Buy 1 Get 1 Free',
                        'assets/images/womens_offer2.jpg',
                        isDarkMode),
                    _buildOfferCard(
                        '30% off on Skirt',
                        'assets/images/womens_offer3.jpg',
                        isDarkMode),
                    _buildOfferCard(
                        'Buy 1 Get 1 Free on Dresses',
                        'assets/images/womens_offer4.jpg',
                        isDarkMode),
                    _buildOfferCard(
                        '40% Off on Jackets & Coats',
                        'assets/images/womens_offer5.jpg',
                        isDarkMode),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text: 'Featured ',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black)),
                    TextSpan(
                        text: 'Products',
                        style: TextStyle(color: Colors.orange)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Fetching product data
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _womensProducts.isEmpty
                      ? Center(
                          child: Text(
                            "No Women's Products Available",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : Column(
                          children: _womensProducts.map((product) {
                            return _buildProductCard(
                                context,
                                product['name'],
                                product['image_url'],
                                '\$${product['price']}',
                                product['description'],
                                isDarkMode, () {
                              Navigator.pushNamed(
context,
WomenProductDetail.id,
arguments: {
'_id': product.containsKey('_id') ? product['_id'] : product['id'], // Ensure product ID is passed
'productName': product['name'],
'productImage': product['image_url'],
'productPrice': '\$${product['price']}',
'productDescription': product['description'],
},
);
                            });
                          }).toList(),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(String offerText, String imagePath, bool isDarkMode) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black45 : Colors.black26,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.black54.withOpacity(0.7)
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              offerText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String imagePath,
      String price, String description, bool isDarkMode, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        shadowColor: isDarkMode ? Colors.black45 : Colors.grey[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  Icon(
                    Icons.shopping_cart,
                    color: isDarkMode ? Colors.white : Colors.black,
                    size: 22,
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


