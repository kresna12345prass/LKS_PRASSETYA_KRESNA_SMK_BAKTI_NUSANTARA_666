import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../database/database_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final user = await DatabaseHelper.instance.getUser(
        _emailController.text,
        _passwordController.text,
      );
      setState(() => _isLoading = false);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email atau password salah')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade300
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.store,
                        size: 60, color: Colors.blue.shade700),
                    SizedBox(height: 10),
                    Text(
                      "Warung Go",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Silahkan masuk ke akun anda",
                      style:
                          TextStyle(color: Colors.blue.shade600, fontSize: 16),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Masukkan email";
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return "Masukkan email yang valid";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() =>
                                      _isPasswordVisible = !_isPasswordVisible);
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Masukkan password";
                              } else if (value.length < 6) {
                                return "Password minimal 6 karakter";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              shadowColor:
                                  Colors.blue.shade700.withValues(alpha: 0.3),
                            ),
                            child: Text(
                              "Masuk",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                    SizedBox(height: 25),

                    // Bagian register dengan teks "Belum punya akun?"
                    Column(
                      children: [
                        Text(
                          "Belum punya akun?",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue.shade700,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              side: BorderSide(
                                color: Colors.blue.shade700,
                                width: 1.5,
                              ),
                            ),
                            icon: Icon(Icons.person_add, size: 20),
                            label: Text(
                              "DAFTAR SEKARANG",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Tombol Kembali ke Halaman Utama
                    Container(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/welcome'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade600,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: Icon(Icons.home, size: 20),
                        label: Text(
                          "Kembali ke Halaman Utama",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
