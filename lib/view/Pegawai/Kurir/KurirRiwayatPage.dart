import 'package:flutter/material.dart';
import '/entity/Pegawai.dart';
import '/entity/Pemesanan.dart';
import '/client/PemesananClient.dart';
import '/config.dart';
import 'package:intl/intl.dart';
import '/theme.dart';

class KurirRiwayatPage extends StatelessWidget {
  final Pegawai pegawai;
  const KurirRiwayatPage({super.key, required this.pegawai});

  // Function to parse and format date correctly
  String formatDate(String dateString) {
    try {
      // Jika tanggal menggunakan format ISO 8601 (seperti '2025-06-03T07:50:12.000000Z')
      if (dateString.contains('T')) {
        final DateTime dateTime = DateTime.parse(dateString); 
        final DateFormat formatter = DateFormat('dd MMM yyyy');
        return formatter.format(dateTime);
      } else if (dateString.isNotEmpty) {
        // Jika hanya tanggal standar (yyyy-MM-dd)
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final DateTime dateTime = formatter.parse(dateString);
        return DateFormat('dd MMM yyyy').format(dateTime);
      } else {
        return 'Tanggal tidak valid';
      }
    } catch (e) {
      print('Error parsing date: $e');
      return 'Tanggal tidak valid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pemesanan>>(
      future: PemesananClient.fetchHistoryByKurir(pegawai.idPegawai),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Belum ada riwayat pengiriman.'));
        }

        final daftarPemesanan = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: daftarPemesanan.length,
          itemBuilder: (context, index) {
            final pemesanan = daftarPemesanan[index];
            final detailList = pemesanan.detail.take(2).toList();

            return ReuseCard(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Riwayat Pengiriman",
                    style: ReuseText.section,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "ID Pesanan: ${pemesanan.idPemesanan}",
                    style: ReuseText.caption,
                  ),
                  const SizedBox(height: 8),
                  // Format tanggal pesan
                  Text("Tanggal Pesan: ${formatDate(pemesanan.tanggalPesan)}",
                      style: ReuseText.body),
                  const SizedBox(height: 12),
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
                            borderRadius: ReuseColors.borderSmall,
                            child: Image.network(
                              fullImageUrl,
                              width: 80,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 60,
                                color: ReuseColors.primarySoft,
                                child: const Icon(Icons.broken_image,
                                    color: ReuseColors.muted),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(barang.namaBarang,
                                    style: ReuseText.cardTitle),
                                const SizedBox(height: 4),
                                Text('Harga : Rp ${barang.harga}',
                                    style: ReuseText.caption),
                                const SizedBox(height: 4),
                                Text('Kategori: ${barang.kategori}',
                                    style: ReuseText.caption),
                                const SizedBox(height: 4),
                                // Format Tanggal Titip dan Tanggal Laku
                                // Text('Tanggal Titip: ${formatDate(barang.tanggalTitip)}',
                                //     style: const TextStyle(fontSize: 12)),
                                // Text('Tanggal Laku: ${formatDate(barang.tanggalLaku)}',
                                //     style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}