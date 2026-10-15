import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/Penitip.dart';
import '../config.dart';

class PenitipClient {
  static const String penitipEndpoint = '/api/penitip';

  static Future<Penitip> fetchProfile(String idPenitip) async {
    final uri = Uri.http(AppConfig.host, '$penitipEndpoint/$idPenitip');
    final response = await http.get(uri);

    print('Fetch Profile Response status: ${response.statusCode}');
    print('Fetch Profile Response body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return Penitip.fromJson(jsonBody['data']);
    } else {
      throw Exception('Gagal mengambil profil penitip');
    }
  }

  static Future<Map<String, dynamic>> fetchHistory(String idPenitip) async {
    final uri = Uri.http(AppConfig.host, '$penitipEndpoint/history/$idPenitip');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil history penitip');
    }
  }

  static Future<List<Penitip>> fetchTopPenitip() async {
  final url = Uri.http(AppConfig.host, '/api/top-penitip');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    final List data = jsonBody['data'];
    return data.map((e) => Penitip.fromJson(e)).toList();
  } else {
    throw Exception('Gagal mengambil data top penitip');
  }
}

// static Future<List<Penitip>> fetchTopPenitipByNominal() async {
//     final response = await http.get(Uri.parse('YOUR_API_ENDPOINT_HERE'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return List<Penitip>.from(data.map((penitip) => Penitip.fromJson(penitip)));
//     } else {
//       throw Exception('Failed to load top penitips');
//     }
//   }
}