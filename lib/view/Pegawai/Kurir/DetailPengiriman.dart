import 'package:flutter/material.dart';
import '/entity/Pemesanan.dart';
import 'package:http/http.dart' as http;
import '/config.dart';
import '/theme.dart';

class DetailPengirimanPage extends StatefulWidget {
  final List<DetailPemesanan> barangList;
  final int harga;
  final String idPemesanan;

  const DetailPengirimanPage({
    super.key,
    required this.barangList,
    required this.harga,
    required this.idPemesanan,
  });

  @override
  State<DetailPengirimanPage> createState() => _DetailPengirimanPageState();
}

class _DetailPengirimanPageState extends State<DetailPengirimanPage> {
  bool _isLoading = false;
  bool _isSelesai = false;

  Future<void> _selesaikanPesanan(BuildContext context) async {
    setState(() => _isLoading = true);

    final url = Uri.parse('${AppConfig.apiUrl}/selesaikan-pesanan/${widget.idPemesanan}');
    final response = await http.put(url);

    setState(() {
      _isLoading = false;
      _isSelesai = response.statusCode == 200;
    });

    if (_isSelesai) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pesanan diselesaikan!")),
      );
      Future.delayed(const Duration(milliseconds: 800), () => Navigator.pop(context));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyelesaikan pesanan")),
      );
    }
  }

  Widget buildStatusBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Status Pengantaran",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ReuseColors.ink)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: _isSelesai ? 1.0 : null,
                minHeight: 8,
                backgroundColor: ReuseColors.line,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isSelesai ? ReuseColors.success : ReuseColors.accent,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              _isSelesai ? Icons.check_circle : Icons.delivery_dining,
              color: _isSelesai ? ReuseColors.success : ReuseColors.accent,
              size: 30,
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const baseUrl = AppConfig.baseUrl;

    return Scaffold(
      backgroundColor: ReuseColors.background,
      appBar: AppBar(
        backgroundColor: ReuseColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('P/M', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        actions: const [
          Icon(Icons.calendar_today, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.notifications, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100, top: 16),
            child: Column(
              children: [
                const Text('Detail Barang',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ReuseColors.primary)),
                const SizedBox(height: 12),
                buildStatusBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.barangList.length,
                    itemBuilder: (context, index) {
                      final barang = widget.barangList[index];
                      final fotoPath = barang.fotoBarang.startsWith('/image')
                          ? barang.fotoBarang // Untuk gambar yang ada di public/image
                          : '/image/${barang.fotoBarang}';
                      final imageUrl = '$baseUrl$fotoPath'; // Menambahkan URL lengkap gambar

                      return ReuseCard(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: ReuseColors.borderSmall,
                              child: Image.network(
                                imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 100,
                                  height: 100,
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
                                      style: ReuseText.cardTitle
                                          .copyWith(fontSize: 17)),
                                  const SizedBox(height: 8),
                                  Text("Deskripsi: ${barang.deskripsi}",
                                      style: ReuseText.body.copyWith(
                                          color: ReuseColors.muted)),
                                  Text("Kategori: ${barang.kategori}",
                                      style: ReuseText.body.copyWith(
                                          color: ReuseColors.muted)),
                                  Text("Status Garansi: ${barang.statusGaransi}",
                                      style: TextStyle(
                                        color: barang.statusGaransi
                                                .toLowerCase()
                                                .contains("tidak")
                                            ? ReuseColors.danger
                                            : ReuseColors.success,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(height: 8),
                                  Text("Harga: Rp ${barang.harga}",
                                      style: ReuseText.price.copyWith(
                                          fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading || _isSelesai ? null : () => _selesaikanPesanan(context),
                  style: ReuseStyles.primaryButton,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: ReuseColors.muted),
                        )
                      : const Text("Selesaikan Pesanan", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
