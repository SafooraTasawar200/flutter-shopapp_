// lib/product_detail_page.dart

import 'package:flutter/material.dart';
import 'cart_state.dart';   // Import the global cart state from same directory
import 'cart_item.dart';   // Import CartItem model from same directory
import 'cart_page.dart';     // Import CartPage for navigation from same directory


class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductDetailPage({
    super.key,
    required this.productData,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? _selectedColor;
  String? _selectedStorage;
  int _quantity = 1;

  // New: Map to store specific images for iPhone 16 Pro Max colors
  // This map should ideally come from your product data source,
  // but for now, we'll define it here specific to the iPhone.
  final Map<String, String> _mobileColorImages = {
    'Desert Titanium': 'assets/dessert.jpg',
    'Natural Titanium': 'assets/natural.jpg',
    'White Titanium': 'assets/white.jpg',
    'Black Titanium': 'assets/black.jpg',
  };

  // Variable to hold the current image path to display
  String _currentProductImage = '';

  @override
  void initState() {
    super.initState();
    // Set default selected color
    _selectedColor = widget.productData['colors'].isNotEmpty
        ? widget.productData['colors'][0]['name']
        : null;
    // Set default selected storage
    _selectedStorage = widget.productData['storage'].isNotEmpty
        ? widget.productData['storage'][0]
        : null;

    // Initialize the current product image based on the default selected color
    _updateProductImage();
  }

  // New: Method to update the product image based on selected color
  void _updateProductImage() {
    // Check if the current product is a "Mobile" and has color-specific images
    if (widget.productData['name'] == 'Mobile' &&
        _selectedColor != null &&
        _mobileColorImages.containsKey(_selectedColor)) {
      _currentProductImage = _mobileColorImages[_selectedColor]!;
    } else {
      // Otherwise, use the default product image from productData
      _currentProductImage = widget.productData['image']!;
    }
  }


  void _addToCartHandler() {
    final newItem = CartItem(
      productName: widget.productData['productName']!,
      brand: widget.productData['brand']!,
      imageUrl: _currentProductImage,
      // Use the currently displayed image
      color: _selectedColor ?? 'N/A',
      price: widget.productData['price']!,
      quantity: _quantity,
      storage: _selectedStorage,
    );
    addToCart(newItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${widget.productData['productName']} to cart!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    { // Changed build(BuildContext context) to build(BuildContext dart)
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.productData['productName']!,
              style: TextStyle(color: Colors.black)),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
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
                  child: ValueListenableBuilder<List<CartItem>>(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  // Use _currentProductImage for the main product display
                  child: Image.asset(
                    _currentProductImage,
                    // This will change based on color selection
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(height: 24),
                Text(
                  widget.productData['productName']!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'By ${widget.productData['brand']!}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      '${widget.productData['rating']} (${widget
                          .productData['reviews']}K)',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      widget.productData['price']!,
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    if (widget.productData['oldPrice']!.isNotEmpty)
                      Text(
                        widget.productData['oldPrice']!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                // Color selection
                if (widget.productData['colors'] != null &&
                    widget.productData['colors'].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Color',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: widget.productData['colors'].map<Widget>((
                            colorOption) {
                          bool isSelected =
                              _selectedColor == colorOption['name'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = colorOption['name'];
                                // Only update product image if it's a mobile product
                                if (widget.productData['name'] == 'Mobile') {
                                  _updateProductImage();
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.shade100
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey
                                      .shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 8,
                                    backgroundColor: colorOption['color'],
                                    child: isSelected
                                        ? Icon(Icons.check,
                                        size: 10, color: Colors.white)
                                        : null,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    colorOption['name'],
                                    style: TextStyle(
                                      color: isSelected ? Colors.blue : Colors
                                          .black87,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                if (widget.productData['storage'] != null &&
                    widget.productData['storage'].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Storage',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: widget.productData['storage'].map<Widget>((
                            storageOption) {
                          bool isSelected = _selectedStorage == storageOption;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedStorage = storageOption;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey
                                      .shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                storageOption,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors
                                      .black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 20),
                            onPressed: () {
                              if (_quantity > 1) {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            },
                          ),
                          Text(
                            '$_quantity',
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 20),
                            onPressed: () {
                              setState(() {
                                _quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (widget.productData['features'] != null &&
                    widget.productData['features'].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A Snapshot View',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ...widget.productData['features'].map<Widget>((feature) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(feature['icon'], size: 20,
                                  color: Colors.grey[700]),
                              SizedBox(width: 10),
                              Text(
                                feature['text'],
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _addToCartHandler();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Buying ${widget
                            .productData['productName']} with $_quantity quantity, color ${_selectedColor ??
                            'N/A'}, and storage ${_selectedStorage ?? 'N/A'}!'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.blue),
                  ),
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _addToCartHandler,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}