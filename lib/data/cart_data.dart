
import 'package:flutter/foundation.dart';

class CartData {
  static final ValueNotifier<List<Map<String, dynamic>>> items =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  static void addProduct(Map<String, String> product) {
    final cart = items.value.map((item) => Map<String, dynamic>.from(item)).toList();
    final index = cart.indexWhere((item) => item['name'] == product['name']);

    if (index != -1) {
      cart[index]['quantity'] = (cart[index]['quantity'] as int) + 1;
    } else {
      cart.add({
        'name': product['name'] ?? '',
        'price': double.tryParse(product['price'] ?? '') ?? 0,
        'weight': product['weight'] ?? '',
        'image': product['image'] ?? '',
        'quantity': 1,
      });
    }
    items.value = cart;
  }

  static void changeQuantity(int index, int change) {
    final cart = items.value.map((item) => Map<String, dynamic>.from(item)).toList();
    if (index < 0 || index >= cart.length) return;

    cart[index]['quantity'] = (cart[index]['quantity'] as int) + change;
    if (cart[index]['quantity'] <= 0) cart.removeAt(index);
    items.value = cart;
  }

  static double get total => items.value.fold<double>(
    0,
    (sum, item) => sum + (item['price'] as num).toDouble() * (item['quantity'] as int),
  );

  static void clearCart() {
    items.value = [];
  }
}
