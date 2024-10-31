import 'package:flutter/material.dart';
import 'package:tapon_merchant/Frontend/Dashboard.dart';
import 'package:tapon_merchant/Frontend/OrderView.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Order',
      'subtitle': 'You have a new order for Coca-Cola. Please check your orders.',
      'orderId': '12345',
      'customerName': 'John Doe',
      'orderDate': '2024-10-01',
      'orderPrice': 150.00,
    },
    {
      'title': 'Order Accepted',
      'subtitle': 'Your order 12345 has been accepted.',
      'orderId': '12345',
      'customerName': 'John Doe',
      'orderDate': '2024-10-01',
      'orderPrice': 150.00,
    },
    {
      'title': 'Order Rejected',
      'subtitle': 'Your order 12346 has been rejected.',
      'orderId': '12346',
      'customerName': 'Jane Smith',
      'orderDate': '2024-10-01',
      'orderPrice': 200.00,
    },
    // Add more sample notifications as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text("Notification Page"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationTile(
            title: notification['title'],
            subtitle: notification['subtitle'],
            orderId: notification['orderId'],
            customerName: notification['customerName'],
            orderDate: notification['orderDate'],
            orderPrice: notification['orderPrice'],
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String orderId;
  final String customerName;
  final String orderDate;
  final double orderPrice;

  const NotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.orderId,
    required this.customerName,
    required this.orderDate,
    required this.orderPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderView(order: {
                'orderId': orderId,
                'customerName': customerName,
                'orderDate': orderDate,
                'orderPrice': orderPrice,
              }),
            ),
          );
        },
      ),
    );
  }
}
