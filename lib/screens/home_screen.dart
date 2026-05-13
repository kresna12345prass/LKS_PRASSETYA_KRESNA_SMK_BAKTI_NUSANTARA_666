import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(Product) addToCart;
  final List<Product> cart;

  HomeScreen({required this.addToCart, required this.cart});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = "Semua";
  List<Product> _products = [
    Product(
        name: "Nasi Goreng",
        price: 15000,
        category: "Makanan",
        image: "assets/images/nasi_goreng.jpg"),
    Product(
        name: "Es Teh",
        price: 5000,
        category: "Minuman",
        image: "assets/images/es_teh.jpg"),
    Product(
        name: "Keripik",
        price: 10000,
        category: "Snack",
        image: "assets/images/keripik.jpg"),
    Product(
        name: "Ayam Goreng",
        price: 20000,
        category: "Makanan",
        image: "assets/images/ayam_goreng.jpg"),
    Product(
        name: "Jus Jeruk",
        price: 8000,
        category: "Minuman",
        image: "assets/images/jus_jeruk.jpg"),
    Product(
        name: "Coklat",
        price: 12000,
        category: "Snack",
        image: "assets/images/coklat.jpg"),
    Product(
        name: "Mie Goreng",
        price: 12000,
        category: "Makanan",
        image: "assets/images/mie_goreng.jpg"),
    Product(
        name: "Kopi Hitam",
        price: 7000,
        category: "Minuman",
        image: "assets/images/kopi_hitam.jpg"),
    Product(
        name: "Biskuit",
        price: 8000,
        category: "Snack",
        image: "assets/images/biskuit.jpg"),
    Product(
        name: "Sate Ayam",
        price: 25000,
        category: "Makanan",
        image: "assets/images/sate_ayam.jpg"),
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildCategoryChip(String category, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: _selectedCategory == category
                  ? Colors.white
                  : Colors.blue.shade700,
            ),
            SizedBox(width: 6),
            Text(
              category,
              style: TextStyle(
                color: _selectedCategory == category
                    ? Colors.white
                    : Colors.blue.shade700,
              ),
            ),
          ],
        ),
        selected: _selectedCategory == category,
        selectedColor: Colors.blue.shade700,
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        onSelected: (selected) => setState(() {
          if (selected) _selectedCategory = category;
        }),
        shape: StadiumBorder(
          side: BorderSide(
            color: Colors.blue.shade700,
            width: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = _products.where((product) {
      final matchesCategory =
          _selectedCategory == "Semua" || product.category == _selectedCategory;
      final matchesSearch = _searchController.text.isEmpty ||
          product.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.store, size: 28, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Warung Go",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
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
        child: Column(
          children: [
            // Search Bar with improved styling
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Cari produk...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // Category Chips with icons
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip("Semua", Icons.all_inclusive),
                    _buildCategoryChip("Makanan", Icons.restaurant),
                    _buildCategoryChip("Minuman", Icons.local_drink),
                    _buildCategoryChip("Snack", Icons.fastfood),
                  ],
                ),
              ),
            ),

            // Product Grid with improved spacing
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      productName: product.name,
                      productImage: product.image,
                      productPrice: product.price,
                      productCategory: product.category,
                      onTap: () => widget.addToCart(product),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
