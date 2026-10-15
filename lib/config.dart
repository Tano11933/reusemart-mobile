/// Konfigurasi alamat backend ReuseMart.
///
/// Nilai default memakai loopback emulator Android (10.0.2.2) menuju komputer
/// yang menjalankan `php artisan serve` pada port 8000.
///
/// Untuk perangkat fisik, ganti [host] dengan alamat IP komputer di jaringan
/// yang sama, misalnya `192.168.1.10:8000`, lalu jalankan ulang aplikasi.
class AppConfig {
  AppConfig._();

  /// Alamat host backend, tanpa skema.
  static const String host = '10.0.2.2:8000';

  /// Alamat dasar backend lengkap dengan skema.
  static const String baseUrl = 'http://$host';

  /// Alamat dasar endpoint API.
  static const String apiUrl = '$baseUrl/api';
}
