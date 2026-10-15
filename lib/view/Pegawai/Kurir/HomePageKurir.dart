import 'package:flutter/material.dart';
import '/entity/Pegawai.dart';
import '/entity/Pemesanan.dart';
import '/client/PemesananClient.dart';
import '/config.dart';
import '../Kurir/DetailPengiriman.dart';
import '../Kurir/ProfileKurirPage.dart';
import '../Kurir/KurirRiwayatPage.dart';

class HomePageKurir extends StatefulWidget {
  final Pegawai pegawai;
  const HomePageKurir({super.key, required this.pegawai});

  @override
  State<HomePageKurir> createState() => _HomePageKurirState();
}

class _HomePageKurirState extends State<HomePageKurir> {
  int _selectedIndex = 0;
  late Future<List<Pemesanan>> _pengirimanFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _pengirimanFuture = PemesananClient.fetchPengirimanByKurir(widget.pegawai.idPegawai);
  }

  void _refreshData() {
    setState(() => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF17616E);
    const backgroundColor = Color(0xFFF5E5C7);

    final pages = [
      buildHomePage(widget.pegawai),
      KurirRiwayatPage(pegawai: widget.pegawai),
      ProfileKurirPage(pegawai: widget.pegawai),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/white.png', height: 35),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedItemColor: backgroundColor,
        unselectedItemColor: backgroundColor.withOpacity(0.5),
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'Tugas'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget buildHomePage(Pegawai pegawai) {
    return FutureBuilder<List<Pemesanan>>(
      future: _pengirimanFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada tugas pengiriman.'));
        }

        final daftarPemesanan = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontFamily: 'Serif',
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  pegawai.namaPegawai,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tugas Pengiriman',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17616E),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
            ...daftarPemesanan.map((pemesanan) {
              final detailList = pemesanan.detail.take(2).toList();
              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPengirimanPage(
                        barangList: pemesanan.detail,
                        harga: pemesanan.totalHarga,
                        idPemesanan: pemesanan.idPemesanan,
                      ),
                    ),
                  );
                  _refreshData();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID Pesanan: ${pemesanan.idPemesanan}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      ...detailList.map((barang) {
                        String baseUrl = AppConfig.baseUrl;
                        String fotoPath = barang.fotoBarang.startsWith('/image')
                            ? barang.fotoBarang
                            : '/image/${barang.fotoBarang}';
                        String fullImageUrl = '$baseUrl$fotoPath';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  fullImageUrl,
                                  width: 80,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(barang.namaBarang, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Harga : Rp ${barang.harga}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
