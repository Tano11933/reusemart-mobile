import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/entity/Penitip.dart';
import '/entity/Barang.dart';
import '/client/BarangClient.dart';
import 'ProfilPenitipPage.dart';
import '/config.dart';

class HomePagePenitip extends StatefulWidget {
  final Penitip penitip;
  const HomePagePenitip({super.key, required this.penitip});

  @override
  State<HomePagePenitip> createState() => _HomePagePenitipState();
}

class _HomePagePenitipState extends State<HomePagePenitip> {
  late Future<List<Barang>> barangListFuture;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Set<String> _notifDonasi = {};
  int _selectedIndex = 0;
  String statusFilter = 'semua'; // semua, laku, belum, donasi

  @override
  void initState() {
    super.initState();
    barangListFuture = BarangClient.fetchBarangPenitip(widget.penitip.idPenitip);
    _initNotification();
  }

  Future<void> _initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );
  }

  Future<void> _showNotif(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'barang_channel',
      'Barang Channel',
      channelDescription: 'Notif barang titipan',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void _onNavBarTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilPenitipPage(penitip: widget.penitip),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  List<Barang> _filteredBarangList(List<Barang> barangList) {
    List<Barang> filtered = barangList;

    if (_selectedIndex == 0) {
      filtered = filtered.where((b) => b.status.toLowerCase() == 'tersedia').toList();
    }

    switch (statusFilter) {
      case 'terjual':
        filtered = filtered.where((b) => b.status.toLowerCase() == 'laku').toList();
        break;
      case 'belum':
        filtered = filtered.where((b) => b.status.toLowerCase() == 'tersedia').toList();
        break;
      case 'donasi':
        filtered = filtered.where((b) => b.status.toLowerCase().contains('didonasikan')).toList();
        break;
    }

    return filtered;
  }


  void _showDetailDialog(BuildContext context, Barang b) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(b.namaBarang, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    '${AppConfig.baseUrl}/image/${b.fotoBarang}',
                    width: 220,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(
                      width: 220, height: 180, color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Harga", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                    Text("Rp. ${b.hargaBarang}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                    Text(b.kategori ?? "-", style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),
                    Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                    Text(b.deskripsiBarang ?? "-", style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),
                    Text("Status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                    Text(
                      b.status,
                      style: TextStyle(
                        fontSize: 15,
                        color: b.status.toLowerCase() == 'tersedia' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (b.tglTitip != null && b.tglTitip.toString().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text("Tanggal Titip", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                      Text(b.tglTitip.toString().substring(0, 10), style: const TextStyle(fontSize: 15)),
                    ],
                    if (b.tglAkhir != null && b.tglAkhir.toString().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text("Tanggal Akhir", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                      Text(b.tglAkhir.toString().substring(0, 10), style: const TextStyle(fontSize: 15)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
  final bool selected = statusFilter == value;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? Color(0xFF207565) : Colors.white,
        foregroundColor: selected ? Colors.white : Color(0xFF207565),
        side: BorderSide(color: Color(0xFF207565)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: () {
        setState(() {
          statusFilter = value;
        });
      },
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    const Color cream = Color(0xFFFFEBD0);
    const Color green = Color(0xFF207565);
    const Color darkText = Color(0xFF31231C);

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17616E), // Sesuaikan warna utama kamu
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/white.png', // ganti dengan 'black.png' kalau ingin logo hitam
          height: 42,
        ),
        automaticallyImplyLeading: false,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 12),
          Text(
            "Welcome Back",
            style: TextStyle(
              color: darkText,
              fontSize: 19,
              fontWeight: FontWeight.w400,
              fontFamily: 'Georgia',
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "${widget.penitip.namaPenitip}",
            style: TextStyle(
              color: darkText,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 2),
          Icon(Icons.emoji_events, color: Color(0xFFD3A620), size: 24),
          SizedBox(height: 10),
          Text(
            "Titipan Yang Masih Tersedia",
            style: TextStyle(
              color: green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: 6),

          Expanded(
            child: FutureBuilder<List<Barang>>(
              future: barangListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Gagal mengambil data barang penitip."));
                }
                final barangList = _filteredBarangList(snapshot.data ?? []);
                if (barangList.isEmpty) {
                  return Center(
                    child: Text(_selectedIndex == 0
                        ? "Belum ada barang tersedia."
                        : "Belum ada barang titipan."),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: barangList.length,
                  itemBuilder: (context, i) {
                    final b = barangList[i];
                    final now = DateTime.now();
                    final nowDate = DateTime(now.year, now.month, now.day);
                    final sisaHari = b.tglAkhir != null
                        ? DateTime(b.tglAkhir!.year, b.tglAkhir!.month, b.tglAkhir!.day)
                            .difference(nowDate)
                            .inDays
                        : null;

                    if (
                      sisaHari != null &&
                      sisaHari == 3 &&
                      !_notifDonasi.contains("peringatan${b.idBarang}")
                    ) {
                      Future.microtask(() {
                        _showNotif(
                          'Perhatian: Masa Titipan Hampir Habis',
                          'Barang "${b.namaBarang}" tinggal 3 hari lagi masa penitipannya. Silakan perpanjang atau ambil barang Anda.',
                        );
                        _notifDonasi.add("peringatan${b.idBarang}");
                      });
                    }

                    return InkWell(
                      onTap: () => _showDetailDialog(context, b),
                      borderRadius: BorderRadius.circular(17),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b.namaBarang,
                                      style: TextStyle(
                                        color: darkText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "Harga : Rp. ${b.hargaBarang.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    if (sisaHari != null)
                                      Text(
                                        "Sisa Hari: $sisaHari hari",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: sisaHari <= 3
                                              ? Colors.red
                                              : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    Text(
                                      "Status : ${b.status}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: b.status.toLowerCase() == 'tersedia'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(9),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.network(
                                  '${AppConfig.baseUrl}/image/${b.fotoBarang}',
                                  width: 90,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) => Container(
                                    width: 90,
                                    height: 70,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.image_not_supported),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: cream,
        selectedItemColor: green,
        unselectedItemColor: green.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: _onNavBarTapped,
      ),

    );
  }
}
