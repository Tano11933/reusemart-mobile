# ReuseMart Mobile

Aplikasi mobile untuk ReuseMart, marketplace barang bekas dan barang titipan. Dibangun dengan Flutter dan terhubung ke backend Laravel di [reusemart-web](https://github.com/Tano11933/reusemart-web).

## Fitur

**Pembeli**
- Katalog barang tersedia dengan pencarian dan filter garansi
- Detail barang dan foto produk
- Tukar poin dengan merchandise, termasuk daftar hadiah yang belum diambil
- Riwayat transaksi pembelian

**Penitip**
- Daftar barang yang sedang dititipkan
- Riwayat penjualan barang titipan
- Profil dan status penitipan

**Pegawai**
- Hunter: daftar barang hasil buruan dan rincian komisi
- Kurir: daftar pengiriman aktif, detail pengiriman, riwayat pengiriman, dan penyelesaian pesanan

## Menjalankan

Prasyarat: Flutter 3.24, Dart 3.5, dan backend ReuseMart yang aktif.

```bash
flutter pub get
flutter run
```

Jalankan backend Laravel di komputer yang sama:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

## Konfigurasi alamat backend

Semua alamat API dan gambar diatur di satu tempat, `lib/config.dart`:

```dart
static const String host = '10.0.2.2:8000';
```

- **Emulator Android**: nilai default sudah benar. `10.0.2.2` adalah loopback emulator menuju komputer host.
- **Perangkat fisik**: ganti ke alamat IP komputer di jaringan yang sama, misalnya `192.168.1.10:8000`, lalu jalankan ulang aplikasi. Pastikan `php artisan serve --host=0.0.0.0` dan ponsel berada di Wi-Fi yang sama.

## Struktur

```
lib/
  config.dart          konfigurasi alamat backend
  client/              pemanggil API per domain (auth, barang, pesanan, komisi, ...)
  entity/              model data
  view/                halaman aplikasi
    Pembeli/           halaman pembeli
    Penitip/           halaman penitip
    Pegawai/Hunter/    halaman hunter
    Pegawai/Kurir/     halaman kurir
```

## Kredit

Proyek kelompok mata kuliah P3L (2025), dipublikasikan ulang untuk portofolio pada 2026. Repositori asli kelompok: [paniae/P3L_1829_1933_2024](https://github.com/paniae/P3L_1829_1933_2024).

Anggota tim: Tano11933, paniae.

## Catatan

- Ini adalah proyek akademik yang masih dikembangkan. Beberapa alur seperti notifikasi belum diuji menyeluruh.
- Versi Flutter yang dipakai saat pengembangan: 3.24.1 stable.
