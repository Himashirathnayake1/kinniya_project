import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String selectedDateFilter = 'Date'; // To store the selected date filter
  String orderIdFilter = '';

  // Sample list of all orders for the merchant.
  List<Map<String, dynamic>> allOrders = [
    {
      'status': 'COMPLETED',
      'subStatus': 'RETURN CUSTOMER',
      'orderId': '162267901',
      'date': '12 Sept 2024, 9:31 am',
      'ordername': 'Plumbing Services',
      'statusColor': Colors.green,
      'dateFilter': 'Today',
    },
    {
      'status': 'COMPLETED',
      'subStatus': 'NEW CUSTOMER',
      'orderId': '162250430',
      'date': '11 Sept 2024, 12:15 pm',
      'ordername': 'Electrical Repair',
      'statusColor': Colors.green,
      'dateFilter': 'Yesterday',
    },
    {
      'status': 'CANCELLED',
      'subStatus': 'NEW CUSTOMER',
      'reason': 'Changed Mind',
      'orderId': '162246651',
      'date': '11 Sept 2024, 8:36 am',
      'ordername': 'Cleaning Service',
      'statusColor': Colors.red,
      'dateFilter': 'Yesterday',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadUserData(); // Optional: if you want to load user-specific preferences
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Example of how you could load saved user data if necessary
    // For now, this function does not modify data.
  }

  @override
  Widget build(BuildContext context) {
    // Filter the orders based on the selected date filter
    List<Map<String, dynamic>> filteredOrders = allOrders.where((order) {
      // Check if selected date filter matches the order's date filter
      bool matchesDateFilter = selectedDateFilter == 'Date' ||
          order['dateFilter'] == selectedDateFilter;
      // Check if the Order ID matches the input
      bool matchesOrderId =
          orderIdFilter.isEmpty || order['orderId'].contains(orderIdFilter);

      return matchesDateFilter && matchesOrderId;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Service History'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Date filter dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Date', 'Today', 'Yesterday']
                        .map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDateFilter = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                // Search field for Order ID
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Order ID',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        orderIdFilter = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                // Reset Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDateFilter = 'Date';
                      orderIdFilter = ''; // Reset filter
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                var order = filteredOrders[index];
                return orderItem(
                  status: order['status'],
                  subStatus: order['ordername'],
                  reason: order['reason'] ?? '',
                  orderId: order['orderId'],
                  date: order['date'],
                  ordername: order['ordername'],
                  statusColor: order['statusColor'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget orderItem({
    required String status,
    String? subStatus,
    String? reason,
    required String orderId,
    required String date,
    required String ordername,
    required Color statusColor,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 8),
                if (subStatus != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 224, 224, 224),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(subStatus),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text('Order ID: $orderId'),
            Text(date),
            if (reason != null && reason.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                reason,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
