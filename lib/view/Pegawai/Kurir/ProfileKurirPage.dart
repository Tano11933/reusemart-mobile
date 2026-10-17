import 'package:flutter/material.dart';
import '/entity/Pegawai.dart';
import '/view/LoginPage.dart';
import '/theme.dart';

class ProfileKurirPage extends StatelessWidget {
  final Pegawai pegawai;

  const ProfileKurirPage({super.key, required this.pegawai});

  @override
  Widget build(BuildContext context) {
    InputDecoration inputStyle(IconData icon) {
      return const InputDecoration(
        filled: true,
        fillColor: ReuseColors.surface,
        enabled: false,
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: ReuseColors.borderSmall,
          borderSide: BorderSide(color: ReuseColors.line),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: ReuseColors.borderSmall,
          borderSide: BorderSide(color: ReuseColors.line),
        ),
      ).copyWith(prefixIcon: Icon(icon, color: ReuseColors.muted));
    }

    return Container(
      color: ReuseColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Profile Kurir',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ReuseColors.primary,
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
                  backgroundColor: ReuseColors.danger,
                  foregroundColor: ReuseColors.surface,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(
                    borderRadius: ReuseColors.border,
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
