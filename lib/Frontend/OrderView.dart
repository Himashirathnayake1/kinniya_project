import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderView extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderView({
    required this.order,
  });

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  TextEditingController _reasonController = TextEditingController();

  void handleAcceptOrder() {
    // Show confirmation alert for accepting the order
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Order Accepted',
      text: 'You have accepted the order.',
      backgroundColor: Colors.black,
      titleColor: Colors.white,
      textColor: Colors.white,
    );

    // Optionally navigate to the dashboard or perform other actions
  }

  void handleRejectOrder() {
    if (_reasonController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Please enter a reason for rejection',
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
      return;
    }

    // Show confirmation alert for rejecting the order
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Order Rejected',
      text: 'You have rejected the order for: ${_reasonController.text}',
      backgroundColor: Colors.black,
      titleColor: Colors.white,
      textColor: Colors.white,
    );

    // Optionally navigate to the dashboard or perform other actions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Booking ID', style: TextStyle(color: Colors.grey)),
                  Text(widget.order['orderId'],
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
              SizedBox(height: 16),
              Text(widget.order['ordername'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Date:', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 8),
                  Text(widget.order['date']),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: const [
                  Text('Time:', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 8),
                  Text('12:00 PM'),
                ],
              ),
              SizedBox(height: 25),

              // Customer Details
              Text(
                "About Customer",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Customer Details'),
                      trailing: TextButton(
                        onPressed: () {
                          // Implement navigation to map or directions page
                        },
                        child: Text('Get Direction'),
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(widget.order['customername']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.order['customermobile'],
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              launchUrl(Uri.parse(
                                  'sms:${widget.order['customermobile']}'));
                            },
                            icon: Icon(Icons.chat),
                            label: Text('Chat'),
                          ),
                          IconButton(
                            icon: Icon(Icons.phone),
                            onPressed: () {
                              launchUrl(Uri.parse(
                                  'tel:${widget.order['customermobile']}'));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Price Details
              Text('Price Detail', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildPriceRow('Price',
                        '${widget.order['price'] / widget.order['days']} x ${widget.order['days']} = ${widget.order['price']}'),
                    Divider(),
                    _buildPriceRow('Sub Total', '${widget.order['price']}'),
                    Divider(),
                    _buildPriceRow('Total Amount', '${widget.order['price']}',
                        isBold: true),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              // Accept and Reject Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: handleAcceptOrder,
                    child: Text('Accept Order'),
                  ),
                  ElevatedButton(
                    onPressed: handleRejectOrder,
                    child: Text('Reject Order'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Reason for rejection input
              if (_reasonController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _reasonController,
                    decoration: InputDecoration(
                      labelText: 'Reason for Rejection',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String price, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
