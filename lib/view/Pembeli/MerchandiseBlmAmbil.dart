import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/entity/TukarPoin.dart';
import '/client/MerchandiseClient.dart';
import '/config.dart';
import '/theme.dart';

class MerchandiseBlmAmbil extends StatelessWidget {
  final String idPembeli;
  const MerchandiseBlmAmbil({super.key, required this.idPembeli});

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
      body: FutureBuilder<List<TukarPoin>>(
        future: MerchandiseClient.fetchTukarPoinBelumDiambil(idPembeli),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ReuseColors.primary),
            );
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
              return ReuseCard(
                margin: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: ReuseColors.borderSmall,
                      child: Image.network(
                        "${AppConfig.baseUrl}/storage/merchandise/${item.gambarMerch}",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: ReuseColors.primarySoft,
                          child: const Icon(Icons.broken_image,
                              color: ReuseColors.muted),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.namaMerch,
                              style: ReuseText.cardTitle.copyWith(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text("Jumlah: ${item.jumlah}",
                              style: ReuseText.caption),
                          const SizedBox(height: 2),
                          Text(
                            "Tanggal Tukar: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.tglTukar))}",
                            style: ReuseText.caption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: ReuseStyles.chip(),
                      child: Text(
                        item.status,
                        style: const TextStyle(
                          color: ReuseColors.ink,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
