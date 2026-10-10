import 'package:flutter/material.dart';
import 'package:meat_shop/admin/login.dart';
import 'package:meat_shop/admin/order.dart';
import 'package:meat_shop/admin/products.dart';
import 'package:meat_shop/admin/sales_report.dart';
import 'package:meat_shop/data/data.dart';
import 'package:meat_shop/data/order_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: const Color.fromARGB(255, 99, 7, 7),
      ),

      // ✅ REQUIRED FIX ADDED HERE
      drawer: const AdminDrawer(),

      
body: ValueListenableBuilder<List<ShopOrder>>(
  valueListenable: OrderData.orders,
  builder: (context, orders, child) {
    final totalOrders = orders.length;
    final totalProducts = meatdata.meatData.values.fold<int>(0, (total, category) {
  final products = category['products'] as Map;
  return total + products.values.fold<int>(
    0,
    (count, items) => count + (items as List).length,
  );
});

    final totalSales = orders
        .where((order) => order.status == 'Delivered')
        .fold<double>(0, (sum, order) => sum + order.total);

    final pendingDeliveries = orders
        .where((order) =>
            order.status != 'Delivered' &&
            order.status != 'Cancelled')
        .length;

    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.3,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SummaryCard(
                title: "Total Orders",
                value: "$totalOrders",
                icon: Icons.shopping_cart,
                color: Colors.blue,
              ),
              SummaryCard(
                title: "Total Sales",
                value: "₹${totalSales.toStringAsFixed(2)}",
                icon: Icons.currency_rupee,
                color: Colors.green,
              ),
              SummaryCard(
                title: "Total Products",
                value: "$totalProducts",
                icon: Icons.inventory,
                color: Colors.orange,
              ),
              SummaryCard(
                title: "Pending Deliveries",
                value: "$pendingDeliveries",
                icon: Icons.local_shipping,
                color: Colors.red,
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Welcome Admin 👋",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  },
),
    );
  }
}

// -------- REUSABLE CARD WIDGET --------
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ICON
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),

            const SizedBox(height: 10),

            // VALUE
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // TITLE
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- DRAWER ----------------
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

          // HEADER
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 99, 7, 7),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.admin_panel_settings,
                    color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  "Admin Panel",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "admin@email.com",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // DASHBOARD
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen()),
              );
            },
          ),

          // PRODUCTS
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("Products"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  AdminProductsPage()),
              );
            },
          ),

          // ORDERS
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text("Orders"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  AdminOrdersPage()),
              );
            },
          ),

          // SALES REPORT
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Sales Report"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  SalesReportPage()),
              );
            },
          ),

           Divider(),

          // LOGOUT
          ListTile(
            leading:  Icon(Icons.logout, color: Colors.red),
            title:  Text("Logout"),
            onTap: () {
               Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => login(),
    ),
    (route) => false,
  );
            },
          ),
        ],
      ),
    );
  }
}