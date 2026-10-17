import 'package:flutter/material.dart';
import '/entity/Barang.dart';
import '/client/BarangClient.dart';
import '/config.dart';
import '/theme.dart';

class DaftarBarangPembeli extends StatelessWidget {
  const DaftarBarangPembeli({super.key});

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
      body: FutureBuilder<List<Barang>>(
        future: BarangClient.fetchBarangTersedia(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ReuseColors.primary),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat barang."));
          }

          final barangList = snapshot.data ?? [];
          if (barangList.isEmpty) {
            return const Center(child: Text("Belum ada barang tersedia."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: barangList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final b = barangList[index];
              return ReuseCard(
                padding: EdgeInsets.zero,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => _showDetailBarangDialog(context, b),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: ReuseColors.borderTop,
                        child: Image.network(
                          "${AppConfig.baseUrl}/image/${b.fotoBarang}",
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => Container(
                            color: ReuseColors.primarySoft,
                            child: const Icon(Icons.broken_image,
                                size: 40, color: ReuseColors.muted),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.namaBarang,
                            style: ReuseText.cardTitle.copyWith(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Rp ${b.hargaBarang}",
                            style: ReuseText.price.copyWith(fontSize: 13),
                          ),
                        ],
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

  Dialog _showDetailBarangDialog(BuildContext context, Barang barang) {
    return Dialog(
      backgroundColor: ReuseColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                barang.namaBarang,
                textAlign: TextAlign.center,
                style: ReuseText.cardTitle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: PageView(
                  children: [
                    ClipRRect(
                      borderRadius: ReuseColors.borderSmall,
                      child: Image.network(
                        '${AppConfig.baseUrl}/image/${barang.fotoBarang}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: ReuseColors.primarySoft,
                              child: const Icon(Icons.broken_image,
                                  size: 64, color: ReuseColors.muted),
                            ),
                      ),
                    ),
                    if (barang.fotoBarang2 != null && barang.fotoBarang2!.isNotEmpty)
                      ClipRRect(
                        borderRadius: ReuseColors.borderSmall,
                        child: Image.network(
                          '${AppConfig.baseUrl}/image/${barang.fotoBarang2}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: ReuseColors.primarySoft,
                                child: const Icon(Icons.broken_image,
                                    size: 64, color: ReuseColors.muted),
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (barang.deskripsiBarang != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    barang.deskripsiBarang!,
                    textAlign: TextAlign.center,
                    style: ReuseText.body,
                  ),
                ),
              Text("Kategori: ${barang.kategori}", style: ReuseText.body),
              Text("Harga: Rp ${barang.hargaBarang}", style: ReuseText.price),
              Text("Status: ${barang.status}", style: ReuseText.body),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ReuseStyles.primaryButton,
                onPressed: () => Navigator.pop(context),
                child: const Text("Tutup"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
