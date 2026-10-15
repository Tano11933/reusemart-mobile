// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';

// class NotificationService {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   // Definisikan channel notifikasi
//   static final _channel = AndroidNotificationChannel(
//     'high_importance_channel', // id channel
//     'High Importance Notifications', // nama channel
//     description: 'Channel untuk notifikasi penting',
//     importance: Importance.high,
//   );

//   static Future<void> init() async {
//     // Minta permission notifikasi (khusus Android 13+)
//     await requestPermission();

//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final settings = InitializationSettings(android: androidSettings);

//     // Daftarkan notification channel
//     await _notifications
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_channel);

//     await _notifications.initialize(settings);
//   }

//   static Future<void> requestPermission() async {
//     if (!await Permission.notification.isGranted) {
//       await Permission.notification.request();
//     }
//   }

//   static Future<void> showNotification(int id, String title, String body) async {
//     final androidDetails = AndroidNotificationDetails(
//       _channel.id,
//       _channel.name,
//       channelDescription: _channel.description,
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//     );

//     final notificationDetails = NotificationDetails(android: androidDetails);

//     await _notifications.show(id, title, body, notificationDetails);
//   }
// }
