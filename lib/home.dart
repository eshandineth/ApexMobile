import 'package:flutter/material.dart';
import 'package:clothing_store3/womens.dart';
import 'accessories.dart';
import 'mens.dart';

class Home extends StatelessWidget {
  static const String id = 'home';

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBannerSection(isLandscape, isDarkMode),
            const SizedBox(height: 20.0),
            _buildWelcomeText(isDarkMode),
            const SizedBox(height: 20.0),
            _buildOfferCarousel(isLandscape),
            const SizedBox(height: 20.0),
            _buildExploreCollections(context, isLandscape),
            const SizedBox(height: 20.0),
            _buildFeaturedProducts(isDarkMode, isLandscape),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSection(bool isLandscape, bool isDarkMode) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: isLandscape ? 150 : 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home_banner.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        Container(
          height: isLandscape ? 150 : 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.3)
                    ]
                  : [Colors.black.withOpacity(0.5), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Welcome to ',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          children: [
            TextSpan(
              text: 'ΛPΣX',
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCarousel(bool isLandscape) {
    return Container(
      height: isLandscape ? 150 : 200,
      child: PageView(
        children: [
          _buildOfferCard(
              'assets/images/offer1.jpg', '50% Off on Men\'s Collection'),
          _buildOfferCard('assets/images/offer2.jpg',
              'Buy 1 Get 1 Free on Women\'s Collection'),
          _buildOfferCard('assets/images/offer3.jpg', '20% Off on Accessories'),
        ],
      ),
    );
  }

  Widget _buildOfferCard(String imagePath, String offerText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              offerText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExploreCollections(BuildContext context, bool isLandscape) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Explore ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'Collections',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: isLandscape ? 120 : 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildExploreCard('Men\'s', 'assets/images/mens_banner.jpg',
                    () {
                  Navigator.pushNamed(context, Mens.id);
                }, isLandscape),
                const SizedBox(width: 15),
                _buildExploreCard('Women\'s', 'assets/images/womens_banner.jpg',
                    () {
                  Navigator.pushNamed(context, Womens.id);
                }, isLandscape),
                const SizedBox(width: 15),
                _buildExploreCard(
                    'Accessories', 'assets/images/accessories_banner.jpg', () {
                  Navigator.pushNamed(context, Accessories.id);
                }, isLandscape),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCard(
      String title, String imagePath, VoidCallback onTap, bool isLandscape) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isLandscape ? 250 : 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedProducts(bool isDarkMode, bool isLandscape) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Featured ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
                TextSpan(
                  text: 'Products',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isLandscape ? 3 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
            children: [
              _buildFeaturedProduct('assets/images/product1.jpg',
                  'Casual Hoodie', '59.99', isDarkMode),
              _buildFeaturedProduct('assets/images/product2.jpg',
                  'Summer Dress', '49.99', isDarkMode),
              _buildFeaturedProduct('assets/images/product3.jpg',
                  'Luxury Watch', '199.99', isDarkMode),
              _buildFeaturedProduct('assets/images/product4.jpg', 'Sneakers',
                  '79.99', isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProduct(
      String imagePath, String name, String price, bool isDarkMode) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$$price',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: isDarkMode ? Colors.orangeAccent : Colors.orange,
            ),
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
