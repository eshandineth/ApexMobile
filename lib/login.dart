import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'register.dart';

class Login extends StatefulWidget {
  static const String id = 'Login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await http.post(
      Uri.parse('https://apexstore.space/api/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', token);
        Navigator.pushReplacementNamed(context, Home.id);
      } else {
        setState(() {
          _errorMessage = "Failed to retrieve token";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Invalid email or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black54),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Login to continue',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 30.0),
                    _buildTextField(_emailController, 'Email'),
                    const SizedBox(height: 10.0),
                    _buildTextField(_passwordController, 'Password', obscureText: true),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 20.0),
                    _buildLoginButton(),
                    const SizedBox(height: 10.0),
                    _buildRegisterButton(),
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

  Widget _buildLoginButton() {
    return MaterialButton(
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.symmetric(vertical: 15),
      minWidth: double.infinity,
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Login',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
      onPressed: _isLoading ? null : _login,
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, Register.id);
      },
      child: const Text(
        'Don\'t have an account? Register',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
} 