import 'package:flutter/material.dart';
import '/entity/Pembeli.dart';
import '/view/LoginPage.dart';
import 'HistoryTransaksiPembelianPage.dart'; // Pastikan path sesuai
import 'package:p3l_mob/view/Pembeli/HomePagePembeli.dart';
import '/theme.dart';


class ProfilPembeliPage extends StatefulWidget {
  final Pembeli pembeli;
  const ProfilPembeliPage({Key? key, required this.pembeli}) : super(key: key);

  @override
  State<ProfilPembeliPage> createState() => _ProfilPembeliPageState();
}

class _ProfilPembeliPageState extends State<ProfilPembeliPage> {
  int _selectedIndex = 2; // Profil di index 2

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePagePembeli(
          pembeli: widget.pembeli,
          initialIndex: index,
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    final pembeli = widget.pembeli;

    return Scaffold(
      backgroundColor: ReuseColors.background,
      appBar : AppBar(
        backgroundColor: ReuseColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ReuseColors.surface),
        title: Image.asset('assets/images/white.png', height: 32),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Logo/Header

            // Judul Profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: ReuseColors.primarySoft,
                borderRadius: ReuseColors.borderBottom,
              ),
              child: Center(
                child: Text(
                  'Profil ${pembeli.namaPembeli}',
                  textAlign: TextAlign.center,
                  style: ReuseText.title.copyWith(fontSize: 20),
                ),
              ),
            ),
            // Expanded: Data Profil
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    _buildField(Icons.person, 'Nama', pembeli.namaPembeli),
                    _buildField(Icons.email, 'Email', pembeli.email),
                    _buildField(Icons.phone, 'Nomor Telepon', pembeli.nomorTelepon),
                    _buildField(Icons.person, 'Jenis Kelamin', pembeli.jenisKelamin),
                    _buildField(Icons.cake, 'Tanggal Lahir', pembeli.tglLahir),
                    _buildField(Icons.money, 'Poin', pembeli.poin?.toString() ?? '-'),
                    const SizedBox(height: 120),
                    _buildButton(
                        text: 'History Transaksi Pembelian',
                        backgroundColor: ReuseColors.primary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryTransaksiPembelianPage(
                                idPembeli: pembeli.idPembeli,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12), // Jarak antara tombol
                    _buildButton(
                      text: 'Logout',
                      backgroundColor: ReuseColors.danger,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Konfirmasi Logout"),
                              content: const Text("Apakah Anda yakin ingin log out?"),
                              actions: [
                                TextButton(
                                  child: const Text("Tidak"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("Ya"),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // tutup dialog
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginPage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ReuseColors.surface,
        selectedItemColor: ReuseColors.primary,
        unselectedItemColor: ReuseColors.muted,
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Merchandise"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildField(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        readOnly: true,
        initialValue: value ?? '-',
        style: ReuseText.body,
        decoration: ReuseStyles.field(
          labelText: label,
          prefixIcon: Icon(icon, color: ReuseColors.muted),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: ReuseColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: ReuseColors.border,
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}