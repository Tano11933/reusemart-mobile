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
    const darkBlue = Color(0xFF173B61);
    const lightBlue = Color(0xFF7697A0);
    const cream = Color(0xFFFFEBD0);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF17616E), Color(0xFF173B61)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: cream,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.recycling,
                        size: 80,
                        color: darkBlue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'REUSE MART',
                    style: TextStyle(
                      color: cream,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'A Second Life for Quality Goods, A Better Life for the Planet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: lightBlue,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: cream),
                          cursorColor: cream,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email, color: cream),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: cream.withOpacity(0.7)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: cream.withOpacity(0.7)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: cream, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red.shade700, width: 2),
                            ),
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

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: cream),
                          cursorColor: cream,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock, color: cream),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: cream.withOpacity(0.7)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: cream.withOpacity(0.7)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: cream, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red.shade700, width: 2),
                            ),
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
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        const SizedBox(height: 30),

                        _isLoading
                            ? const CircularProgressIndicator(color: cream)
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cream,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 6,
                                  ),
                                  onPressed: _login,
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: darkBlue,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}