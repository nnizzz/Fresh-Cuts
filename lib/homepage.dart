
import 'package:flutter/material.dart';
import 'package:meat_shop/admin/login.dart';
import 'package:meat_shop/data/cart_data.dart';
import 'package:meat_shop/cartpage.dart';
import 'package:meat_shop/category.dart';
import 'package:meat_shop/data/product_data.dart';

class homescrnx extends StatefulWidget {
  const homescrnx({super.key});

  @override
  State<homescrnx> createState() => _homescrnxState();
}

class _homescrnxState extends State<homescrnx> {
  final List<String> cate = [
    'Poultry',
    'Red Meat',
    'Sea Food',
    'Processed',
    'Boneless',
    'Ready-To-Cook',
  ];

  final List<String> cimg = [
    'assets/images/mchicken.jpg',
    'assets/images/mredmeat.jpg',
    'assets/images/mseafood.jpg',
    'assets/images/mprocessed.jpg',
    'assets/images/mboneless.jpg',
    'assets/images/mready.jpg',
  ];

  final List<String> prod = [
    'Chicken Drumstick',
    'Mutton Chops',
    'Beef Steak',
    'Salmon',
    'Pork Bacon',
  ];

  final List<String> prodimg = [
    'assets/images/chickenb.jpg',
    'assets/images/muttonch.jpg',
    'assets/images/beefsteak.jpg',
    'assets/images/salmonfresh.jpg',
    'assets/images/bacon.jpg',
  ];

  int selectedCategory = 0;
  int selectedProduct = 0;

  Map<String, String>? findPopularProduct(String name) {
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

  Widget buildImage(String path, {double width = 70, double height = 70}) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade800,
          child: Icon(Icons.fastfood, color: Colors.white70),
        );
      },
    );
  }

  void addPopularProduct(Map<String, String>? product, String name) {
    if (product == null || product['inStock'] == 'false') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$name is currently out of stock"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    CartData.addProduct({
      'name': product['name'] ?? '',
      'price': product['price'] ?? '0',
      'weight': product['weight'] ?? '',
      'image': product['image'] ?? '',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$name added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Text(
                      'Address...',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      },
                      icon: Icon(
                        Icons.admin_panel_settings,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cartsx()),
                        );
                      },
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Fresh Meat Category..',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: GridView.builder(
                itemCount: cate.length,
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  bool isSelected = selectedCategory == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedCategory = index);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(
                            categoryName: cate[index],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: ClipOval(
                              child: buildImage(
                                cimg[index],
                                width: 75,
                                height: 75,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          cate[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Popular/Best Sellers...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            ValueListenableBuilder<int>(
              valueListenable: ProductData.changes,
              builder: (context, value, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: prod.length,
                  itemBuilder: (context, index) {
                    final product = findPopularProduct(prod[index]);
                    final inStock =
                        product != null && product['inStock'] != 'false';
                    final isSelected = selectedProduct == index;

                    final price = product?['price'] ?? '0';
                    final weight = product?['weight'] ?? '750g';
                    final image = product?['image'] ?? prodimg[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedProduct = index);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color.fromARGB(255, 157, 142, 142)
                              : Color.fromARGB(255, 25, 25, 25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: buildImage(
                                image,
                                width: 70,
                                height: 70,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    prod[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    inStock ? "In Stock" : "Out of Stock",
                                    style: TextStyle(
                                      color: inStock
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Net wt. $weight",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        "₹$price",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      if (double.tryParse(price) != null)
                                        Text(
                                          "₹${(double.parse(price) + 50).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationColor: Colors.white70,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => addPopularProduct(
                                product,
                                prod[index],
                              ),
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  inStock ? Icons.add : Icons.block,
                                  color: inStock
                                      ? Colors.white
                                      : Colors.redAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
