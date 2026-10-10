
import 'package:flutter/material.dart';
import 'package:meat_shop/data/order_data.dart';
import 'package:meat_shop/navigation.dart';

class ordersxs extends StatelessWidget {
  const ordersxs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
  title: Text("My Orders",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  backgroundColor: Color.fromARGB(255, 99, 7, 7),
  automaticallyImplyLeading: false,
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => navixs()),
        (route) => false,
      );
    },
  ),
),
      body: ValueListenableBuilder<List<ShopOrder>>(
        valueListenable: OrderData.orders,
        builder: (context, orders, child) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 75, color: Colors.grey),
                  SizedBox(height: 15),
                  Text("No orders yet",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Your orders will appear here",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[orders.length - 1 - index];

              return Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order #${order.id}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: order.status == "Delivered"
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              color: order.status == "Delivered"
                                  ? Colors.green.shade800
                                  : Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 25),
                    ...order.items.map((item) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${item['name']} x${item['quantity']}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Text("₹${item['price']}"),
                            ],
                          ),
                        )),
                    Divider(),
                    Text("Total: ₹${order.total.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 99, 7, 7))),
                    SizedBox(height: 10),
                    Text("Delivery: ${order.address}",
                        style: TextStyle(fontSize: 13)),
                    SizedBox(height: 5),
                    Text("Payment: ${order.paymentMethod}",
                        style: TextStyle(fontSize: 13)),
                    SizedBox(height: 5),
                    Text(
                      "Date: ${order.date.day}/${order.date.month}/${order.date.year}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
