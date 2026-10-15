import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/Barang.dart';
import '../config.dart';

class BarangClient {
  static Future<List<Barang>> fetchBarangTersedia({bool? garansi}) async {
    final baseUrl = AppConfig.host;
    final endpoint = 'api/barang-tersedia';

    // Gunakan map untuk query parameters
    final query = garansi != null ? {'garansi': garansi ? '1' : '0'} : null;

    final url = Uri.http(baseUrl, endpoint, query);
    print('FINAL URL: $url');

    final response = await http.get(url);
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Barang.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data barang');
    }
  }



  static Future<List<Barang>> fetchBarangPenitip(String idPenitip) async {
    final baseUrl = AppConfig.host;
    final endpoint = 'api/penitip/$idPenitip/barang';
    final url = Uri.http(baseUrl, endpoint);

    print('URL: $url');
    final response = await http.get(url);

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List data = jsonBody['data'];
      return data.map((e) => Barang.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data barang penitip');
    }
  }

  static Future<List<Barang>> fetchBarangByHunter(String idHunter) async {
    final response = await http.get(
      Uri.parse('${AppConfig.apiUrl}/barang/hunter/$idHunter'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Barang.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data barang hunter');
    }
  }

}