
import 'package:flutter/material.dart';
import 'package:meat_shop/data/cart_data.dart';
import 'package:meat_shop/data/product_data.dart';
import 'package:meat_shop/payment.dart';

class cartsx extends StatefulWidget {
  const cartsx({super.key});

  @override
  State<cartsx> createState() => _cartsxState();
}

class _cartsxState extends State<cartsx> {
  final addressController = TextEditingController();
  final maroon = Color.fromARGB(255, 99, 7, 7);

  Map<String, String>? findProduct(String name) {
    for (final category in ProductData.categories.values) {
      final groups = category['products'] as Map;
      for (final items in groups.values) {
        for (final item in items as List) {
          final product = item as Map<String, String>;
          if (product['name']?.trim().toLowerCase() ==
              name.trim().toLowerCase()) {
            return product;
          }
        }
      }
    }
    return null;
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maroon,
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: maroon,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: ProductData.changes,
        builder: (context, stockVersion, child) {
          return ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: CartData.items,
            builder: (context, items, child) {
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 75,
                        color: Colors.white70,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Your cart is empty",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }

              bool hasUnavailable = false;
              double total = 0;

              for (final item in items) {
                final product = findProduct(item['name'].toString());
                final available =
                    product != null && product['inStock'] != 'false';

                if (!available) hasUnavailable = true;

                final price = double.tryParse(
                  product?['price'] ?? item['price'].toString(),
                ) ?? 0;

                total += price * (item['quantity'] as int);
              }

              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text(
                    "Delivery Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: maroon),
                            SizedBox(width: 8),
                            Text(
                              "Delivery Address",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: addressController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: "Enter your delivery address",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    "Item Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  if (hasUnavailable)
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.red),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Some products are out of stock or unavailable. Remove them to continue.",
                              style: TextStyle(color: Colors.red.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final product = findProduct(item['name'].toString());

                    final inStock =
                        product != null && product['inStock'] != 'false';

                    final price = double.tryParse(
                      product?['price'] ?? item['price'].toString(),
                    ) ?? 0;

                    final weight =
                        product?['weight'] ?? item['weight'].toString();

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              product?['image'] ??
                                  item['image']?.toString() ??
                                  '',
                              width: 65,
                              height: 65,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 65,
                                  height: 65,
                                  color: Colors.grey.shade200,
                                  child: Icon(Icons.fastfood),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text("Net wt. $weight"),
                                SizedBox(height: 5),
                                Text("₹${price.toStringAsFixed(2)}"),
                                if (!inStock) ...[
                                  SizedBox(height: 5),
                                  Text(
                                    "Out of Stock",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  CartData.changeQuantity(index, -1);
                                },
                                icon: Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                "${item['quantity']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: inStock
                                    ? () => CartData.changeQuantity(index, 1)
                                    : null,
                                icon: Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${total.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: maroon,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: maroon,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey,
                            ),
                            onPressed: hasUnavailable
                                ? null
                                : () {
                                    final address =
                                        addressController.text.trim();

                                    if (address.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Please enter your delivery address",
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    // Sync latest product prices before payment.
                                    final updatedItems = items.map((item) {
                                      final copy =
                                          Map<String, dynamic>.from(item);
                                      final product =
                                          findProduct(item['name'].toString());

                                      if (product != null) {
                                        copy['price'] = double.tryParse(
                                              product['price'] ?? '',
                                            ) ??
                                            copy['price'];
                                        copy['weight'] =
                                            product['weight'] ?? copy['weight'];
                                        copy['image'] =
                                            product['image'] ?? copy['image'];
                                      }
                                      return copy;
                                    }).toList();

                                    CartData.items.value = updatedItems;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentPage(
                                          address: address,
                                        ),
                                      ),
                                    );
                                  },
                            child: Text("Proceed to Payment"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
