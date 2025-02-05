import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class Register extends StatefulWidget {
  static const String id = 'Register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://apexstore.space/api/register');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Successful registration
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Successful! Please login.")),
      );
      Navigator.pushNamed(context, Login.id);
    } else {
      // Registration failed
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error["message"] ?? "Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black54,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Register to get started',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    _buildTextField(_nameController, 'Name'),
                    const SizedBox(height: 10.0),
                    _buildTextField(_emailController, 'Email'),
                    const SizedBox(height: 10.0),
                    _buildTextField(_passwordController, 'Password', obscureText: true),
                    const SizedBox(height: 20.0),
                    _buildRegisterButton(),
                    const SizedBox(height: 10.0),
                    _buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return MaterialButton(
      color: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(vertical: 15),
      minWidth: double.infinity,
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
              'Register',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
      onPressed: _isLoading ? null : _register,
    );
  }

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, Login.id);
      },
      child: const Text(
        'Already have an account? Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
