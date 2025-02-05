import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Profile extends StatefulWidget {
  static const String id = 'Profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = 'Jane Doe';
  String email = 'janedoe@fashionstore.com';
  String address = '456 Fashion Avenue, Los Angeles, CA';
  String phone = '+1 987 654 3210';
  String membership = 'Premium';
  String accountCreated = '2023-01-15';
  File? _profileImage;
  Position? _currentPosition;
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  final Battery _battery = Battery();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _getCurrentLocation();
    _getBatteryLevel();
    _initNotifications();

    _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
    });
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('user_name') ?? name;
      email = prefs.getString('user_email') ?? email;
      phone = prefs.getString('user_phone') ?? phone;
      address = prefs.getString('user_address') ?? address;
      String? profileImagePath = prefs.getString('profile_image');
      if (profileImagePath != null) {
        _profileImage = File(profileImagePath);
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  Future<void> _getBatteryLevel() async {
    int batteryLevel = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel_id', 'General Notifications',
            importance: Importance.high, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(0, 'Profile Update', message, platformChannelSpecifics);
  }

  void _editField(String field, String value, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: value);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () async {
              onSave(controller.text);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_${field.toLowerCase()}', controller.text);
              _showNotification('$field updated successfully!');
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value, Function()? onEdit, bool isDarkMode) {
    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.orange.shade100,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Text(value, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87)),
        trailing: onEdit != null ? IconButton(icon: Icon(Icons.edit, color: isDarkMode ? Colors.orange : Colors.black), onPressed: onEdit) : null,
      ),
    );
  }

  Widget _buildBatteryStatus(bool isDarkMode) {
    Color batteryColor = Colors.green;
    IconData batteryIcon = Icons.battery_full;

    if (_batteryLevel <= 20) {
      batteryColor = Colors.red;
      batteryIcon = Icons.battery_alert;
    } else if (_batteryLevel <= 50) {
      batteryColor = Colors.orange;
      batteryIcon = Icons.battery_4_bar;
    }

    String batteryStatus = 'Unknown';
    switch (_batteryState) {
      case BatteryState.charging:
        batteryStatus = 'Charging';
        break;
      case BatteryState.discharging:
        batteryStatus = 'Not Charging';
        break;
      case BatteryState.full:
        batteryStatus = 'Full';
        break;
      default:
        batteryStatus = 'Unknown';
    }

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                batteryIcon,
                color: batteryColor,
                size: 24,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Battery Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    batteryStatus,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: batteryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$_batteryLevel%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: batteryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: isDarkMode ? Colors.black : Colors.orange,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.orange.shade100,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : AssetImage('assets/images/profile_pic.jpg') as ImageProvider,
                child: _profileImage == null ? Icon(Icons.camera_alt, size: 40, color: isDarkMode ? Colors.white : Colors.black) : null,
              ),
            ),
            SizedBox(height: 20),
            _buildProfileDetail('Name', name, () => _editField('Name', name, (val) => setState(() => name = val)), isDarkMode),
            _buildProfileDetail('Email', email, () => _editField('Email', email, (val) => setState(() => email = val)), isDarkMode),
            _buildProfileDetail('Phone', phone, () => _editField('Phone', phone, (val) => setState(() => phone = val)), isDarkMode),
            _buildProfileDetail('Address', address, () => _editField('Address', address, (val) => setState(() => address = val)), isDarkMode),
            _buildProfileDetail('Membership', membership, null, isDarkMode),
            _buildProfileDetail('Account Created', accountCreated, null, isDarkMode),
            SizedBox(height: 20),
            _buildBatteryStatus(isDarkMode),
            if (_currentPosition != null)
              Text('Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}', style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black54)),
          ],
        ),
      ),
    );
  }
}

