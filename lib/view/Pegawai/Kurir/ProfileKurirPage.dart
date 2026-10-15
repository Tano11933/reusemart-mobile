import 'package:flutter/material.dart';
import '/entity/Pegawai.dart';
import '/view/LoginPage.dart';

class ProfileKurirPage extends StatelessWidget {
  final Pegawai pegawai;

  const ProfileKurirPage({super.key, required this.pegawai});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFFFEBD0);
    const primary = Color(0xFF173B61);

    InputDecoration inputStyle(IconData icon) {
      return InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        enabled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );
    }

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Profile Kurir',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              initialValue: pegawai.namaPegawai,
              decoration: inputStyle(Icons.person),
            ),
            const SizedBox(height: 12),

            TextFormField(
              initialValue: pegawai.email,
              decoration: inputStyle(Icons.email),
            ),
            const SizedBox(height: 12),

            TextFormField(  
              initialValue: pegawai.tglLahir,
              decoration: inputStyle(Icons.calendar_today),
            ),
            const SizedBox(height: 12),

            TextFormField(
              initialValue: pegawai.nomorTelepon,
              decoration: inputStyle(Icons.phone),
            ),
            const SizedBox(height: 12),

            TextFormField(
              initialValue: pegawai.alamat,
              decoration: inputStyle(Icons.location_city),
            ),
            const SizedBox(height: 12),

            TextFormField(
              initialValue: pegawai.idJabatan,
              decoration: inputStyle(Icons.badge),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Logout', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
