import 'package:flutter/material.dart';
import 'package:meat_shop/data/cart_data.dart';
import 'package:meat_shop/confirmation.dart';
import 'package:meat_shop/data/order_data.dart';
import 'package:meat_shop/data/product_data.dart';


class PaymentPage extends StatefulWidget {
  final String address;

  const PaymentPage({super.key, required this.address});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  int paymentMethod = 0;

  int selectedBank = 1;
  int selectedCard = 1;
  int selectedUpi = 1;

  String get selectedPaymentMethod {
  if (paymentMethod == 1) {
    return ['SBI', 'Federal Bank', 'South Indian Bank'][selectedBank - 1];
  }
  if (paymentMethod == 2) {
    return ['Visa', 'Mastercard'][selectedCard - 1];
  }
  if (paymentMethod == 3) {
    return ['Google Pay', 'PhonePe', 'Paypal'][selectedUpi - 1];
  }
  return '';
}


void confirmPayment() {
  if (paymentMethod == 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please select a payment method")),
    );
    return;
  }

  if (CartData.items.value.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Your cart is empty")),
    );
    return;
  }

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

  final updatedItems = <Map<String, dynamic>>[];
  bool priceChanged = false;

  for (final item in CartData.items.value) {
    final name = item['name'].toString();
    final product = findProduct(name);

    if (product == null || product['inStock'] == 'false') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$name is unavailable. Please update your cart."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final latestPrice = double.tryParse(product['price'] ?? '');
    if (latestPrice == null || latestPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid price for $name")),
      );
      return;
    }

    final previousPrice = (item['price'] as num).toDouble();
    if ((latestPrice - previousPrice).abs() > 0.001) {
      priceChanged = true;
    }

    updatedItems.add({
      ...item,
      'price': latestPrice,
      'weight': product['weight'] ?? item['weight'],
      'image': product['image'] ?? item['image'],
    });
  }

  if (priceChanged) {
    CartData.items.value = updatedItems;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Product prices have changed. Please review your updated cart.",
        ),
      ),
    );
    Navigator.pop(context);
    return;
  }

  final total = updatedItems.fold<double>(
    0,
    (sum, item) =>
        sum + (item['price'] as num).toDouble() * (item['quantity'] as int),
  );

  final order = ShopOrder(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    items: updatedItems,
    total: total,
    address: widget.address,
    paymentMethod: selectedPaymentMethod,
    date: DateTime.now(),
  );

  OrderData.addOrder(order);
  CartData.clearCart();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => OrderSuccessPage(
        orderId: order.id,
        total: order.total,
      ),
    ),
    (route) => false,
  );
}


  Widget radioCard({
    required String title,
    required String subtitle,
    required int value,
    required int groupValue,
    required Function(int?) onChanged,
    required IconData icon,
  }) {

    bool isSelected = value == groupValue;

    return Container(
      margin:  EdgeInsets.only(bottom: 12),
      padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? Colors.black
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: RadioListTile(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor:  Color.fromARGB(255, 204, 72, 120),
        contentPadding: EdgeInsets.zero,
        secondary: Icon(icon),
        title: Text(
          title,
          style:  TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style:  TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 200, 200, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 99, 7, 7),
        title:  Text(
          "Payment",
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: ListView(
        padding:  EdgeInsets.all(20),
        children: [
           Text(
            "Payment Method",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

           SizedBox(height: 10),

          RadioListTile(
            title: Text("Bank Transfer",style: TextStyle(fontWeight: FontWeight.w900),),
            value: 1,
            groupValue: paymentMethod,
            activeColor: Color.fromARGB(255, 99, 7, 7),
            onChanged: (value) {
              setState(() {
                paymentMethod = value!;
              });
            },
          ),

          if (paymentMethod == 1)
            Padding(
              padding:  EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  radioCard(
                    title: "SBI",
                    subtitle: "Checked Automatically",
                    icon: Icons.account_balance,
                    value: 1,
                    groupValue: selectedBank,
                    onChanged: (value) {
                      setState(() {
                        selectedBank = value!;
                      });
                    },
                  ),

                  radioCard(
                    title: "Federal Bank",
                    subtitle: "Checked Automatically",
                    icon: Icons.account_balance,
                    value: 2,
                    groupValue: selectedBank,
                    onChanged: (value) {
                      setState(() {
                        selectedBank = value!;
                      });
                    },
                  ),

                  radioCard(
                    title: "South Indian Bank",
                    subtitle: "Checked Automatically",
                    icon: Icons.account_balance,
                    value: 3,
                    groupValue: selectedBank,
                    onChanged: (value) {
                      setState(() {
                        selectedBank = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            Divider(color: Colors.black,),

          RadioListTile(
            title: Text("Credit / Debit Card",style: TextStyle(fontWeight: FontWeight.w900),),
            value: 2,
            groupValue: paymentMethod,
            activeColor: Color.fromARGB(255, 99, 7, 7),
            onChanged: (value) {
              setState(() {
                paymentMethod = value!;
              });
            },
          ),

          if (paymentMethod == 2)
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  radioCard(
                    title: "Visa",
                    subtitle: "Secure payment",
                    icon: Icons.credit_card,
                    value: 1,
                    groupValue: selectedCard,
                    onChanged: (value) {
                      setState(() {
                        selectedCard = value!;
                      });
                    },
                  ),

                  radioCard(
                    title: "Mastercard",
                    subtitle: "Secure payment",
                    icon: Icons.credit_card,
                    value: 2,
                    groupValue: selectedCard,
                    onChanged: (value) {
                      setState(() {
                        selectedCard = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            Divider(color: Colors.black,),

          RadioListTile(
            title:  Text("UPI / Paypal",style: TextStyle(fontWeight: FontWeight.w900),),
            value: 3,
            groupValue: paymentMethod,
            activeColor: Color.fromARGB(255, 99, 7, 7),
            onChanged: (value) {
              setState(() {
                paymentMethod = value!;
              });
            },
          ),

          if (paymentMethod == 3)
            Padding(
              padding:  EdgeInsets.only(left: 10),
              child: Column(
                children: [

                  radioCard(
                    title: "Google Pay",
                    subtitle: "Fast payment",
                    icon: Icons.account_balance_wallet,
                    value: 1,
                    groupValue: selectedUpi,
                    onChanged: (value) {
                      setState(() {
                        selectedUpi = value!;
                      });
                    },
                  ),

                  radioCard(
                    title: "PhonePe",
                    subtitle: "Fast payment",
                    icon: Icons.account_balance_wallet,
                    value: 2,
                    groupValue: selectedUpi,
                    onChanged: (value) {
                      setState(() {
                        selectedUpi = value!;
                      });
                    },
                  ),

                  radioCard(
                    title: "Paypal",
                    subtitle: "Online payment",
                    icon: Icons.account_balance_wallet,
                    value: 3,
                    groupValue: selectedUpi,
                    onChanged: (value) {
                      setState(() {
                        selectedUpi = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

          SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 99, 7, 7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: confirmPayment,
              child: Text(
                "Confirm Payment",
                style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
                
              ),
            ),
          )
        ],
      ),
    );
  }
}