
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meat_shop/data/product_data.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final weightController = TextEditingController();
  final picker = ImagePicker();

  Uint8List? selectedImage;
  String? selectedCategory;
  String? selectedSubcategory;

  List<Map<String, dynamic>> get products {
    final result = <Map<String, dynamic>>[];

    ProductData.categories.forEach((category, categoryData) {
      final productGroups = categoryData['products'] as Map;

      productGroups.forEach((subcategory, items) {
        for (int i = 0; i < (items as List).length; i++) {
          result.add({
            'category': category,
            'subcategory': subcategory,
            'index': i,
            'product': items[i] as Map<String, String>,
          });
        }
      });
    });

    return result;
  }

  List<String> get subcategories {
    if (selectedCategory == null) return [];

    final category = ProductData.categories[selectedCategory]!;
    final groups = category['subcategories'] as List;

    return groups
        .map((item) => item['name'].toString())
        .toList();
  }

  Future<void> pickImage(StateSetter updateDialog) async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    if (!mounted) return;

    updateDialog(() => selectedImage = bytes);
  }

  void showProductDialog({Map<String, dynamic>? entry}) {
    final editing = entry != null;
    final oldProduct = editing
        ? entry['product'] as Map<String, String>
        : null;

    nameController.text = oldProduct?['name'] ?? '';
    priceController.text = oldProduct?['price'] ?? '';
    weightController.text = oldProduct?['weight'] ?? '750g';

    selectedCategory = editing
        ? entry['category'] as String
        : ProductData.categories.keys.first;

    selectedSubcategory = editing
        ? entry['subcategory'] as String
        : subcategories.first;

    selectedImage = null;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, updateDialog) {
            return AlertDialog(
              title: Text(editing ? "Edit Product" : "Add Product"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(labelText: "Category"),
                      items: ProductData.categories.keys.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: editing
                          ? null
                          : (value) {
                              updateDialog(() {
                                selectedCategory = value;
                                selectedSubcategory = subcategories.first;
                              });
                            },
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      key: ValueKey(selectedCategory),
                      value: selectedSubcategory,
                      decoration: InputDecoration(labelText: "Subcategory"),
                      items: subcategories.map((subcategory) {
                        return DropdownMenuItem(
                          value: subcategory,
                          child: Text(subcategory),
                        );
                      }).toList(),
                      onChanged: editing
                          ? null
                          : (value) {
                              updateDialog(() {
                                selectedSubcategory = value;
                              });
                            },
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Product Name"),
                    ),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Price"),
                    ),
                    TextField(
                      controller: weightController,
                      decoration: InputDecoration(labelText: "Weight"),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => pickImage(updateDialog),
                      icon: Icon(Icons.image),
                      label: Text("Select Image"),
                    ),
                    if (selectedImage != null)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Image.memory(
                          selectedImage!,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(height: 8),
                    Text(
                      "Selected gallery images are preview-only for now.",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price = priceController.text.trim();
                    final weight = weightController.text.trim();

                    if (name.isEmpty ||
                        weight.isEmpty ||
                        double.tryParse(price) == null ||
                        double.parse(price) <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enter valid product details")),
                      );
                      return;
                    }

                    if (editing) {
                      ProductData.updateProduct(
                        category: entry['category'],
                        subcategory: entry['subcategory'],
                        index: entry['index'],
                        name: name,
                        price: price,
                        weight: weight,
                        image: oldProduct?['image'] ?? '',
                      );
                    } else {
                      ProductData.addProduct(
                        category: selectedCategory!,
                        subcategory: selectedSubcategory!,
                        name: name,
                        price: price,
                        weight: weight,
                        image: '',
                      );
                    }

                    Navigator.pop(dialogContext);
                  },
                  child: Text(editing ? "Update" : "Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteProduct(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Delete Product"),
        content: Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              ProductData.deleteProduct(
                category: entry['category'],
                subcategory: entry['subcategory'],
                index: entry['index'],
              );
              Navigator.pop(dialogContext);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget productImage(String path) {
    if (path.isEmpty) {
      return Container(
        width: 70,
        height: 70,
        color: Colors.grey.shade300,
        child: Icon(Icons.fastfood),
      );
    }

    return Image.asset(
      path,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 70,
          height: 70,
          color: Colors.grey.shade300,
          child: Icon(Icons.fastfood),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Products",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 99, 7, 7),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 99, 7, 7),
        foregroundColor: Colors.white,
        onPressed: () => showProductDialog(),
        child: Icon(Icons.add),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: ProductData.changes,
        builder: (context, value, child) {
          final items = products;

          if (items.isEmpty) {
            return Center(child: Text("No products added"));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final entry = items[index];
              final product = entry['product'] as Map<String, String>;
              final inStock = product['inStock'] != 'false';

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: productImage(product['image'] ?? ''),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Net wt. ${product['weight']}",
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "₹${product['price']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            inStock ? "In Stock" : "Out of Stock",
                            style: TextStyle(
                              color: inStock ? Colors.greenAccent : Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => showProductDialog(entry: entry),
                          icon: Icon(Icons.edit, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () => deleteProduct(entry),
                          icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                        ),
                        Switch(
                          value: inStock,
                          onChanged: (_) {
                            ProductData.toggleStock(
                              category: entry['category'],
                              subcategory: entry['subcategory'],
                              index: entry['index'],
                            );
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
