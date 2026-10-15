import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/Pegawai.dart';
import '../config.dart';

class PegawaiClient {
  static const String pegawaiEndpoint = '/api/pegawai';

  // Contoh login pegawai (biasanya dipakai juga di AuthClient)
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.http(AppConfig.host, '/api/login');
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody;
    } else {
      throw Exception('Login pegawai gagal: ${response.reasonPhrase}');
    }
  }

  // Ambil data pegawai berdasarkan id dan filter jabatan J3 dan J4
  static Future<Pegawai?> fetchById(String idPegawai) async {
    final uri = Uri.http(AppConfig.host, '$pegawaiEndpoint/$idPegawai');
    final response = await http.get(uri);

    print('Fetch Profile Response status: ${response.statusCode}');
    print('Fetch Profile Response body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return Pegawai.fromJson(jsonBody['data'] ?? jsonBody);
    } else {
      throw Exception('Gagal mengambil data pegawai');
    }
  }

  static Future<String> fetchKomisi(String idPegawai) async {
    final uri = Uri.http(AppConfig.host, '/api/pegawai/$idPegawai/komisi');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody['total_komisi'].toString();
    } else {
      throw Exception('Gagal mengambil data komisi');
    }
  }


}
