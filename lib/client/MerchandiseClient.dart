import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/Merchandise.dart';
import '../entity/TukarPoin.dart';
import '../entity/Pembeli.dart';
import '../config.dart';

class MerchandiseClient {
  static const String baseUrl = AppConfig.apiUrl;

  // Fetch seluruh merchandise
  static Future<List<Merchandise>> fetchAllMerchandise() async {
    final url = Uri.parse("$baseUrl/merchandise"); // Pastikan endpoint ini sesuai
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      // Sesuaikan struktur respons dengan backend kamu (data di dalam 'data' atau langsung array)
      final List list = (jsonBody['data'] ?? jsonBody) as List;
      return list.map((e) => Merchandise.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data merchandise");
    }
  }

  static Future<Map<String, dynamic>> tukarPoin(String idPembeli, String idMerch, int jml) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tukar-poin'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // ⬅️ tambahkan ini!
        },
        body: jsonEncode({
          'id_pembeli': idPembeli,
          'id_merch': idMerch,
          'jml': jml,
        }),
      );

      final body = jsonDecode(response.body);

      return {
        'success': body['success'] == true,
        'message': body['message'] ?? '',
      };
    } catch (e) {
      print("Tukar poin error: $e");
      return {
        'success': false,
        'message': 'Terjadi kesalahan pada koneksi atau server.',
      };
    }
  }

  static Future<List<TukarPoin>> fetchTukarPoinBelumDiambil(String idPembeli) async {
    final response = await http.get(Uri.parse('$baseUrl/tukar-poin/$idPembeli'));
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body); // 🔧 FIX DI SINI
      final List list = jsonBody['data'];          // ✅ akses data dari hasil decode
      return list.map((e) => TukarPoin.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data tukar poin.');
    }
  }

  static Future<Pembeli> fetchPembeliById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/pembeli/$id'));
    if (response.statusCode == 200) {
      return Pembeli.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Gagal mengambil data pembeli');
    }
  }


}
