import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/Komisi.dart';
import '../config.dart';

class KomisiClient {
  // PegawaiClient.dart
  static Future<double> fetchKomisi(String idPegawai) async {
    final uri = Uri.http(AppConfig.host, '/api/pegawai/$idPegawai/komisi');
    final response = await http.get(uri);

    print('🔗 Fetch URL: $uri');
    print('📦 Status: ${response.statusCode}');
    print('📦 Body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final rawValue = json['total_komisi']; // ✅ hanya ambil total_komisi

      if (rawValue is int) return rawValue.toDouble();
      if (rawValue is double) return rawValue;
      if (rawValue is String) return double.tryParse(rawValue) ?? 0.0;
      return 0.0;
    } else {
      throw Exception('Gagal mengambil komisi');
    }
  }


  static Future<List<Komisi>> fetchKomisiList(String idPegawai) async {
    final uri = Uri.http(AppConfig.host, '/api/pegawai/$idPegawai/komisi-list');
    final response = await http.get(uri);

    print("📡 Fetch KomisiList URL: $uri");
    print("📦 Status: ${response.statusCode}");
    print("📦 Body: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List data = json['data']; // Ambil key "data"
      return data.map((e) => Komisi.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil daftar komisi');
    }
  }

  






}
