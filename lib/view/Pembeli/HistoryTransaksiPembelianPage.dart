import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/entity/Pemesanan.dart';
import '/client/PemesananClient.dart';
import '/config.dart';
import '/theme.dart';

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
    return Scaffold(
      backgroundColor: ReuseColors.background,
      appBar: AppBar(
        backgroundColor: ReuseColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ReuseColors.surface),
        title: Image.asset('assets/images/white.png', height: 32),
      ),

      body: FutureBuilder<List<Pemesanan>>(
        future: PemesananClient.fetchHistoryPembelian(widget.idPembeli),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ReuseColors.primary),
            );
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
                  ReuseCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                          borderRadius: ReuseColors.border),
                      leading: barangUtama != null && barangUtama.fotoBarang.isNotEmpty
                          ? ClipRRect(
                              borderRadius: ReuseColors.borderSmall,
                              child: Image.network(
                                '${AppConfig.baseUrl}/image/${barangUtama.fotoBarang}',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (c, o, s) => Container(
                                  color: ReuseColors.primarySoft,
                                  width: 56,
                                  height: 56,
                                  child: const Icon(Icons.broken_image,
                                      size: 40, color: ReuseColors.muted),
                                ),
                              ),
                            )
                          : Container(
                              color: ReuseColors.primarySoft,
                              width: 56,
                              height: 56,
                              child: const Icon(Icons.image,
                                  size: 36, color: ReuseColors.muted),
                            ),
                      title: Text(barangUtama?.namaBarang ?? '-',
                          style: ReuseText.cardTitle),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text("Tanggal: ${formatTanggal(t.tanggalPesan)}",
                              style: ReuseText.caption),
                          Text("Status: ${t.status}", style: ReuseText.caption),
                          Text("Total: Rp. ${t.totalHarga}",
                              style: ReuseText.price.copyWith(fontSize: 13)),
                        ],
                      ),
                      trailing: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: ReuseColors.primary),
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
                        color: ReuseColors.surface,
                        borderRadius: ReuseColors.borderSmall,
                        border: Border.all(color: ReuseColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Detail Pesanan:', style: ReuseText.cardTitle),
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
                                          borderRadius: ReuseColors.borderSmall,
                                          child: Image.network(
                                            '${AppConfig.baseUrl}/image/${d.fotoBarang}',
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, o, s) => Container(
                                              color: ReuseColors.primarySoft,
                                              width: 40,
                                              height: 40,
                                              child: const Icon(Icons.broken_image,
                                                  size: 24,
                                                  color: ReuseColors.muted),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: ReuseColors.primarySoft,
                                          width: 40,
                                          height: 40,
                                          child: const Icon(Icons.image,
                                              size: 22, color: ReuseColors.muted),
                                        ),
                                  title: Text(d.namaBarang,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Text('Harga: Rp. ${d.harga}',
                                      style: ReuseText.caption),
                                  trailing: Icon(detailExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                      color: ReuseColors.muted),
                                  onTap: () {
                                    setState(() {
                                      expandedDetailIndex = detailExpanded ? null : dIndex;
                                    });
                                  },
                                ),
                                if (detailExpanded)
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 6),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: ReuseColors.background,
                                      borderRadius: ReuseColors.borderSmall,
                                      border: Border.all(color: ReuseColors.line),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Nama: ${d.namaBarang}",
                                            style: ReuseText.cardTitle),
                                        const SizedBox(height: 4),
                                        Text("Kategori: ${d.kategori ?? '-'}",
                                            style: ReuseText.body),
                                        Text("Harga: Rp. ${d.harga}",
                                            style: ReuseText.body),
                                        Text("Deskripsi: ${d.deskripsi ?? '-'}",
                                            style: ReuseText.body),
                                        Text("Status Garansi: ${d.statusGaransi ?? '-'}",
                                            style: ReuseText.body),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Tanggal Titip: ${formatTanggal(d.tanggalTitip)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "Tanggal Laku: ${formatTanggal(d.tanggalLaku)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
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
