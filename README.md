# Warung Go

Aplikasi Kasir Warung Modern - Solusi kasir digital untuk bisnis warung Anda.

## Fitur Utama

- 🛒 Manajemen Produk
- 💰 Sistem Pembayaran Multi-metode (Manual, QR Code, E-Wallet, Transfer Bank)
- 📊 Riwayat Transaksi
- 🎨 Desain Modern dengan Tema Hijau
- 💾 Database SQLite untuk penyimpanan lokal
- 👤 Sistem Login & Registrasi

## Teknologi

- Flutter SDK
- SQLite Database (sqflite)
- Material Design

## Instalasi

1. Clone repository ini
2. Jalankan `flutter pub get` untuk menginstall dependencies
3. Jalankan `flutter run` untuk menjalankan aplikasi

## Database

Aplikasi menggunakan SQLite dengan 3 tabel utama:
- **users**: Menyimpan data pengguna
- **products**: Menyimpan data produk
- **transactions**: Menyimpan riwayat transaksi

## Metode Pembayaran

1. **Manual**: Pembayaran tunai dengan perhitungan kembalian otomatis
2. **QR Code**: Pembayaran dengan scan QR
3. **E-Wallet**: DANA, GOPAY, OVO
4. **Transfer Bank**: BCA, BNI, BRI

## Produk Default

Aplikasi sudah dilengkapi dengan 10 produk default:
- Makanan: Nasi Goreng, Ayam Goreng, Mie Goreng, Sate Ayam
- Minuman: Es Teh, Jus Jeruk, Kopi Hitam
- Snack: Keripik, Coklat, Biskuit

## Lisensi

MIT License
