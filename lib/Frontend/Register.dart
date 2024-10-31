//http://localhost:5000/api/v1/items/items
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController productCategoryController = TextEditingController();
  
  bool isAgreed = false;

  // Method to handle registration process
  Future<void> registerMerchant() async {
    if (_formKey.currentState!.validate() && isAgreed) {
      // Prepare merchant data
      Map<String, dynamic> merchantData = {
        "business_name": businessNameController.text,
        "owner_name": ownerNameController.text,
        "phone": phoneController.text,
        "address": addressController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "product_description": productDescriptionController.text,
        "product_category": productCategoryController.text,
      };

      // registration logic (e.g., API call)
       try {
        final response = await http.post(
          Uri.parse('http://10.11.29.164:5000:5000/api/v1/merchants/register'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(merchantData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration successful!"))
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration failed: ${jsonDecode(response.body)['message']}"))
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e"))
        );
      }
      // Show success message or navigate to another page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merchant Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: businessNameController,
                labelText: 'Business Name',
                hintText: 'Enter your business name',
                icon: Icons.business,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: ownerNameController,
                labelText: 'Owner Name',
                hintText: 'Enter your name',
                icon: Icons.person,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: phoneController,
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                icon: Icons.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: addressController,
                labelText: 'Address',
                hintText: 'Enter your business address',
                icon: Icons.home,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                icon: Icons.lock,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
                obscureText: true,
                icon: Icons.lock,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: productDescriptionController,
                labelText: 'Product Description',
                hintText: 'Describe the products you sell',
                maxLines: 3,
                icon: Icons.description,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: productCategoryController,
                labelText: 'Product Category',
                hintText: 'Enter product category (e.g., Beverages)',
                icon: Icons.category,
              ),
              const SizedBox(height: 16.0),
              // Terms and Conditions checkbox
              CheckboxListTile(
                title: Text("I agree to the Terms and Conditions"),
                value: isAgreed,
                onChanged: (bool? value) {
                  setState(() {
                    isAgreed = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: registerMerchant,
                
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    IconData? icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
