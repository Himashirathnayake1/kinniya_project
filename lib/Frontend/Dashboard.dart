import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapon_merchant/Frontend/AddItem.dart';
import 'package:tapon_merchant/Frontend/Login.dart';
import 'package:tapon_merchant/Frontend/MenuManager.dart';
import 'package:tapon_merchant/Frontend/Notification.dart'
    as custom_notification;
import 'package:tapon_merchant/Frontend/OrderHistory.dart';
import 'package:tapon_merchant/Frontend/Profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userName = '';
  List<Map<String, dynamic>> orders = [
    {
      'subStatus': '2ND ORDER',
      'orderId': '162267901',
      'date': '12 Sept 2024, 9:31 am',
      'ordername': 'Sanitize full home',
      'statusColor': Colors.brown,
      'customername': 'Rishaf',
      'customermobile': '0755354023',
      'customerLocation': 'No-2, Kinniya',
    },
    {
      'subStatus': '1ST ORDER',
      'orderId': '152267845',
      'date': '10 Sept 2024, 11:00 am',
      'ordername': 'House Cleaning',
      'statusColor': Colors.green,
      'customername': 'Ishara',
      'customermobile': '0785243950',
      'customerLocation': 'No-45, Colombo',
    },
    // Additional sample orders as needed
  ];

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('serviceProviderName') ?? 'N/A';
    setState(() {
      userName = name;
    });
  }

  @override
  void dispose() {
    orders.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'TapOn Provider',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Incoming Orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow[700],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 40,
                    child: ClipOval(
                      child: Image.asset(
                        'profile.png',
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Order History'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderHistory()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Service'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddItem()));
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Service Manager'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MenuManager()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const custom_notification.Notification()));
              },
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Provider Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
            ),
            const SizedBox(
              height: 25,
            ),
            const SizedBox(height: 16.0),
            ListTile(            
              title: Text('Log Out'),
              trailing: IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>Login()));
                  }),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return orderItem(
                      context: context,
                      subStatus: orders[index]['subStatus'],
                      orderId: orders[index]['orderId'],
                      date: orders[index]['date'],
                      ordername: orders[index]['ordername'],
                      statusColor: orders[index]['statusColor'],
                      customername: orders[index]['customername'],
                      customermobile: orders[index]['customermobile'],
                      customerLocation: orders[index]['customerLocation'],
                      order: orders[index],
                    );
                  }),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Your orders show here'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 255, 214, 7),
        child: const Text(
          'Accept',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget orderItem({
    required BuildContext context,
    required String subStatus,
    required String orderId,
    required String date,
    required String customername,
    required String customermobile,
    required String customerLocation,
    required String ordername,
    required MaterialColor statusColor,
    required Map<String, dynamic> order,
  }) {
    return Card(
      child: ListTile(
        title: Text(ordername),
        subtitle: Text('$customername • $date • $customerLocation'),
        trailing: Text(subStatus),
      ),
    );
  }
}
