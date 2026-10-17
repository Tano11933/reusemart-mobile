import 'package:flutter/material.dart';
import '/client/BarangClient.dart';
import '/entity/Barang.dart';
import '/config.dart';
import '/theme.dart';

class HistoryBarangTitipanPage extends StatelessWidget {
  final String idPenitip;
  const HistoryBarangTitipanPage({Key? key, required this.idPenitip}) : super(key: key);

  void _showDetailDialog(BuildContext context, Barang b) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ReuseColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
        title: Text(b.namaBarang, style: ReuseText.cardTitle),
        content: Column(
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

            // Boxed data
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
                    style: const TextStyle(
                      fontSize: 15,
                      color: ReuseColors.success,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (isi tetap)
    return Scaffold(
      backgroundColor: ReuseColors.background,
      appBar: AppBar(
        backgroundColor: ReuseColors.primary,
        foregroundColor: ReuseColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('History Barang Titipan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        iconTheme: const IconThemeData(color: ReuseColors.surface),
      ),
      body: FutureBuilder<List<Barang>>(
        future: BarangClient.fetchBarangPenitip(idPenitip),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ReuseColors.primary),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data barang."));
          }
          final barangList = (snapshot.data ?? [])
              .where((b) => b.status.toLowerCase() == 'transaksi selesai')
              .toList();

          if (barangList.isEmpty) {
            return const Center(child: Text("Belum ada barang dengan status transaksi selesai."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: barangList.length,
            itemBuilder: (context, i) {
              final b = barangList[i];
              return ReuseCard(
                margin: const EdgeInsets.only(bottom: 14),
                padding: EdgeInsets.zero,
                child: ListTile(
                  shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
                  leading: ClipRRect(
                    borderRadius: ReuseColors.borderSmall,
                    child: Image.network(
                      '${AppConfig.baseUrl}/image/${b.fotoBarang}',
                      width: 58,
                      height: 58,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => Container(
                        width: 58, height: 58, color: ReuseColors.primarySoft,
                        child: const Icon(Icons.broken_image, color: ReuseColors.muted),
                      ),
                    ),
                  ),
                  title: Text(b.namaBarang, style: ReuseText.cardTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text("Harga: Rp. ${b.hargaBarang}", style: ReuseText.caption),
                      Text("Status: ${b.status}", style: ReuseText.caption),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right, color: ReuseColors.muted),
                  onTap: () => _showDetailDialog(context, b),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
