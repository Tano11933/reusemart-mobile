import 'package:flutter/material.dart';
import '/client/KomisiClient.dart';
import '/entity/Komisi.dart';
import '/config.dart';

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
    const Color background = Color(0xFFF5E5C7);
    const Color primary = Color(0xFF17616E);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Detail Komisi'),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                          title: Text("Detail Komisi: ${komisi.idKomisi}"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ID Komisi: ${komisi.idKomisi}"),
                              Text("ID Barang: ${komisi.idBarang}"),
                              Text("ID Pemesanan: ${komisi.idPemesanan}"),
                              const SizedBox(height: 8),
                              Text("Komisi Perusahaan: Rp ${komisi.komisiPerusahaan.toStringAsFixed(0)}"),
                              Text("Komisi Hunter: Rp ${komisi.komisiHunter.toStringAsFixed(0)}"),
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
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ID Komisi: ${komisi.idKomisi}",
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text("Komisi Hunter: Rp ${komisi.komisiHunter.toStringAsFixed(0)}"),
                              ],
                            ),
                            if (komisi.fotoBarang != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  '${AppConfig.baseUrl}/image/${komisi.fotoBarang}',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 60),
                                ),
                              )
                          ],
                        )

                      ),
                    ),

                  );
                }

                ),
    );
  }
}