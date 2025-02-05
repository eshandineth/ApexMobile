import 'package:clothing_store3/profile.dart';
import 'package:flutter/material.dart';
import 'cart.dart';
import 'home.dart';
import 'mens.dart';
import 'womens.dart';
import 'accessories.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  final Function toggleTheme;

  const HomePage(
      {super.key,
      required this.child,
      required this.selectedIndex,
      required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ΛPΣX'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, Cart.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              widget.toggleTheme();
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.male),
            label: 'Mens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.female),
            label: 'Womens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'Accessories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, Home.id);
              break;
            case 1:
              Navigator.pushNamed(context, Mens.id);
              break;
            case 2:
              Navigator.pushNamed(context, Womens.id);
              break;
            case 3:
              Navigator.pushNamed(context, Accessories.id);
              break;
            case 4:
              Navigator.pushNamed(context, Profile.id);
              break;
          }
        },
      ),
    );
  }
}
