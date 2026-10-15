import 'package:flutter/material.dart';
import '/entity/Barang.dart';
import '/client/BarangClient.dart';
import '/config.dart';

class DaftarBarangPembeli extends StatelessWidget {
  const DaftarBarangPembeli({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF5E5C7);
    const primary = Color(0xFF17616E);

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
      body: FutureBuilder<List<Barang>>(
        future: BarangClient.fetchBarangTersedia(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
              return InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => _showDetailBarangDialog(context, b),
                ),
                borderRadius: BorderRadius.circular(14),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                          child: Image.network(
                            "${AppConfig.baseUrl}/image/${b.fotoBarang}",
                            fit: BoxFit.cover,
                            errorBuilder: (c, o, s) => const Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.namaBarang,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Rp ${b.hargaBarang}",
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                          ],
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

  Dialog _showDetailBarangDialog(BuildContext context, Barang barang) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                barang.namaBarang,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF17616E),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: PageView(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '${AppConfig.baseUrl}/image/${barang.fotoBarang}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 80),
                            ),
                      ),
                    ),
                    if (barang.fotoBarang2 != null && barang.fotoBarang2!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '${AppConfig.baseUrl}/image/${barang.fotoBarang2}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 80),
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
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              Text("Kategori: ${barang.kategori}"),
              Text("Harga: Rp ${barang.hargaBarang}"),
              Text("Status: ${barang.status}"),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17616E),
                  foregroundColor: Colors.white,
                ),
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
