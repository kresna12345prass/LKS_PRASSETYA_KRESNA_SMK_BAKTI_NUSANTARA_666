import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.grey.shade600,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          iconSize: 28,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              activeIcon: Icon(Icons.inventory, color: Colors.blue.shade700, size: 32),
              label: "Produk",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              activeIcon: Icon(Icons.shopping_cart, color: Colors.blue.shade700, size: 32),
              label: "Pesanan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              activeIcon: Icon(Icons.history, color: Colors.blue.shade700, size: 32),
              label: "Riwayat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              activeIcon: Icon(Icons.account_circle, color: Colors.blue.shade700, size: 32),
              label: "Akun",
            ),
          ],
        ),
      ),
    );
  }
}
