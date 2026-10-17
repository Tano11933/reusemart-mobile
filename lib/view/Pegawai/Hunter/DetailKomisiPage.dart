import 'package:flutter/material.dart';
import '/client/KomisiClient.dart';
import '/entity/Komisi.dart';
import '/config.dart';
import '/theme.dart';

class DetailKomisiPage extends StatefulWidget {
  final String idPegawai;

  const DetailKomisiPage({super.key, required this.idPegawai});

  @override
  State<DetailKomisiPage> createState() => _DetailKomisiPageState();
}

class _DetailKomisiPageState extends State<DetailKomisiPage> {
  List<Komisi> _listKomisi = [];
  Set<int> expandedIndices = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadKomisiList();
  }

  Future<void> loadKomisiList() async {
    try {
      final result = await KomisiClient.fetchKomisiList(widget.idPegawai);
      setState(() {
        _listKomisi = result;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Gagal ambil list komisi: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReuseColors.background,
      appBar: AppBar(
        backgroundColor: ReuseColors.primary,
        title: const Text('Detail Komisi',
            style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: ReuseColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: ReuseColors.primary),
            )
          : _listKomisi.isEmpty
              ? const Center(child: Text("Belum ada data komisi."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _listKomisi.length,
                  itemBuilder: (context, index) {
                    final komisi = _listKomisi[index];

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: ReuseColors.surface,
                            shape: const RoundedRectangleBorder(
                                borderRadius: ReuseColors.border),
                            title: Text("Detail Komisi: ${komisi.idKomisi}",
                                style: ReuseText.cardTitle.copyWith(fontSize: 18)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ID Komisi: ${komisi.idKomisi}",
                                    style: ReuseText.body),
                                Text("ID Barang: ${komisi.idBarang}",
                                    style: ReuseText.body),
                                Text("ID Pemesanan: ${komisi.idPemesanan}",
                                    style: ReuseText.body),
                                const SizedBox(height: 10),
                                Text(
                                    "Komisi Perusahaan: Rp ${komisi.komisiPerusahaan.toStringAsFixed(0)}",
                                    style: ReuseText.body),
                                Text(
                                    "Komisi Hunter: Rp ${komisi.komisiHunter.toStringAsFixed(0)}",
                                    style: ReuseText.price),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Tutup"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: ReuseCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID Komisi: ${komisi.idKomisi}",
                                      style: ReuseText.cardTitle),
                                  const SizedBox(height: 6),
                                  Text(
                                      "Komisi Hunter: Rp ${komisi.komisiHunter.toStringAsFixed(0)}",
                                      style: ReuseText.price),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (komisi.fotoBarang != null)
                              ClipRRect(
                                borderRadius: ReuseColors.borderSmall,
                                child: Image.network(
                                  '${AppConfig.baseUrl}/image/${komisi.fotoBarang}',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image,
                                          size: 60, color: ReuseColors.muted),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
