import 'dart:convert';
import 'package:http/http.dart' as http;
import '/config.dart';

class AuthClient {
  static const String loginEndpoint = '/api/login';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.http(AppConfig.host, loginEndpoint);
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login gagal: ${response.reasonPhrase}');
    }
  }

  static Future<void> saveFcmToken(String idUser, String role, String token) async {
    final uri = Uri.parse('${AppConfig.apiUrl}/store-token');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id_user': idUser,
        'role': role, // 'pembeli' atau 'penitip'
        'fcm_token': token,
      }),
    );

    if (response.statusCode == 200) {
      print('Token FCM berhasil disimpan.');
    } else {
      print('Gagal menyimpan FCM token: ${response.body}');
    }
  }

}