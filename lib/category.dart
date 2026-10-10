
import 'package:flutter/material.dart';
import 'package:meat_shop/data/data.dart';
import 'package:meat_shop/products.dart';

class CategoryScreen extends StatelessWidget {
  final String? categoryName;
  const CategoryScreen({super.key, this.categoryName});

  @override
  Widget build(BuildContext context) {
    final categories = meatdata.meatData.keys.toList();

    if (categoryName == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Categories', style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 99, 7, 7),
        ),
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
          child: GridView.builder(
            padding: EdgeInsets.all(12),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final name = categories[index];
              final image = meatdata.meatData[name]!['subcategories'][0]['image'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryScreen(categoryName: name),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage(image),
                    ),
                    SizedBox(height: 8),
                    Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }

    final categoryData = meatdata.meatData[categoryName]!;
    final List subCategories = categoryData['subcategories'];
    final Map productsMap = categoryData['products'];

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName!, style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 99, 7, 7),
      ),
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
        child: GridView.builder(
          padding: EdgeInsets.all(12),
          itemCount: subCategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final sub = subCategories[index];
            final name = sub['name'] as String;
            final image = sub['image'] as String;

            return GestureDetector(
              onTap: () {
                final List<Map<String, String>> products =
                    (productsMap[name] as List? ?? [])
                        .map((item) => Map<String, String>.from(item))
                        .toList();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(
                      subCategoryName: name,
                      products: products,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage(image),
                  ),
                  SizedBox(height: 8),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
