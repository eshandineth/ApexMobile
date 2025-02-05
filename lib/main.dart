// import 'package:flutter/material.dart';
// import 'package:clothing_store3/accessories_product_detail.dart';
// import 'package:clothing_store3/cart.dart';
// import 'package:clothing_store3/login.dart';
// import 'package:clothing_store3/profile.dart';
// import 'package:clothing_store3/register.dart';
// import 'package:clothing_store3/product_detail.dart';
// import 'package:clothing_store3/home.dart';
// import 'package:clothing_store3/homepage.dart';
// import 'package:clothing_store3/mens.dart';
// import 'package:clothing_store3/womens.dart';
// import 'package:clothing_store3/accessories.dart';
// import 'package:clothing_store3/men_product_detail.dart';
// import 'package:clothing_store3/women_product_detail.dart';
// import 'package:clothing_store3/checkout.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'checkout.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   StripePayment.setOptions(
//     StripeOptions(
//       publishableKey: "pk_test_51QjmYMLLvJLWXilVJMOEdZNZsX7E8rZulCfkXRb7Z0Pi45YXmEaKwE18cxU4yHBFN4wuebZTnai8aNfJDD6gPFgV00hDckMq1L",
//       merchantId: "Test",
//       androidPayMode: 'test',
//     ),
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.system);

//   void _toggleTheme() {
//     if (_themeNotifier.value == ThemeMode.light) {
//       _themeNotifier.value = ThemeMode.dark;
//     } else {
//       _themeNotifier.value = ThemeMode.light;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: _themeNotifier,
//       builder: (context, themeMode, child) {
//         return MaterialApp(
//           theme: ThemeData.light().copyWith(
//             appBarTheme: AppBarTheme(
//               color: Colors.orange,
//               elevation: 5,
//               titleTextStyle: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//             bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//               backgroundColor: Colors.white,
//               selectedItemColor: Colors.orange,
//               unselectedItemColor: Colors.black54,
//             ),
//           ),
//           darkTheme: ThemeData.dark().copyWith(
//             appBarTheme: const AppBarTheme(
//               color: Colors.black87,
//               elevation: 5,
//               titleTextStyle: TextStyle(
//                   color: Colors.orange,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//             ),
//             bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//               backgroundColor: Colors.black87,
//               selectedItemColor: Colors.orange,
//               unselectedItemColor: Colors.white70,
//             ),
//           ),
//           themeMode: themeMode,
//           initialRoute: Login.id,
//           routes: {
//             Home.id: (context) => HomePage(
//                   child: Home(),
//                   selectedIndex: 0,
//                   toggleTheme: _toggleTheme,
//                 ),
//             Mens.id: (context) => HomePage(
//                   child: Mens(),
//                   selectedIndex: 1,
//                   toggleTheme: _toggleTheme,
//                 ),
//             Womens.id: (context) => HomePage(
//                   child: Womens(),
//                   selectedIndex: 2,
//                   toggleTheme: _toggleTheme,
//                 ),
//             Accessories.id: (context) => HomePage(
//                   child: Accessories(),
//                   selectedIndex: 3,
//                   toggleTheme: _toggleTheme,
//                 ),
//             Login.id: (context) => Login(),
//             Register.id: (context) => Register(),
//             Profile.id: (context) => Profile(),
//             ProductDetail.id: (context) => ProductDetail(),
//             MenProductDetail.id: (context) => MenProductDetail(),
//             WomenProductDetail.id: (context) => WomenProductDetail(),
//             AccessoryProductDetail.id: (context) => AccessoryProductDetail(),
//             Cart.id: (context) => Cart(),
//             Checkout.id: (context) => Checkout(
//               subtotal: 0.0, // example value
//               shippingCost: 500.0, // example value
//               cartItems: [], // example value
//             ),
//           },
//           debugShowCheckedModeBanner: false,
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:clothing_store3/accessories_product_detail.dart';
import 'package:clothing_store3/cart.dart';
import 'package:clothing_store3/login.dart';
import 'package:clothing_store3/profile.dart';
import 'package:clothing_store3/register.dart';
import 'package:clothing_store3/product_detail.dart';
import 'package:clothing_store3/home.dart';
import 'package:clothing_store3/homepage.dart';
import 'package:clothing_store3/mens.dart';
import 'package:clothing_store3/womens.dart';
import 'package:clothing_store3/accessories.dart';
import 'package:clothing_store3/men_product_detail.dart';
import 'package:clothing_store3/women_product_detail.dart';
import 'package:stripe_payment/stripe_payment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  StripePayment.setOptions(
    StripeOptions(
      publishableKey: "pk_test_51QjmYMLLvJLWXilVJMOEdZNZsX7E8rZulCfkXRb7Z0Pi45YXmEaKwE18cxU4yHBFN4wuebZTnai8aNfJDD6gPFgV00hDckMq1L",
      merchantId: "Test",
      androidPayMode: 'test',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.system);

  void _toggleTheme() {
    if (_themeNotifier.value == ThemeMode.light) {
      _themeNotifier.value = ThemeMode.dark;
    } else {
      _themeNotifier.value = ThemeMode.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
           home: Scaffold(
        appBar: AppBar(title: Text('Stripe Payment')),
        body: Center(child: Text('Stripe Payment Example')),
      ),
          theme: ThemeData.light().copyWith(
            appBarTheme: AppBarTheme(
              color: Colors.orange,
              elevation: 5,
              titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.black54,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(
              color: Colors.black87,
              elevation: 5,
              titleTextStyle: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.black87,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.white70,
            ),
          ),
          themeMode: themeMode,
          initialRoute: Login.id,
          routes: {
            Home.id: (context) => HomePage(
                  child: Home(),
                  selectedIndex: 0,
                  toggleTheme: _toggleTheme,
                ),
            Mens.id: (context) => HomePage(
                  child: Mens(),
                  selectedIndex: 1,
                  toggleTheme: _toggleTheme,
                ),
            Womens.id: (context) => HomePage(
                  child: Womens(),
                  selectedIndex: 2,
                  toggleTheme: _toggleTheme,
                ),
            Accessories.id: (context) => HomePage(
                  child: Accessories(),
                  selectedIndex: 3,
                  toggleTheme: _toggleTheme,
                ),
            Login.id: (context) => Login(),
            Register.id: (context) => Register(),
            Profile.id: (context) => Profile(),
            ProductDetail.id: (context) => ProductDetail(),
            MenProductDetail.id: (context) => MenProductDetail(),
            WomenProductDetail.id: (context) => WomenProductDetail(),
            AccessoryProductDetail.id: (context) => AccessoryProductDetail(),
            Cart.id: (context) => Cart(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}






