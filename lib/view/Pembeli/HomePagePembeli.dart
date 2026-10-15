import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/entity/Pembeli.dart';
import '/entity/Merchandise.dart';
import '/entity/TukarPoin.dart';
import '/client/MerchandiseClient.dart';
import '/view/LoginPage.dart';
import '/view/Pembeli/ProfilPembeliPage.dart';
import '/view/Pembeli/HistoryTransaksiPembelianPage.dart';
import '/view/Pembeli/MerchandiseBlmAmbil.dart';
import '/view/Pembeli/DaftarBarangPembeli.dart';
import '/config.dart';

class HomePagePembeli extends StatefulWidget {
  final Pembeli pembeli;
  final int initialIndex;
  const HomePagePembeli({super.key, required this.pembeli, this.initialIndex = 0});

  @override
  State<HomePagePembeli> createState() => _HomePagePembeliState();
}


class _HomePagePembeliState extends State<HomePagePembeli> {
  late Future<List<Merchandise>> merchandiseFuture;
  int _selectedIndex = 0;
  late Future<List<TukarPoin>> tukarPoinFuture;

  @override
  void initState() {
    super.initState();
    merchandiseFuture = MerchandiseClient.fetchAllMerchandise();
    tukarPoinFuture = MerchandiseClient.fetchTukarPoinBelumDiambil(widget.pembeli.idPembeli);
    _selectedIndex = widget.initialIndex;
  }

  Future<void> _refreshPembeli() async {
    final updated = await MerchandiseClient.fetchPembeliById(widget.pembeli.idPembeli);
    setState(() {
      widget.pembeli.poin = updated.poin; // atau update semua field jika perlu
    });
  }


  void _onNavTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilPembeliPage(pembeli: widget.pembeli),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showInputJumlahTukar(Merchandise merch) {
    final TextEditingController _jumlahController = TextEditingController(text: "1");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Jumlah Penukaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Masukkan jumlah '${merch.namaMerch}' yang ingin ditukar."),
              const SizedBox(height: 10),
              TextField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jumlah",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final jml = int.tryParse(_jumlahController.text);
                if (jml == null || jml <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Jumlah tidak valid.")),
                  );
                  return;
                }

                Navigator.of(context).pop(); // tutup input jumlah
                _showKonfirmasiTukar(merch, jml);
              },
              child: const Text("Lanjut"),
              
            ),
          ],
        );
      },
    );
  }


  void _showKonfirmasiTukar(Merchandise merch, int jumlah) {
    final dialogContext = context; // simpan context sebelum async

    showDialog(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penukaran"),
          content: Text(
            "Apakah Anda yakin ingin menukar $jumlah '${merch.namaMerch}' "
            "dengan total Rp. ${(merch.harga ?? 0) * jumlah} poin?"
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Tidak"),
            ),
            ElevatedButton(
              onPressed: () async {
                final totalHarga = (merch.harga ?? 0) * jumlah;

                if ((widget.pembeli.poin ?? 0) < totalHarga) {
                  Navigator.of(dialogContext).pop(); // tutup dialog
                  _showAlert(dialogContext, "Poin Anda tidak mencukupi untuk melakukan penukaran ini.");
                  return;
                }

                Navigator.of(dialogContext).pop(); // tutup dialog

                final result = await MerchandiseClient.tukarPoin(
                  widget.pembeli.idPembeli,
                  merch.idMerch,
                  jumlah,
                );


                if (!mounted) return; // pastikan widget masih hidup

                if (result['success'] == true) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text("Berhasil menukar poin!")),
                  );
                  await _refreshPembeli(); // ⬅️ Refresh data profil (poin)
                  setState(() {
                    merchandiseFuture = MerchandiseClient.fetchAllMerchandise();
                    tukarPoinFuture = MerchandiseClient.fetchTukarPoinBelumDiambil(widget.pembeli.idPembeli);
                  });
                }

              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }


  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Peringatan"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _showDetailPopup(BuildContext context, Merchandise merch) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          contentPadding: const EdgeInsets.all(16),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: merch.gambarMerch != null && merch.gambarMerch != ""
                      ? Image.network(
                          "${AppConfig.baseUrl}/storage/merchandise/${merch.gambarMerch}",
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => Container(
                            color: Colors.grey[200],
                            height: 150,
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                        )
                      : Container(
                          color: Colors.grey[100],
                          height: 150,
                          child: const Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                ),
                const SizedBox(height: 14),
                Text(
                  merch.namaMerch ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Stok: ${merch.stok ?? 0}",
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp. ${merch.harga != null ? merch.harga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.') : '-'}",
                  style: const TextStyle(fontSize: 16, color: Color(0xFF17616E)),
                ),
                const SizedBox(height: 10),
                if ((merch.stok ?? 0) > 0)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showInputJumlahTukar(merch);
                    },
                    child: const Text("Tukar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF17616E),
                      foregroundColor: Colors.white, 
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCatalogGrid(List<Merchandise> merchList, {bool full = false}) {
    final showList = full ? merchList : merchList.take(6).toList(); // 6 item untuk home
    return Center(
      child: SizedBox(
        width: 600,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          shrinkWrap: true,
          itemCount: showList.length,
          itemBuilder: (context, index) {
            final merch = showList[index];
            return GestureDetector(
              onTap: () => _showDetailPopup(context, merch),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: merch.gambarMerch != null && merch.gambarMerch != ""
                            ? Image.network(
                                "${AppConfig.baseUrl}/storage/merchandise/${merch.gambarMerch}",
                                fit: BoxFit.cover,
                                errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 40),
                              )
                            : const Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            merch.namaMerch ?? '-',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text("Stok: ${merch.stok ?? 0}"),
                          const SizedBox(height: 4),
                          Text(
                            "Rp. ${merch.harga?.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.') ?? '-'}",
                            style: const TextStyle(color: Color(0xFF17616E)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    const Color background = Color(0xFFF5E5C7);
    const Color primary = Color(0xFF17616E);
    const Color darkText = Color(0xFF31231C);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/white.png', height: 35),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Merchandise>>(
        future: merchandiseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data merchandise."));
          }
          final merchList = snapshot.data ?? [];
          if (merchList.isEmpty) {
            return const Center(child: Text("Belum ada merchandise."));
          }

          // Home tab (0): Welcome, Nama, Judul, lalu 2 katalog
          if (_selectedIndex == 0) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Center(
                    child: Text(
                      "Welcome Back, ${widget.pembeli.namaPembeli}!",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF17616E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 220),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.inventory),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          "Merchandise Belum Diambil",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MerchandiseBlmAmbil(idPembeli: widget.pembeli.idPembeli),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF17616E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.store),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          "Daftar Barang Dijual",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DaftarBarangPembeli(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF17616E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (_selectedIndex == 1) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      "Katalog Merchandise",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF17616E),
                      ),
                    ),
                  ),

                ),
                const SizedBox(height: 10),
                Expanded(child: _buildCatalogGrid(merchList, full: true)),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
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
}
