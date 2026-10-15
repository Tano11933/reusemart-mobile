import 'package:flutter/material.dart';
import '/client/BarangClient.dart';
import '/entity/Barang.dart';
import '/config.dart';

class HistoryBarangTitipanPage extends StatelessWidget {
  final String idPenitip;
  const HistoryBarangTitipanPage({Key? key, required this.idPenitip}) : super(key: key);

  void _showDetailDialog(BuildContext context, Barang b) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(b.namaBarang, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
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

    // Boxed data
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
              color: Colors.red[700],
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
      backgroundColor: const Color(0xFFF5E5C7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5E5C7),
        elevation: 0,
        title: const Text('History Barang Titipan',
            style: TextStyle(color: Color(0xFF17616E), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF17616E)),
      ),
      body: FutureBuilder<List<Barang>>(
        future: BarangClient.fetchBarangPenitip(idPenitip),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                margin: const EdgeInsets.only(bottom: 14),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '${AppConfig.baseUrl}/image/${b.fotoBarang}',
                      width: 58,
                      height: 58,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => Container(
                        width: 58, height: 58, color: Colors.grey[200],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  title: Text(b.namaBarang, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Harga: Rp. ${b.hargaBarang}"),
                      Text("Status: ${b.status}", style: const TextStyle(fontSize: 13)),
                    ],
                  ),
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
