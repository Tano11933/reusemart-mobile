import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:p3l_mob/client/AuthClient.dart';
import 'package:p3l_mob/client/PembeliClient.dart';
import 'package:p3l_mob/client/PenitipClient.dart';
import 'package:p3l_mob/client/PegawaiClient.dart';
//import 'package:p3l_mobile/view/Pegawai/HomePagePegawai.dart';
import 'package:p3l_mob/view/Pegawai/Hunter/HomePageHunter.dart';
import 'package:p3l_mob/view/Pegawai/Kurir/HomePageKurir.dart';
import 'package:p3l_mob/view/Penitip/HomePagePenitip.dart';
import 'package:p3l_mob/view/Pembeli/HomePagePembeli.dart';
import 'package:p3l_mob/entity/Pembeli.dart';
import 'package:p3l_mob/entity/Penitip.dart';
import 'package:p3l_mob/entity/Pegawai.dart';
import 'package:p3l_mob/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Notifikasi setup
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotif(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'login_channel',
      'Login Channel',
      channelDescription: 'Notifikasi login ReuseMart',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await AuthClient.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      print('Login response: $response');

      if (response['success'] == true) {
        // INISIALISASI NOTIFIKASI & SHOW NOTIF
        await _initNotification();
        await _showNotif('Login Berhasil', 'Selamat datang di aplikasi ReuseMart!');

        final role = response['role'];
        String? userId;
        switch (role) {
          case 'pembeli':
          case 'penitip':
          case 'organisasi':
          case 'pegawai':
            userId = response['id_user']?.toString();
            break;
          default:
            userId = null;
        }

        if (userId == null || userId == 'null') {
          setState(() {
            _errorMessage = 'User ID tidak valid dari server.';
            _isLoading = false;
          });
          return;
        }

        final jabatan = response['jabatan'];

        if (role == 'pembeli') {
          Pembeli pembeli = await PembeliClient.fetchProfile(userId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePagePembeli(pembeli: pembeli)),
          );
        } else if (role == 'penitip') {
          Penitip penitip = await PenitipClient.fetchProfile(userId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePagePenitip(penitip: penitip)),
          );
        } else if (role == 'pegawai') {
          if (jabatan != null && jabatan == 'Hunter') {
            Pegawai? pegawai = await PegawaiClient.fetchById(userId);
            if (pegawai != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePageHunter(pegawai: pegawai)),
              );
            } else {
              setState(() {
                _errorMessage = 'Gagal mengambil data pegawai.';
                _isLoading = false;
              });
            }
          } else if (jabatan != null && jabatan == 'Kurir') {
            Pegawai? pegawai = await PegawaiClient.fetchById(userId);
            if (pegawai != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePageKurir(pegawai: pegawai)),
              );
            } else {
              setState(() {
                _errorMessage = 'Gagal mengambil data pegawai.';
                _isLoading = false;
              });
            }
          } else {
            setState(() {
              _errorMessage = 'Akses ditolak: jabatan tidak diizinkan untuk login mobile.';
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Role tidak diizinkan login mobile.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Login gagal.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReuseColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      color: ReuseColors.primarySoft,
                      shape: BoxShape.circle,
                      boxShadow: ReuseColors.softShadow,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.recycling,
                        size: 60,
                        color: ReuseColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'REUSE MART',
                    style: TextStyle(
                      color: ReuseColors.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'A Second Life for Quality Goods, A Better Life for the Planet',
                      textAlign: TextAlign.center,
                      style: ReuseText.slogan,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: ReuseStyles.card(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: ReuseText.body,
                            cursorColor: ReuseColors.primary,
                            decoration: ReuseStyles.field(
                              hintText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: ReuseColors.muted),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!value.contains('@')) {
                                return 'Masukkan email yang valid';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: ReuseText.body,
                            cursorColor: ReuseColors.primary,
                            decoration: ReuseStyles.field(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: ReuseColors.muted),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                          ),

                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      size: 18, color: ReuseColors.danger),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: ReuseColors.danger,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),

                          _isLoading
                              ? const CircularProgressIndicator(
                                  color: ReuseColors.primary)
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ReuseStyles.primaryButton,
                                    onPressed: _login,
                                    child: const Text('Log In'),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}