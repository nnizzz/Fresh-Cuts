
import 'package:flutter/material.dart';
import 'package:meat_shop/data/cart_data.dart';
import 'package:meat_shop/data/product_data.dart';

class ProductScreen extends StatefulWidget {
  final String subCategoryName;
  final List<Map<String, String>> products;

  const ProductScreen({
    super.key,
    required this.subCategoryName,
    required this.products,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedIndex = -1;

  List<Map<String, String>> get currentProducts {
    for (final category in ProductData.categories.values) {
      final groups = category['products'] as Map;
      if (groups.containsKey(widget.subCategoryName)) {
        return (groups[widget.subCategoryName] as List)
            .cast<Map<String, String>>();
      }
    }
    return widget.products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subCategoryName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 99, 7, 7),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: ProductData.changes,
        builder: (context, value, child) {
          final products = currentProducts;

          if (products.isEmpty) {
            return Center(child: Text("No products available"));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isSelected = selectedIndex == index;
              final inStock = product['inStock'] != 'false';

              return GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = index);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color.fromARGB(255, 157, 142, 142)
                        : Color.fromARGB(255, 25, 25, 25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          product['image'] ?? '',
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 80,
                              width: 80,
                              color: Color.fromARGB(255, 99, 7, 7),
                              child: Icon(
                                Icons.fastfood,
                                color: Colors.white,
                                size: 35,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              inStock ? "In Stock" : "Out of Stock",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: inStock
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Net wt. ${product['weight'] ?? ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "₹${product['price'] ?? '0'}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 100, 110),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: inStock
                              ? Color.fromARGB(255, 184, 25, 45)
                              : Colors.grey.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: inStock
                            ? () {
                                CartData.addProduct(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${product['name']} added to cart",
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: Text(inStock ? "Add" : "Unavailable"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
