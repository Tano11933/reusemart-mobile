import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/Pembeli.dart';
import '../config.dart';

class PembeliClient {
  static const String pembeliEndpoint = '/api/pembeli';

  static Future<Pembeli> fetchProfile(String idPembeli) async {
    final uri = Uri.http(AppConfig.host, '$pembeliEndpoint/$idPembeli');
    final response = await http.get(uri);

    print('Fetch Profile Response status: ${response.statusCode}');
    print('Fetch Profile Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      // Ambil dari key 'data', bukan 'pembeli'
      return Pembeli.fromJson(jsonBody['data']);
    } else {
      throw Exception('Gagal mengambil profil pembeli');
    }
  }


  static Future<Map<String, dynamic>> fetchHistory(String idPembeli) async {
    final uri = Uri.http(AppConfig.host, '$pembeliEndpoint/history/$idPembeli');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil history pembeli');
    }
  }
}