import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/entity/Penitip.dart';
import '/entity/Barang.dart';
import '/client/BarangClient.dart';
import 'ProfilPenitipPage.dart';
import '/config.dart';
import '/theme.dart';

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
        backgroundColor: ReuseColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
        title: Text(b.namaBarang,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: ReuseColors.border,
                  child: Image.network(
                    '${AppConfig.baseUrl}/image/${b.fotoBarang}',
                    width: 220,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(
                      width: 220, height: 180, color: ReuseColors.primarySoft,
                      child: const Icon(Icons.broken_image, size: 40, color: ReuseColors.muted),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ReuseColors.background,
                  borderRadius: ReuseColors.borderSmall,
                  border: Border.all(color: ReuseColors.line),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Harga", style: ReuseText.label),
                    Text("Rp. ${b.hargaBarang}", style: ReuseText.body.copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text("Kategori", style: ReuseText.label),
                    Text(b.kategori ?? "-", style: ReuseText.body.copyWith(fontSize: 15)),
                    const SizedBox(height: 10),
                    const Text("Deskripsi", style: ReuseText.label),
                    Text(b.deskripsiBarang ?? "-", style: ReuseText.body.copyWith(fontSize: 15)),
                    const SizedBox(height: 10),
                    const Text("Status", style: ReuseText.label),
                    Text(
                      b.status,
                      style: TextStyle(
                        fontSize: 15,
                        color: b.status.toLowerCase() == 'tersedia'
                            ? ReuseColors.success
                            : ReuseColors.danger,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (b.tglTitip != null && b.tglTitip.toString().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text("Tanggal Titip", style: ReuseText.label),
                      Text(b.tglTitip.toString().substring(0, 10),
                          style: ReuseText.body.copyWith(fontSize: 15)),
                    ],
                    if (b.tglAkhir != null && b.tglAkhir.toString().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text("Tanggal Akhir", style: ReuseText.label),
                      Text(b.tglAkhir.toString().substring(0, 10),
                          style: ReuseText.body.copyWith(fontSize: 15)),
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
        style: ReuseStyles.filterButton(selected: selected),
        onPressed: () {
          setState(() {
            statusFilter = value;
          });
        },
        child: Text(label),
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
        centerTitle: true,
        title: Image.asset(
          'assets/images/white.png', // ganti dengan 'black.png' kalau ingin logo hitam
          height: 32,
        ),
        automaticallyImplyLeading: false,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 18),
          Text(
            "Welcome Back",
            style: ReuseText.label.copyWith(fontSize: 15, letterSpacing: 1.1),
          ),
          const SizedBox(height: 2),
          Text(
            "${widget.penitip.namaPenitip}",
            style: ReuseText.title,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: ReuseColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events,
                color: ReuseColors.accent, size: 22),
          ),
          const SizedBox(height: 12),
          const Text(
            "Titipan Yang Masih Tersedia",
            style: ReuseText.section,
          ),
          const SizedBox(height: 10),

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
                      borderRadius: ReuseColors.border,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: ReuseStyles.card(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b.namaBarang,
                                      style: ReuseText.cardTitle,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "Harga : Rp. ${b.hargaBarang.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                                      style: ReuseText.caption,
                                    ),
                                    const SizedBox(height: 2),
                                    if (sisaHari != null)
                                      Text(
                                        "Sisa Hari: $sisaHari hari",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: sisaHari <= 3
                                              ? ReuseColors.danger
                                              : ReuseColors.accent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    Text(
                                      "Status : ${b.status}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: b.status.toLowerCase() == 'tersedia'
                                            ? ReuseColors.success
                                            : ReuseColors.danger,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(9),
                              child: ClipRRect(
                                borderRadius: ReuseColors.borderSmall,
                                child: Image.network(
                                  '${AppConfig.baseUrl}/image/${b.fotoBarang}',
                                  width: 90,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) => Container(
                                    width: 90,
                                    height: 70,
                                    color: ReuseColors.primarySoft,
                                    child: const Icon(Icons.image_not_supported,
                                        color: ReuseColors.muted),
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
        backgroundColor: ReuseColors.surface,
        selectedItemColor: ReuseColors.primary,
        unselectedItemColor: ReuseColors.muted,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: _onNavBarTapped,
      ),

    );
  }
}
