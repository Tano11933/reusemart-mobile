import 'package:flutter/material.dart';
import '/entity/Pembeli.dart';
import '/view/LoginPage.dart';
import 'HistoryTransaksiPembelianPage.dart'; // Pastikan path sesuai
import 'package:p3l_mob/view/Pembeli/HomePagePembeli.dart';


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
    const Color background = Color(0xFFF5E5C7);
    const Color primary = Color(0xFF17616E);
    const Color red = Color(0xFFE6392F);

    final pembeli = widget.pembeli;

    return Scaffold(
      backgroundColor: background,
      appBar : AppBar(
        backgroundColor: primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/white.png', height: 35),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Logo/Header
            
            // Judul Profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                color: background,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Center(
                child: Text(
                  'Profil ${pembeli.namaPembeli}',
                  style: TextStyle(
                    color: primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                        backgroundColor: primary,
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
                      SizedBox(height: 12), // Jarak antara tombol
                    _buildButton(
                      text: 'Logout',
                      backgroundColor: red,
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
        backgroundColor: primary,
        selectedItemColor: background,
        unselectedItemColor: background.withOpacity(0.5),
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
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFF173B61)),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}