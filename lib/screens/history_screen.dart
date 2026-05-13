import 'package:flutter/material.dart';
import 'main_screen.dart';

class HistoryScreen extends StatelessWidget {
  final List<Transaction> history;

  HistoryScreen({required this.history});

  // Helper function to format currency with thousand separators
  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Transaksi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Belum Ada Riwayat Transaksi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Transaksi Anda akan muncul di sini",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemCount: history.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.1),
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final transaction = history[index];
                  final items = transaction.items;
                  final total = transaction.total;
                  final date = transaction.date;

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade700,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        _formatCurrency(total),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        date,
                        style: TextStyle(color: Colors.white70),
                      ),
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Daftar Item:",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              ...items.map((item) => Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Icon(Icons.circle,
                                            size: 8, color: Colors.white70),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.name,
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ),
                                        Text(
                                          _formatCurrency(item.price),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
