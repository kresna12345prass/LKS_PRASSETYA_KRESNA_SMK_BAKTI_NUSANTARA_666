import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_screen.dart';
import 'order_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../database/database_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Product> _cart;
  late List<Transaction> _history;
  String? _userEmail;
  String? _userName;
  String? _userAddress;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _cart = [];
    _history = [];
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id');
      _userName = prefs.getString('user_name') ?? 'Pengguna Warung Go';
      _userEmail = prefs.getString('user_email') ?? 'user@example.com';
      _userAddress = prefs.getString('user_address') ?? 'Alamat tidak tersedia';
    });
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (_userId == null) return;
    
    final transactions = await DatabaseHelper.instance.getTransactions(userId: _userId);
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
    if (_userId == null) return;
    
    final itemsJson = jsonEncode(
      cart.map((p) => {
        'name': p.name,
        'price': p.price,
        'category': p.category,
        'image': p.image,
      }).toList(),
    );
    
    await DatabaseHelper.instance.createTransaction({
      'user_id': _userId,
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
