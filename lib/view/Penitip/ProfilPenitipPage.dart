import 'package:flutter/material.dart';
import '/entity/Penitip.dart';
import '/view/LoginPage.dart';
import 'HistoryBarangTitipanPage.dart';
import 'HomePagePenitip.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '/theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ReuseColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: ReuseColors.surface),
        title: Image.asset('assets/images/white.png', height: 32),
      ),

      backgroundColor: ReuseColors.background,
      body: SafeArea(
        child: Column(
          children: [
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
                  'Profil ${widget.penitip.namaPenitip}',
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
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          decoration: BoxDecoration(
                            color: ReuseColors.accentSoft,
                            borderRadius: ReuseColors.border,
                            border: Border.all(color: ReuseColors.line),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Rekap Bulan Lalu",
                                  style: ReuseText.section),
                              const SizedBox(height: 7),
                              Text("Total penjualan: Rp ${widget.penitip.totalPenjualanBulanLalu ?? 0}",
                                  style: ReuseText.body.copyWith(fontWeight: FontWeight.w600)),
                              if (widget.penitip.isTopSellerBulanLalu == true) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.workspace_premium_rounded,
                                        color: ReuseColors.primary, size: 21),
                                    const SizedBox(width: 7),
                                    Text("Top Seller bulan lalu",
                                        style: ReuseText.cardTitle),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text("Bonus Top Seller: Rp ${widget.penitip.bonusBulanLalu ?? 0}",
                                    style: ReuseText.body.copyWith(fontWeight: FontWeight.bold)),
                                Text("Total diterima: Rp ${(widget.penitip.totalPenjualanBulanLalu ?? 0) + (widget.penitip.bonusBulanLalu ?? 0)}",
                                    style: const TextStyle(color: ReuseColors.success, fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 80),
                    _buildButton(
                      text: 'History Barang Titipan',
                      backgroundColor: ReuseColors.primary,
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
                      backgroundColor: ReuseColors.danger,
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
        backgroundColor: ReuseColors.surface,
        selectedItemColor: ReuseColors.primary,
        unselectedItemColor: ReuseColors.muted,
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