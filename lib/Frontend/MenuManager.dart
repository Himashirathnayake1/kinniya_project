import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tapon_merchant/Frontend/AddItem.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MenuManager extends StatefulWidget {
  const MenuManager({super.key});

  @override
  _MenuManagerState createState() => _MenuManagerState();
}

class _MenuManagerState extends State<MenuManager> {
  List<Map<String, dynamic>> foodItems = [];
  bool isLoading = true; // Loading state
  String? errorMessage; // Error message state

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products when the page loads
  }

  // Fetch products from the backend
  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true; // Set loading state
    });

    try {
      final response = await http.get(Uri.parse('http://10.11.29.164:5000/api/v1/items/items'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          foodItems = List<Map<String, dynamic>>.from(data);
          isLoading = false; // Set loading state to false
        });
      } else {
        setState(() {
          isLoading = false; // Set loading state to false
          errorMessage = 'Error loading products'; // Set error message
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Set loading state to false
        errorMessage = 'Error: $error'; // Set error message
      });
    }
  }

  // Method to add a new item or edit an existing one
  void _openItemForm(BuildContext context, {Map<String, dynamic>? item}) async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItem(item: item),
      ),
    );

    if (newItem != null) {
      if (item == null) {
        // Add new item
        setState(() {
          foodItems.add(newItem);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${newItem['name']} added!')));
      } else {
        // Update existing item
        setState(() {
          int index = foodItems.indexOf(item);
          foodItems[index] = newItem; // Update item at the existing index
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${newItem['name']} updated!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Manager'),
        backgroundColor: Colors.amber,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) // Display error message
              : ListView.builder(
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    final item = foodItems[index];
                    return ListTile(
                      title: Text(item['name']),
                      subtitle: Text('Price: \$${item['price']}'),
                      leading: item['image'] != null
                          ? Image.file(File(item['image']), width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.fastfood),
                      onTap: () => _openItemForm(context, item: item), // Edit item on tap
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openItemForm(context), // Open AddItem form
        child: Icon(Icons.add),
      ),
    );
  }
}
