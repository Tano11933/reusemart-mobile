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
import '/theme.dart';

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
          backgroundColor: ReuseColors.surface,
          shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
          contentPadding: const EdgeInsets.all(16),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: ReuseColors.borderSmall,
                  child: merch.gambarMerch != null && merch.gambarMerch != ""
                      ? Image.network(
                          "${AppConfig.baseUrl}/storage/merchandise/${merch.gambarMerch}",
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => Container(
                            color: ReuseColors.primarySoft,
                            height: 150,
                            child: const Icon(Icons.broken_image,
                                size: 40, color: ReuseColors.muted),
                          ),
                        )
                      : Container(
                          color: ReuseColors.primarySoft,
                          height: 150,
                          child: const Icon(Icons.image,
                              size: 50, color: ReuseColors.muted),
                        ),
                ),
                const SizedBox(height: 14),
                Text(
                  merch.namaMerch ?? '-',
                  style: ReuseText.cardTitle.copyWith(fontSize: 17),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Stok: ${merch.stok ?? 0}",
                  style: ReuseText.label,
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp. ${merch.harga != null ? merch.harga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.') : '-'}",
                  style: ReuseText.price.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                if ((merch.stok ?? 0) > 0)
                  ElevatedButton(
                    style: ReuseStyles.primaryButton,
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showInputJumlahTukar(merch);
                    },
                    child: const Text("Tukar"),
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
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: ReuseStyles.card(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: merch.gambarMerch != null && merch.gambarMerch != ""
                          ? Image.network(
                              "${AppConfig.baseUrl}/storage/merchandise/${merch.gambarMerch}",
                              fit: BoxFit.cover,
                              errorBuilder: (c, o, s) => const Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: ReuseColors.muted),
                            )
                          : const Icon(Icons.image,
                              size: 50, color: ReuseColors.muted),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            merch.namaMerch ?? '-',
                            style: ReuseText.cardTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text("Stok: ${merch.stok ?? 0}",
                              style: ReuseText.caption),
                          const SizedBox(height: 4),
                          Text(
                            "Rp. ${merch.harga?.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.') ?? '-'}",
                            style: ReuseText.price,
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
    return Scaffold(
      backgroundColor: ReuseColors.background,
      appBar: AppBar(
        backgroundColor: ReuseColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset('assets/images/white.png', height: 32),
      ),
      body: FutureBuilder<List<Merchandise>>(
        future: merchandiseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ReuseColors.primary),
            );
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
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: ReuseStyles.card(),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                color: ReuseColors.primarySoft,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person,
                                  color: ReuseColors.primary, size: 30),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                "Welcome Back, ${widget.pembeli.namaPembeli}!",
                                style: ReuseText.title.copyWith(fontSize: 19),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ReuseCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MerchandiseBlmAmbil(
                                  idPembeli: widget.pembeli.idPembeli),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: ReuseColors.primarySoft,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.inventory_2_outlined,
                                  color: ReuseColors.primary),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                "Merchandise Belum Diambil",
                                style: ReuseText.cardTitle,
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: ReuseColors.muted),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      ReuseCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DaftarBarangPembeli(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: ReuseColors.accentSoft,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.storefront_outlined,
                                  color: ReuseColors.accent),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                "Daftar Barang Dijual",
                                style: ReuseText.cardTitle,
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: ReuseColors.muted),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                      style: ReuseText.display,
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
}
