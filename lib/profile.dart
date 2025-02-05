import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const String id = 'Profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  String name = 'John Doe';
  String email = 'johndoe@email.com';
  String cardNumber = '**** **** **** 1234';
  String expiryDate = '12/24';
  String cvv = '***';
  String address = '123 Fashion Street, New York, NY';
  String phone = '+1 123 456 7890';

  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = name;
    _emailController.text = email;
    _cardController.text = cardNumber;
    _expiryController.text = expiryDate;
    _cvvController.text = cvv;
    _addressController.text = address;
    _phoneController.text = phone;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: isDarkMode ? Colors.black : Colors.orange,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile section
              _buildProfileHeader(isDarkMode, isLandscape),

              const SizedBox(height: 30),

              // Payment details, address, and phone
              _buildInformationSection(isDarkMode),

              const SizedBox(height: 30),

              // Action buttons (Edit Profile, Log Out)
              _buildActionButtons(isDarkMode),

              const SizedBox(height: 30),

              // Settings and Preferences
              const Text(
                'Settings & Preferences:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildSettings(isDarkMode),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Header Widget
  Widget _buildProfileHeader(bool isDarkMode, bool isLandscape) {
    return isLandscape
        ? Row(
      children: [
        _buildProfileImage(),
        const SizedBox(width: 20),
        Expanded(child: _buildProfileInfo(isDarkMode)),
      ],
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileImage(),
        const SizedBox(height: 20),
        _buildProfileInfo(isDarkMode),
      ],
    );
  }

  // Profile Image Widget
  Widget _buildProfileImage() {
    return const CircleAvatar(
      radius: 60,
      backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
    );
  }

  // Profile Information (Name, Email) Widget
  Widget _buildProfileInfo(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.orange,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          email,
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  // Information Section (Payment Details, Address, Phone)
  Widget _buildInformationSection(bool isDarkMode) {
    return _isEditing
        ? _buildEditableForm(isDarkMode)
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Details:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          'Card Number: $cardNumber\nExpiry Date: $expiryDate\nCVV: $cvv',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white70 : Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Address:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          address,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white70 : Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Phone:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          phone,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white70 : Colors.black,
          ),
        ),
      ],
    );
  }

  // Editable Form Widget
  Widget _buildEditableForm(bool isDarkMode) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Name',
            isDarkMode: isDarkMode,
          ),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            isDarkMode: isDarkMode,
          ),
          _buildTextField(
            controller: _cardController,
            label: 'Card Number',
            isDarkMode: isDarkMode,
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _expiryController,
                  label: 'Expiry Date',
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTextField(
                  controller: _cvvController,
                  label: 'CVV',
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          _buildTextField(
            controller: _addressController,
            label: 'Address',
            isDarkMode: isDarkMode,
          ),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone',
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    name = _nameController.text;
                    email = _emailController.text;
                    cardNumber = _cardController.text;
                    expiryDate = _expiryController.text;
                    cvv = _cvvController.text;
                    address = _addressController.text;
                    phone = _phoneController.text;
                    _isEditing = false;
                  });
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  // Settings Widget
  Widget _buildSettings(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          value: true,
          onChanged: (value) {},
          title: Text(
            'Enable Notifications',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
          ),
        ),
        SwitchListTile(
          value: false,
          onChanged: (value) {},
          title: Text(
            'Receive Promotional Emails',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // Action Buttons (Edit Profile, Log Out)
  Widget _buildActionButtons(bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange])
                : const LinearGradient(
                colors: [Colors.orangeAccent, Colors.yellow]),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              backgroundColor: Colors.transparent,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            child: Text(
              _isEditing ? 'Cancel Editing' : 'Edit Profile',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? const LinearGradient(
                colors: [Colors.red, Colors.deepOrangeAccent])
                : const LinearGradient(
                colors: [Colors.redAccent, Colors.pinkAccent]),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              backgroundColor: Colors.transparent,
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'login');
            },
            child: const Text(
              'Log Out',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white70 : Colors.black45,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode ? Colors.orange : Colors.orangeAccent,
            ),
          ),
        ),
        style: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
