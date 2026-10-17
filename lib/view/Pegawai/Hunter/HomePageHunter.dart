import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '/entity/Pegawai.dart';
import '/entity/Barang.dart';
import '/client/KomisiClient.dart';
import '/client/BarangClient.dart';
import 'package:p3l_mob/view/Pegawai/Hunter/DetailKomisiPage.dart';
import 'package:p3l_mob/view/LoginPage.dart';
import '/config.dart';
import '/theme.dart';

class HomePageHunter extends StatefulWidget {
  final Pegawai pegawai;
  const HomePageHunter({super.key, required this.pegawai});
  


  @override
  State<HomePageHunter> createState() => _HomePageHunterState();
}

class _HomePageHunterState extends State<HomePageHunter> {
  double? komisi;
  bool isLoading = true;
  int _selectedIndex = 0;
  final TextEditingController _komisiController = TextEditingController();
  late Future<List<Barang>> barangHunterFuture;

  @override
  void initState() {
    super.initState();
    loadKomisi();
    barangHunterFuture = BarangClient.fetchBarangByHunter(widget.pegawai.idPegawai);
  }

  Future<void> loadKomisi() async {
    try {
      double result = await KomisiClient.fetchKomisi(widget.pegawai.idPegawai);
      setState(() {
        komisi = result;
        _komisiController.text = formatRupiah(komisi);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        komisi = null;
        _komisiController.text = '-';
        isLoading = false;
      });
    }
  }

  String formatRupiah(double? number) {
    if (number == null) return '-';
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(number);
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color red = ReuseColors.danger;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ReuseColors.primaryDark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: ReuseColors.background,
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(ReuseColors.primary),
            _buildProfileContent(ReuseColors.primary, red, ReuseColors.background),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavTapped,
          selectedItemColor: ReuseColors.primary,
          unselectedItemColor: ReuseColors.muted,
          backgroundColor: ReuseColors.surface,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(Color primary) {
    return Column(
      children: [
        Container(height: MediaQuery.of(context).padding.top, color: primary),
        Container(
          width: double.infinity,
          color: primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Image.asset('assets/images/white.png', height: 40),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Barang Hunter Anda',
          style: ReuseText.display,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: FutureBuilder<List<Barang>>(
            future: barangHunterFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: ReuseColors.primary),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text("Gagal memuat barang."));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Belum ada barang yang dititipkan."));
              }

              final barangList = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: barangList.length,
                itemBuilder: (context, index) {
                  final barang = barangList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: ReuseStyles.card(),
                      child: ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius: ReuseColors.border),
                        onTap: () => showDetailBarangDialog(barang), // <-- Tambahkan ini
                        leading: ClipRRect(
                          borderRadius: ReuseColors.borderSmall,
                          child: Image.network(
                            '${AppConfig.baseUrl}/image/${barang.fotoBarang}',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (c, o, s) => const Icon(
                                Icons.broken_image,
                                color: ReuseColors.muted),
                          ),
                        ),
                        title: Text(barang.namaBarang,
                            style: ReuseText.cardTitle),
                        subtitle: Text("Rp ${barang.hargaBarang}",
                            style: ReuseText.caption),
                        trailing: const Icon(Icons.chevron_right,
                            color: ReuseColors.muted),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildProfileContent(Color primary, Color red, Color background) {
    return Column(
      children: [
        Container(height: MediaQuery.of(context).padding.top, color: primary),
        Container(
          width: double.infinity,
          color: primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Image.asset('assets/images/white.png', height: 40),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: background,
            borderRadius: ReuseColors.borderBottom,
          ),
          child: Center(
            child: Text(
              'Profile ${widget.pegawai.namaPegawai}',
              textAlign: TextAlign.center,
              style: ReuseText.title.copyWith(fontSize: 24),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                _buildField(Icons.person, 'Nama', widget.pegawai.namaPegawai),
                _buildField(Icons.email, 'Email', widget.pegawai.email),
                _buildField(Icons.cake, 'Tanggal Lahir', widget.pegawai.tglLahir),
                _buildField(Icons.phone, 'Nomor Telepon', widget.pegawai.nomorTelepon),
                _buildField(Icons.location_city, 'Alamat', widget.pegawai.alamat),
                _buildKomisiField(),
                const SizedBox(height: 100),
                _buildButton(
                  text: 'Detail Komisi',
                  backgroundColor: primary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailKomisiPage(idPegawai: widget.pegawai.idPegawai),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
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
                                Navigator.of(context).pop();
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
        ),
      ],
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

  Widget _buildKomisiField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        readOnly: true,
        controller: _komisiController,
        style: ReuseText.body,
        decoration: ReuseStyles.field(
          labelText: 'Jumlah Komisi',
          prefixIcon: const Icon(Icons.attach_money, color: ReuseColors.muted),
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

  void showDetailBarangDialog(Barang barang) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ReuseColors.surface,
          shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    barang.namaBarang,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ReuseColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: PageView(
                      children: [
                        ClipRRect(
                          borderRadius: ReuseColors.borderSmall,
                          child: Image.network(
                            '${AppConfig.baseUrl}/image/${barang.fotoBarang}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: ReuseColors.primarySoft,
                                  child: const Icon(Icons.broken_image,
                                      size: 64, color: ReuseColors.muted),
                                ),
                          ),
                        ),
                        if (barang.fotoBarang2 != null && barang.fotoBarang2!.isNotEmpty)
                          ClipRRect(
                            borderRadius: ReuseColors.borderSmall,
                            child: Image.network(
                              '${AppConfig.baseUrl}/image/${barang.fotoBarang2}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: ReuseColors.primarySoft,
                                    child: const Icon(Icons.broken_image,
                                        size: 64, color: ReuseColors.muted),
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    "ID Barang: ${barang.idBarang}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (barang.deskripsiBarang != null)
                    Text(
                      barang.deskripsiBarang!,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 10),
                  Text(
                    "Kategori: ${barang.kategori}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Harga: Rp ${barang.hargaBarang.toString()}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Status: ${barang.status}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ReuseStyles.primaryButton,
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tutup"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
