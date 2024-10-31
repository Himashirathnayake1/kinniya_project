import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapon_merchant/Frontend/Dashboard.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for profile fields
  TextEditingController businessNameController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productCategoryController = TextEditingController();

  File? _image;

  // Boolean flags to toggle the editability of each field
  bool isPhoneEditable = false;
  bool isOwnerNameEditable = false;
  bool isBusinessNameEditable = false;
  bool isAddressEditable = false;
  bool isEmailEditable = false;
  bool isProductDescriptionEditable = false;
  bool isProductCategoryEditable = false;

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // Fetch user profile when the widget is initialized
  }

  // Function to fetch user profile data
  Future<void> fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'User not authenticated. Please log in again.',
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.11.29.164:5000/api/v1/merchants/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          phoneController.text = data['phone'] ?? '';
          ownerNameController.text = data['owner_name'] ?? '';
          businessNameController.text = data['business_name'] ?? '';
          addressController.text = data['address'] ?? '';
          emailController.text = data['email'] ?? '';
          productDescriptionController.text = data['product_description'] ?? '';
          productCategoryController.text = data['product_category'] ?? '';
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to load profile. Status: ${response.statusCode}.',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'An error occurred while loading the profile. Please try again later.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Provider Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade200, Colors.green.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _image == null ? AssetImage("assets/profile_placeholder.png") : FileImage(_image!),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    label: Text('Change Profile Picture', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildEditableTile('Phone Number', phoneController, isPhoneEditable, () {
                    setState(() {
                      isPhoneEditable = !isPhoneEditable;
                    });
                  }),
                  buildEditableTile('Owner Name', ownerNameController, isOwnerNameEditable, () {
                    setState(() {
                      isOwnerNameEditable = !isOwnerNameEditable;
                    });
                  }),
                  buildEditableTile('Business Name', businessNameController, isBusinessNameEditable, () {
                    setState(() {
                      isBusinessNameEditable = !isBusinessNameEditable;
                    });
                  }),
                  buildEditableTile('Address', addressController, isAddressEditable, () {
                    setState(() {
                      isAddressEditable = !isAddressEditable;
                    });
                  }),
                  buildEditableTile('Email', emailController, isEmailEditable, () {
                    setState(() {
                      isEmailEditable = !isEmailEditable;
                    });
                  }),
                  buildEditableTile('Product Description', productDescriptionController, isProductDescriptionEditable, () {
                    setState(() {
                      isProductDescriptionEditable = !isProductDescriptionEditable;
                    });
                  }),
                  buildEditableTile('Product Category', productCategoryController, isProductCategoryEditable, () {
                    setState(() {
                      isProductCategoryEditable = !isProductCategoryEditable;
                    });
                  }),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          handleUpdateUserProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<XFile>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(await picker.pickImage(source: ImageSource.camera));
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(await picker.pickImage(source: ImageSource.gallery));
              },
              child: Text('Gallery'),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Placeholder function for handling profile update
  void handleUpdateUserProfile() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Profile updated successfully',
    );
  }

  // Function to build an editable/non-editable tile
  Widget buildEditableTile(String label, TextEditingController controller, bool isEditable, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.edit, color: Colors.green[700]),
        title: isEditable
            ? TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              )
            : GestureDetector(
                onTap: onTap,
                child: Text(
                  controller.text.isEmpty ? 'Add $label' : controller.text,
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
        trailing: IconButton(
          icon: Icon(
            isEditable ? Icons.check : Icons.edit,
            color: isEditable ? Colors.green[700] : Colors.grey,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
