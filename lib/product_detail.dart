import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  static const String id = 'ProductDetail';

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _quantity = 1;
  String? _selectedSize;
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(args['productName']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isHorizontal = constraints.maxWidth > constraints.maxHeight;

            return isHorizontal
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      args['productImage'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 3,
                  child: _cartDetails(args, isDarkMode),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    args['productImage'],
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                _cartDetails(args, isDarkMode),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cartDetails(Map<String, dynamic> args, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            args['productName'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            args['productPrice'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            args['productDescription'],
            style: const TextStyle(fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text('Size:', style: TextStyle(fontSize: 14)),
          DropdownButton<String>(
            value: _selectedSize,
            hint: Text('Choose Size', style: TextStyle(fontSize: 14)),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSize = newValue;
              });
            },
            items: <String>['S', 'M', 'L', 'XL']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text('Color:', style: TextStyle(fontSize: 14)),
          DropdownButton<String>(
            value: _selectedColor,
            hint: Text('Choose Color', style: TextStyle(fontSize: 14)),
            onChanged: (String? newValue) {
              setState(() {
                _selectedColor = newValue;
              });
            },
            items: <String>['Red', 'Blue', 'Green', 'Black']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity:', style: TextStyle(fontSize: 14)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                  ),
                  Text('$_quantity', style: TextStyle(fontSize: 16)),
                  IconButton(
                    icon: Icon(Icons.add),
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
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              print(
                  'Adding to cart: ${args['productName']}, Size: $_selectedSize, Color: $_selectedColor, Quantity: $_quantity');
            },
            child: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
