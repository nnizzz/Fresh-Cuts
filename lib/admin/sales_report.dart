
import 'package:flutter/material.dart';
import 'package:meat_shop/data/order_data.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  String selectedFilter = 'All';

  final Color maroon = Color.fromARGB(255, 99, 7, 7);

  final List<String> filters = [
    'All',
    'Pending',
    'Confirmed',
    'Preparing',
    'Out for Delivery',
    'Delivered',
    'Cancelled',
  ];

  Widget summaryCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: maroon,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      default:
        return maroon;
    }
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 245, 245),
      appBar: AppBar(
        title: Text(
          "Sales Report",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: maroon,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder<List<ShopOrder>>(
        valueListenable: OrderData.orders,
        builder: (context, orders, child) {
          final totalOrders = orders.length;

          final deliveredOrders = orders
              .where((order) => order.status == 'Delivered')
              .toList();

          final pendingOrders = orders
              .where((order) =>
                  order.status != 'Delivered' &&
                  order.status != 'Cancelled')
              .length;

          final cancelledOrders = orders
              .where((order) => order.status == 'Cancelled')
              .length;

          final totalRevenue = deliveredOrders.fold<double>(
            0,
            (sum, order) => sum + order.total,
          );

          final filteredOrders = orders.where((order) {
            return selectedFilter == 'All' ||
                order.status == selectedFilter;
          }).toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text(
                "Sales Overview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: maroon,
                ),
              ),
              SizedBox(height: 15),

              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.35,
                children: [
                  summaryCard(
                    "Total Revenue",
                    "₹${totalRevenue.toStringAsFixed(2)}",
                    Icons.currency_rupee,
                  ),
                  summaryCard(
                    "Total Orders",
                    "$totalOrders",
                    Icons.shopping_bag,
                  ),
                  summaryCard(
                    "Delivered Orders",
                    "${deliveredOrders.length}",
                    Icons.check_circle,
                  ),
                  summaryCard(
                    "Pending Deliveries",
                    "$pendingOrders",
                    Icons.local_shipping,
                  ),
                  summaryCard(
                    "Cancelled Orders",
                    "$cancelledOrders",
                    Icons.cancel,
                  ),
                ],
              ),

              SizedBox(height: 25),
              Text(
                "Sales History",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: maroon,
                ),
              ),
              SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedFilter,
                decoration: InputDecoration(
                  labelText: "Filter by Status",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: filters.map((filter) {
                  return DropdownMenuItem(
                    value: filter,
                    child: Text(filter),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedFilter = value ?? 'All');
                },
              ),

              SizedBox(height: 15),

              if (filteredOrders.isEmpty)
                Container(
                  padding: EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 55,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No sales data available",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...filteredOrders.map((order) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Order #${order.id}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor(order.status)
                                    .withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(
                                  color: statusColor(order.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 22),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(order.date),
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            Text(
                              "₹${order.total.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: maroon,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${order.items.length} product types",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Payment: ${order.paymentMethod}",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
