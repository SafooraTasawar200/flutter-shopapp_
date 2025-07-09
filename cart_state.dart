import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cart_item.dart';

ValueNotifier<List<CartItem>> cartItemsNotifier = ValueNotifier([]);

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

/// ✅ Save entire cart to Firestore (overwrite mode)
Future<void> saveCartToFirestore() async {
  final user = _auth.currentUser;
  if (user == null) return;

  final cartRef = _firestore.collection('carts').doc(user.uid).collection('items');
  final batch = _firestore.batch();

  // Clear old items
  final snapshot = await cartRef.get();
  for (var doc in snapshot.docs) {
    batch.delete(doc.reference);
  }

  // Add new ones
  for (var item in cartItemsNotifier.value) {
    final docRef = cartRef.doc(item.productName + item.color + (item.storage ?? ''));
    batch.set(docRef, item.toMap());
  }

  await batch.commit();
}

/// ✅ Sync cart from Firestore into local state
Future<void> syncCartFromFirestore() async {
  final user = _auth.currentUser;
  if (user == null) return;

  final snapshot = await _firestore
      .collection('carts')
      .doc(user.uid)
      .collection('items')
      .get();

  final items = snapshot.docs.map((doc) {
    final data = doc.data();
    return CartItem(
      productName: data['productName'],
      brand: data['brand'],
      imageUrl: data['imageUrl'],
      color: data['color'],
      price: data['price'],
      quantity: data['quantity'],
      storage: data['storage'],
    );
  }).toList();

  cartItemsNotifier.value = items;
}

/// ✅ Add item and update Firestore
Future<void> addToCart(CartItem newItem) async {
  final existingIndex = cartItemsNotifier.value.indexWhere(
        (item) =>
    item.productName == newItem.productName &&
        item.color == newItem.color &&
        item.storage == newItem.storage,
  );

  if (existingIndex != -1) {
    cartItemsNotifier.value[existingIndex].quantity += newItem.quantity;
  } else {
    cartItemsNotifier.value = List.from(cartItemsNotifier.value)..add(newItem);
  }

  cartItemsNotifier.notifyListeners();
  await saveCartToFirestore(); // 🔁 Save update
}

/// ✅ Remove item and update Firestore
Future<void> removeFromCart(CartItem itemToRemove) async {
  cartItemsNotifier.value = List.from(cartItemsNotifier.value)
    ..removeWhere((item) =>
    item.productName == itemToRemove.productName &&
        item.color == itemToRemove.color &&
        item.storage == itemToRemove.storage);

  cartItemsNotifier.notifyListeners();
  await saveCartToFirestore(); // 🔁 Save update
}

/// ✅ Update quantity and update Firestore
Future<void> updateCartItemQuantity(CartItem item, int newQuantity) async {
  final index = cartItemsNotifier.value.indexWhere((i) =>
  i.productName == item.productName &&
      i.color == item.color &&
      i.storage == item.storage);

  if (index != -1) {
    cartItemsNotifier.value[index].quantity = newQuantity;
    cartItemsNotifier.notifyListeners();
    await saveCartToFirestore(); // 🔁 Save update
  }
}

/// ✅ Clear cart and Firestore
Future<void> clearCart() async {
  cartItemsNotifier.value = [];
  cartItemsNotifier.notifyListeners();
  await saveCartToFirestore(); // 🔁 Save update
}

/// ✅ Calculate subtotal locally
double calculateCartSubtotal() {
  double subtotal = 0.0;
  for (var item in cartItemsNotifier.value) {
    final priceString = item.price.replaceAll('\$', '');
    final price = double.tryParse(priceString) ?? 0.0;
    subtotal += price * item.quantity;
  }
  return subtotal;
}
