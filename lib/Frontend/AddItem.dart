import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AddItem extends StatefulWidget {
  final Map<String, dynamic>? item;

  const AddItem({Key? key, this.item}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  String itemName = '';
  String itemDescription = '';
  String selectedCategory = 'Beverage';
  int itemPrice = 0;
  int itemQuantity = 0;
  int itemDiscount = 0;
  String itemAddress = '';
  String itemBrand = '';
  File? _imageFile;

  List<String> categories = [
    'Grocery',
    'Beverage',
    'Snack',
    'Dairy',
    'Bakery',
    'Anchor',
    'CBL',
    'Household',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      itemName = widget.item!['name'];
      itemDescription = widget.item!['description'] ?? '';
      selectedCategory = widget.item!['category'] ?? 'Beverage';
      itemPrice = widget.item!['price'] ?? 0;
      itemQuantity = widget.item!['quantity'] ?? 0;
      itemDiscount = widget.item!['discount'] ?? 0;
      itemAddress = widget.item!['address'] ?? '';
      itemBrand = widget.item!['brand'] ?? '';
      if (widget.item!['image'] != null) {
        _imageFile = File(widget.item!['image']);
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? token = await getToken();
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not authenticated')));
          return;
        }

        double discountAmount = itemPrice * (itemDiscount / 100);
        double finalPrice = itemPrice - discountAmount;

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://10.11.29.164:5000/api/v1/items/items'),
        );

        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Content-Type'] = 'application/json';
        request.fields['name'] = itemName;
        request.fields['description'] = itemDescription;
        request.fields['category'] = selectedCategory;
        request.fields['price'] = itemPrice.toString();
        request.fields['quantity'] = itemQuantity.toString();
        request.fields['discount'] = itemDiscount.toString();
        request.fields['address'] = itemAddress;
        request.fields['brand'] = itemBrand;

        if (_imageFile != null) {
          request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
        }

        var response = await request.send();
        final responseData = await http.Response.fromStream(response);

        if (response.statusCode == 201 || response.statusCode == 200) {
          final result = json.decode(responseData.body);
          Navigator.pop(context, {
            'name': itemName,
            'description': itemDescription,
            'category': selectedCategory,
            'price': itemPrice,
            'quantity': itemQuantity,
            'discount': itemDiscount,
            'address': itemAddress,
            'brand': itemBrand,
            'image': _imageFile?.path,
          });
        } else {
          print('Server Error: ${responseData.body}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${responseData.body}')));
        }
      } catch (error) {
        print('Error occurred: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error occurred while saving item')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields and select an image')));
    }
  }

  double getDiscountAmount() {
    return itemPrice * (itemDiscount / 100);
  }

  double getFinalPrice() {
    return itemPrice - getDiscountAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item == null ? 'Add New Item' : 'Edit Item',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.teal.shade700),
                ),
                SizedBox(height: 20),
                _buildTextFormField('Item Name', (value) => itemName = value, initialValue: itemName),
                _buildTextFormField('Description', (value) => itemDescription = value, initialValue: itemDescription),
                _buildDropdownFormField(),
                _buildTextFormField('Price (Rs.)', (value) => itemPrice = int.tryParse(value) ?? 0, isNumeric: true, initialValue: itemPrice.toString()),
                _buildTextFormField('Quantity', (value) => itemQuantity = int.tryParse(value) ?? 0, isNumeric: true, initialValue: itemQuantity.toString()),
                _buildTextFormField('Discount (%)', (value) => itemDiscount = int.tryParse(value) ?? 0, initialValue: itemDiscount.toString()),
                _buildTextFormField('Address', (value) => itemAddress = value, initialValue: itemAddress),
                _buildTextFormField('Brand', (value) => itemBrand = value, initialValue: itemBrand),
                SizedBox(height: 20),
                Text(
                  'Discount Amount: Rs. ${getDiscountAmount().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, color: Colors.green.shade700),
                ),
                Text(
                  'Final Price: Rs. ${getFinalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 40),
                    minimumSize: Size(200, 50),
                    ),
                    icon: Icon(Icons.image),
                    label: Text('Pick Image'),
                  ),
                ),
                SizedBox(height: 10),
                if (_imageFile != null)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
                  ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 40),
                      minimumSize: Size(200, 50),
                    ),
                    child: Text('Save Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, Function(String) onChanged, {bool isNumeric = false, String? initialValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.teal.shade50,
        ),
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdownFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.teal.shade50,
        ),
        items: categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue!;
          });
        },
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }
}
