  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import '/entity/Pemesanan.dart';
  import '/client/PemesananClient.dart';
import '/config.dart';

  class HistoryTransaksiPembelianPage extends StatefulWidget {
    final String idPembeli;
    const HistoryTransaksiPembelianPage({Key? key, required this.idPembeli}) : super(key: key);

    @override
    State<HistoryTransaksiPembelianPage> createState() => _HistoryTransaksiPembelianPageState();
  }

  class _HistoryTransaksiPembelianPageState extends State<HistoryTransaksiPembelianPage> {
    int? expandedIndex;
    int? expandedDetailIndex;
    int _selectedIndex = 1;

    void _onNavTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    String formatTanggal(String input) {
      try {
        final dateTime = DateTime.parse(input);
        return DateFormat('dd MMM yyyy', 'en_US').format(dateTime);
      } catch (_) {
        return input;
      }
    }

    @override
    Widget build(BuildContext context) {
      const Color background = Color(0xFFF5E5C7);
      const Color primary = Color(0xFF17616E);

      return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: primary,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/white.png', height: 35),
            ],
          ),
        ),

        body: FutureBuilder<List<Pemesanan>>(
          future: PemesananClient.fetchHistoryPembelian(widget.idPembeli),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Gagal memuat data transaksi."));
            }
            final transaksiList = snapshot.data ?? [];
            if (transaksiList.isEmpty) {
              return const Center(child: Text("Belum ada transaksi pembelian."));
            }
            return ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final t = transaksiList[index];
                final barangUtama = t.detail.isNotEmpty ? t.detail[0] : null;
                final isExpanded = expandedIndex == index;
                return Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 3,
                      child: ListTile(
                        leading: barangUtama != null && barangUtama.fotoBarang.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  '${AppConfig.baseUrl}/image/${barangUtama.fotoBarang}',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) => Container(
                                    color: Colors.grey[200],
                                    width: 56,
                                    height: 56,
                                    child: const Icon(Icons.broken_image, size: 40),
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.grey[100],
                                width: 56,
                                height: 56,
                                child: const Icon(Icons.image, size: 36, color: Colors.grey),
                              ),
                        title: Text(barangUtama?.namaBarang ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tanggal: ${formatTanggal(t.tanggalPesan)}", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            Text("Status: ${t.status}", style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                            Text("Total: Rp. ${t.totalHarga}", style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                        trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: primary),
                        onTap: () {
                          setState(() {
                            expandedIndex = isExpanded ? null : index;
                            expandedDetailIndex = null;
                          });
                        },
                      ),
                    ),
                    if (isExpanded)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Detail Pesanan:', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...List.generate(t.detail.length, (dIndex) {
                              final d = t.detail[dIndex];
                              final detailExpanded = expandedDetailIndex == dIndex;

                              // ----> TAMBAHKAN DEBUG PRINT DI SINI <----
                              print('RAW TITIP: ${d.tanggalTitip}');
                              print('PARSED TITIP: ${formatTanggal(d.tanggalTitip)}');
                              return Column(
                                children: [
                                  ListTile(
                                    leading: d.fotoBarang.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: Image.network(
                                              '${AppConfig.baseUrl}/image/${d.fotoBarang}',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (c, o, s) => Container(
                                                color: Colors.grey[200],
                                                width: 40,
                                                height: 40,
                                                child: const Icon(Icons.broken_image, size: 24),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.grey[100],
                                            width: 40,
                                            height: 40,
                                            child: const Icon(Icons.image, size: 22, color: Colors.grey),
                                          ),
                                    title: Text(d.namaBarang, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    subtitle: Text('Harga: Rp. ${d.harga}'),
                                    trailing: Icon(detailExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                                    onTap: () {
                                      setState(() {
                                        expandedDetailIndex = detailExpanded ? null : dIndex;
                                      });
                                    },
                                  ),
                                  if (detailExpanded)
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Nama: ${d.namaBarang}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Text("Kategori: ${d.kategori ?? '-'}"),
                                          Text("Harga: Rp. ${d.harga}"),
                                          Text("Deskripsi: ${d.deskripsi ?? '-'}"),
                                          Text("Status Garansi: ${d.statusGaransi ?? '-'}"),
                                          Text(
                                            "Tanggal Titip: ${formatTanggal(d.tanggalTitip)}",
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "Tanggal Laku: ${formatTanggal(d.tanggalLaku)}",
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      );
    }
  }
