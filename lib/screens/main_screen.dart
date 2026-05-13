import 'package:flutter/material.dart';
import 'dart:convert';
import 'home_screen.dart';
import 'order_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../database/database_helper.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Product> _cart;
  late List<Transaction> _history;
  String? _userEmail;
  String? _userName;
  String? _userAddress;

  @override
  void initState() {
    super.initState();
    _cart = [];
    _history = [];
    _loadHistory();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Untuk sementara, kita akan menggunakan data dummy
    // Nanti bisa diambil dari database atau SharedPreferences
    setState(() {
      _userEmail = "user@example.com";
      _userName = "Pengguna Warung Go";
      _userAddress = "Jl. Contoh No. 123, Jakarta";
    });
  }

  Future<void> _loadHistory() async {
    final transactions = await DatabaseHelper.instance.getTransactions();
    setState(() {
      _history = transactions.map((t) {
        final items = (jsonDecode(t['items']) as List)
            .map((item) => Product(
                  name: item['name'],
                  price: item['price'],
                  category: item['category'],
                  image: item['image'],
                ))
            .toList();
        return Transaction(
          items: items,
          total: t['total'],
          date: t['created_at'],
          paymentMethod: t['payment_method'],
        );
      }).toList();
    });
  }

  void _addToCart(Product product) {
    setState(() => _cart.add(product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.name} ditambahkan ke pesanan")),
    );
  }

  void _removeFromCart(int index) {
    setState(() => _cart.removeAt(index));
  }

  void _clearCart() {
    setState(() => _cart.clear());
  }

  void _addProduct(Product product) {
    setState(() => _cart.add(product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.name} ditambahkan ke pesanan")),
    );
  }

  Future<void> _addToHistory(List<Product> cart, double total, String paymentMethod) async {
    final itemsJson = jsonEncode(
      cart.map((p) => {
        'name': p.name,
        'price': p.price,
        'category': p.category,
        'image': p.image,
      }).toList(),
    );
    
    await DatabaseHelper.instance.createTransaction({
      'total': total,
      'payment_method': paymentMethod,
      'created_at': DateTime.now().toIso8601String(),
      'items': itemsJson,
    });
    
    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(addToCart: _addToCart, cart: _cart),
      OrderScreen(
        cart: _cart,
        removeFromCart: _removeFromCart,
        clearCart: _clearCart,
        addToHistory: _addToHistory,
      ),
      HistoryScreen(history: _history),
      SettingsScreen(
        cart: _cart, 
        addProduct: _addProduct,
        userEmail: _userEmail,
        userName: _userName,
        userAddress: _userAddress,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String category;
  final String image;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });
}

class Transaction {
  final List<Product> items;
  final double total;
  final String date;
  final String paymentMethod;

  Transaction({
    required this.items,
    required this.total,
    required this.date,
    this.paymentMethod = 'Manual',
  });
}
