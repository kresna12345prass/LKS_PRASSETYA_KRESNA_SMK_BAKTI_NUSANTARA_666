import 'package:flutter/material.dart';
import 'main_screen.dart';

class SettingsScreen extends StatefulWidget {
  final List<Product> cart;
  final Function(Product) addProduct;
  final String? userEmail;
  final String? userName;
  final String? userAddress;

  SettingsScreen({
    required this.cart, 
    required this.addProduct,
    this.userEmail,
    this.userName,
    this.userAddress,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informasi Akun"),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.store, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    "Warung Go",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Informasi Akun",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Informasi Akun
            _buildInfoItem(
              icon: Icons.person,
              title: "Nama Lengkap",
              value: widget.userName ?? "Tidak tersedia",
            ),
            _buildInfoItem(
              icon: Icons.email,
              title: "Email",
              value: widget.userEmail ?? "Tidak tersedia",
            ),
            _buildInfoItem(
              icon: Icons.location_on,
              title: "Alamat",
              value: widget.userAddress ?? "Tidak tersedia",
            ),
            SizedBox(height: 30),
            _buildSettingsItem(
              icon: Icons.exit_to_app,
              title: "Keluar",
              isDestructive: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Konfirmasi"),
                    content: Text("Apakah Anda yakin ingin keluar?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/welcome');
                        },
                        child: Text("Keluar", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    required Function() onTap,
  }) {
    final iconColor =
        isDestructive ? const Color.fromARGB(255, 165, 4, 4) : Colors.white;
    final textColor =
        isDestructive ? const Color.fromARGB(255, 165, 4, 4) : Colors.white;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.2),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
