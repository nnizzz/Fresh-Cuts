
import 'package:flutter/material.dart';
import 'package:meat_shop/homepage.dart';
import 'package:meat_shop/category.dart';
import 'package:meat_shop/order_cus.dart';
import 'package:meat_shop/profile.dart';

class navixs extends StatefulWidget {
  final int initialIndex;

  const navixs({super.key, this.initialIndex = 0});

  @override
  State<navixs> createState() => _navixsState();
}

class _navixsState extends State<navixs> {
  late int selectedIndex;

@override
void initState() {
  super.initState();
  selectedIndex = widget.initialIndex;
}

  final List<Widget> pages = [
    homescrnx(),
    CategoryScreen(),
    ordersxs(),
    profilexs(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 99, 7, 7),
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        selectedFontSize: 13,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
