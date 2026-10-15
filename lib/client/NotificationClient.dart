import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/Notification.dart';
import '../config.dart';

class NotificationClient {
  static Future<List<NotificationModel>> fetchPenitipNotifications(String idPenitip) async {
    final uri = Uri.http(AppConfig.host, '/api/notifications/penitip/$idPenitip');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      if (jsonBody['success'] == true) {
        final List data = jsonBody['data'];
        return data.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal mengambil notifikasi');
      }
    } else {
      throw Exception('Gagal mengambil notifikasi: ${response.reasonPhrase}');
    }
  }
}