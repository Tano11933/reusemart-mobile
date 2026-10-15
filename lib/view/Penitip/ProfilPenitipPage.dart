import 'package:flutter/material.dart';
import '/entity/Penitip.dart';
import '/view/LoginPage.dart';
import 'HistoryBarangTitipanPage.dart';
import 'HomePagePenitip.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ProfilPenitipPage extends StatefulWidget {
  final Penitip penitip;
  const ProfilPenitipPage({Key? key, required this.penitip}) : super(key: key);

  @override
  State<ProfilPenitipPage> createState() => _ProfilPenitipPageState();
}

class _ProfilPenitipPageState extends State<ProfilPenitipPage> {
  int _selectedIndex = 1; 

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;
    if (index == 0) {
      // Ke Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePagePenitip(penitip: widget.penitip),
        ),
      );
    }
  }

  void _showLogoutDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      title: 'Konfirmasi Logout',
      desc: 'Apakah Anda yakin ingin keluar dari akun?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      },
      btnOkText: "Logout",
      btnCancelText: "Batal",
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    const Color background = Color(0xFFF5E5C7);
    const Color primary = Color(0xFF17616E);
    const Color red = Color(0xFFE6392F);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Image.asset('assets/images/white.png', height: 40),
            const SizedBox(height: 8),
          ],
        ),
      ),

      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
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
                  'Profil ${widget.penitip.namaPenitip}',
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
                    _buildField(Icons.person, 'Nama', widget.penitip.namaPenitip),
                    _buildField(Icons.email, 'Email', widget.penitip.email),
                    _buildField(Icons.phone, 'Nomor Telepon', widget.penitip.nomorTelepon),
                    _buildField(Icons.credit_card, 'NIK Penitip', widget.penitip.nikPenitip),
                    _buildField(Icons.cake, 'Tanggal Lahir', widget.penitip.tglLahir),
                    _buildField(Icons.star, 'Rating', widget.penitip.rating.toStringAsFixed(2)),
                    _buildField(Icons.account_balance_wallet, 'Saldo', 'Rp ${widget.penitip.saldo}'),
                    _buildField(Icons.loyalty, 'Poin', widget.penitip.poin.toString()),

                    // === REKAP PENJUALAN BULAN LALU (HANYA TAMPIL JIKA ADA DATA) ===
                    if ((widget.penitip.totalPenjualanBulanLalu ?? 0) > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 4),
                        child: Card(
                          color: Colors.amber[50],
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rekap Bulan Lalu", style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.orange[900], fontSize: 16)),
                                SizedBox(height: 7),
                                Text("Total penjualan: Rp ${widget.penitip.totalPenjualanBulanLalu ?? 0}",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                if (widget.penitip.isTopSellerBulanLalu == true) ...[
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.workspace_premium_rounded, color: Colors.amber[800], size: 21),
                                      SizedBox(width: 7),
                                      Text("Top Seller bulan lalu",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[900])),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text("Bonus Top Seller: Rp ${widget.penitip.bonusBulanLalu ?? 0}",
                                      style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text("Total diterima: Rp ${(widget.penitip.totalPenjualanBulanLalu ?? 0) + (widget.penitip.bonusBulanLalu ?? 0)}",
                                      style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 80),
                    _buildButton(
                      text: 'History Barang Titipan',
                      backgroundColor: Colors.amber[700]!,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryBarangTitipanPage(idPenitip: widget.penitip.idPenitip),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildButton(
                      text: 'Logout',
                      backgroundColor: red,
                      onPressed: _showLogoutDialog,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: background,
        selectedItemColor: primary,
        unselectedItemColor: const Color.fromRGBO(23, 97, 110, 1).withOpacity(0.5),
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
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