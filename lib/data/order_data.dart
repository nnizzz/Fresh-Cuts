
import 'package:flutter/foundation.dart';

class ShopOrder {
  final String id;
  final List<Map<String, dynamic>> items;
  final double total;
  final String address;
  final String paymentMethod;
  final DateTime date;
  String status;

  ShopOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.date,
    this.status = 'Pending',
  });
}

class OrderData {
  static final ValueNotifier<List<ShopOrder>> orders =
      ValueNotifier<List<ShopOrder>>([]);

  static void addOrder(ShopOrder order) {
    orders.value = [...orders.value, order];
  }

  static void updateStatus(String id, String status) {
    orders.value = [
      for (final order in orders.value)
        if (order.id == id)
          ShopOrder(
            id: order.id,
            items: order.items,
            total: order.total,
            address: order.address,
            paymentMethod: order.paymentMethod,
            date: order.date,
            status: status,
          )
        else
          order,
    ];
  }
}
