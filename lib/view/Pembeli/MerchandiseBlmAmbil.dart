import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/entity/TukarPoin.dart';
import '/client/MerchandiseClient.dart';
import '/config.dart';

class MerchandiseBlmAmbil extends StatelessWidget {
  final String idPembeli;
  const MerchandiseBlmAmbil({super.key, required this.idPembeli});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF5E5C7);
    const primary = Color(0xFF17616E);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/white.png', height: 35),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<TukarPoin>>(
        future: MerchandiseClient.fetchTukarPoinBelumDiambil(idPembeli),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data."));
          } else if ((snapshot.data ?? []).isEmpty) {
            return const Center(child: Text("Tidak ada penukaran poin."));
          }

          final list = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "${AppConfig.baseUrl}/storage/merchandise/${item.gambarMerch}",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.namaMerch,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                )),
                            const SizedBox(height: 4),
                            Text("Jumlah: ${item.jumlah}"),
                            Text("Tanggal Tukar: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.tglTukar))}"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.status,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
