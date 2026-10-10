
import 'package:flutter/foundation.dart';
import 'package:meat_shop/data/data.dart';

class ProductData {
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  static Map<String, Map<String, dynamic>> get categories =>
      meatdata.meatData;

  static void refresh() {
    changes.value++;
  }

  static int get totalProducts {
    int total = 0;
    for (final category in categories.values) {
      final products = category['products'] as Map;
      for (final items in products.values) {
        total += (items as List).length;
      }
    }
    return total;
  }

  static void addProduct({
    required String category,
    required String subcategory,
    required String name,
    required String price,
    required String weight,
    required String image,
  }) {
    final products = categories[category]!['products'] as Map;
    products.putIfAbsent(subcategory, () => <Map<String, String>>[]);

    final items = products[subcategory] as List;
    items.add(<String, String>{
      'name': name,
      'price': price,
      'weight': weight,
      'image': image,
      'inStock': 'true',
    });
    refresh();
  }

  static void updateProduct({
    required String category,
    required String subcategory,
    required int index,
    required String name,
    required String price,
    required String weight,
    required String image,
  }) {
    final products = categories[category]!['products'] as Map;
    final items = products[subcategory] as List;
    final item = items[index] as Map<String, String>;

    item['name'] = name;
    item['price'] = price;
    item['weight'] = weight;
    item['image'] = image;
    refresh();
  }

  static void toggleStock({
    required String category,
    required String subcategory,
    required int index,
  }) {
    final products = categories[category]!['products'] as Map;
    final items = products[subcategory] as List;
    final item = items[index] as Map<String, String>;

    item['inStock'] = item['inStock'] == 'false' ? 'true' : 'false';
    refresh();
  }

  static void deleteProduct({
    required String category,
    required String subcategory,
    required int index,
  }) {
    final products = categories[category]!['products'] as Map;
    final items = products[subcategory] as List;
    items.removeAt(index);
    refresh();
  }
}
