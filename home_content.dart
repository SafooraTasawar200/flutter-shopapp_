// lib/main.dart

import 'package:flutter/material.dart';
import 'product_detail_page.dart';
import 'cart_item.dart';// Import ProductDetailPage from lib/
import 'cart_page.dart';            // Import CartPage from lib/
import 'cart_state.dart';

// Import cart_state from lib/

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Mobile',
      'image': 'assets/mobile.jpg',
      'productName': 'iPhone 16 Pro Max',
      'brand': 'Apple',
      'price': '\$1399.99',
      'oldPrice': '\$1499.99',
      'rating': 4.9,
      'reviews': 2.2,
      'colors': [
        {'name': 'Desert Titanium', 'color': Colors.grey[400]},
        {'name': 'Natural Titanium', 'color': Colors.grey[300]},
        {'name': 'White Titanium', 'color': Colors.blueGrey[50]},
        {'name': 'Black Titanium', 'color': Colors.grey[800]},
      ],
      'storage': ['256 GB', '512 GB', '1 TB'],
      'features': [
        {'icon': Icons.tv, 'text': '4K Ultra HD XDR Display'},
        {'icon': Icons.charging_station, 'text': 'Wireless Charging System'},
        {'icon': Icons.camera_alt, 'text': 'Pro Camera System'},
        {'icon': Icons.water_damage, 'text': 'IP68 Water Resistant'},
      ],
    },
    {
      'name': 'Headphone',
      'image': 'assets/headphone.jpg',
      'productName': 'Sony WH-1000XM5',
      'brand': 'Sony',
      'price': '\$349.00',
      'oldPrice': '\$399.00',
      'rating': 4.7,
      'reviews': 1.5,
      'colors': [
        {'name': 'Black', 'color': Colors.black},
        {'name': 'Silver', 'color': Colors.grey[400]},
      ],
      'storage': [],
      'features': [
        {'icon': Icons.bluetooth, 'text': 'Bluetooth 5.2'},
        {'icon': Icons.noise_control_off, 'text': 'Active Noise Cancellation'},
        {'icon': Icons.battery_charging_full, 'text': '30-Hour Battery Life'},
      ],
    },
    {
      'name': 'Tablets',
      'image': 'assets/tablet.jpg',
      'productName': 'iPad Pro M4',
      'brand': 'Apple',
      'price': '\$799.00',
      'oldPrice': '\$899.00',
      'rating': 4.8,
      'reviews': 1.8,
      'colors': [
        {'name': 'Space Gray', 'color': Colors.grey[800]},
        {'name': 'Silver', 'color': Colors.grey[300]},
      ],
      'storage': ['128 GB', '256 GB', '512 GB'],
      'features': [
        {'icon': Icons.tv, 'text': 'Liquid Retina XDR Display'},
        {'icon': Icons.memory, 'text': 'Apple M4 Chip'},
        {'icon': Icons.camera_alt, 'text': 'Pro Camera System'},
      ],
    },
    {
      'name': 'Watch',
      'image': 'assets/watch.jpg',
      'productName': 'Apple Watch Series 9',
      'brand': 'Apple',
      'price': '\$399.00',
      'oldPrice': '\$429.00',
      'rating': 4.6,
      'reviews': 1.2,
      'colors': [
        {'name': 'Midnight', 'color': Colors.blueGrey[900]},
        {'name': 'Starlight', 'color': Colors.amber[100]},
        {'name': 'Silver', 'color': Colors.grey[300]},
      ],
      'storage': [],
      'features': [
        {'icon': Icons.favorite, 'text': 'Heart Rate Monitor'},
        {'icon': Icons.water_damage, 'text': 'Swimproof'},
        {'icon': Icons.watch, 'text': 'Always-On Retina Display'},
      ],
    },
    {
      'name': 'Speakers',
      'image': 'assets/speaker.jpg',
      'productName': 'JBL Flip 6',
      'brand': 'JBL',
      'price': '\$129.00',
      'oldPrice': '\$149.00',
      'rating': 4.5,
      'reviews': 0.9,
      'colors': [
        {'name': 'Black', 'color': Colors.black},
        {'name': 'Blue', 'color': Colors.blue},
        {'name': 'Red', 'color': Colors.red},
      ],
      'storage': [],
      'features': [
        {'icon': Icons.bluetooth, 'text': 'Bluetooth Connectivity'},
        {'icon': Icons.speaker, 'text': 'Powerful JBL Original Pro Sound'},
        {'icon': Icons.water_damage, 'text': 'IP67 Waterproof and Dustproof'},
      ],
    },
    {
      'name': 'More',
      'image': 'assets/more.jpg',
      'productName': 'Various Accessories',
      'brand': 'Generic',
      'price': 'Prices Vary',
      'oldPrice': '',
      'rating': 0.0,
      'reviews': 0.0,
      'colors': [],
      'storage': [],
      'features': [],
    },
  ];

  final List<Map<String, String>> deals = [
    {'image': 'assets/mobile.jpg'},
    {'image': 'assets/watch.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.qr_code_scanner, color: Colors.black),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            fillColor: Colors.white,
            filled: true,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: ValueListenableBuilder<List<dynamic>>(
                  valueListenable: cartItemsNotifier,
                  builder: (context, cartItems, child) {
                    return CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${cartItems.length}',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 210,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.blue.shade700!, Colors.blue.shade400!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'iPhone 16 Pro',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Extraordinary Visual\n& Exceptional Power',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final iphone16ProMax = categories.firstWhere(
                                    (cat) => cat['productName'] == 'iPhone 16 Pro Max');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(
                                  productData: iphone16ProMax,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Shop Now'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        color: Colors.blue.shade700,
                        height: 160,
                        width: 120,
                        child: Image.asset(
                          'assets/iphone.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Text('Categories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
            children: categories.map((category) {
              return GestureDetector(
                onTap: () {
                  if (category['name'] != 'More') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(
                          productData: category,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        category['image']!,
                        height: 110,
                        width: 110,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        category['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Flash Deals for You',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextButton(
                onPressed: () {},
                child: Text('See All', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: deals.length,
              separatorBuilder: (context, index) => SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          deals[index]['image']!,
                          fit: BoxFit.contain,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Icon(Icons.favorite_border,
                            color: Colors.black38),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black45,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}