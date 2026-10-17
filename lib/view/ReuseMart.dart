import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../entity/Barang.dart';
import '../client/BarangClient.dart';
import '../entity/Penitip.dart';
import '../client/PenitipClient.dart';
import 'LoginPage.dart';
import 'HomePage.dart';
import '/config.dart';

class ReuseMart extends StatefulWidget {
  @override
  State<ReuseMart> createState() => _ReuseMartState();
}

class _ReuseMartState extends State<ReuseMart> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int? _garansiFilter; 


  // Animasi bounce saat tap card
  final ValueNotifier<int?> _bounceCardIndex = ValueNotifier(null);

  @override
  void dispose() {
    _pageController.dispose();
    _bounceCardIndex.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF173B61);
    const lightBlue = Color(0xFF7697A0);
    const cream = Color(0xFFFFEBD0);

    return Scaffold(
      backgroundColor: darkBlue,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _currentPage == 0 ? darkBlue : lightBlue,
                  _currentPage == 1 ? Colors.blueGrey : darkBlue,
                  _currentPage == 2 ? Colors.amber[100]! : cream
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              // SLIDE 1 — Welcome, scrollable card info
              AnimatedSwitcher(
                duration: Duration(milliseconds: 700),
                child: Container(
                  key: ValueKey(_currentPage),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [darkBlue, lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo Maskot
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Image.asset(
                            'assets/images/a.png',
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Judul utama
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            color: cream,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 1.5,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                          ),
                        ),
                        Text(
                          'ReuseMart',
                          style: TextStyle(
                            color: cream,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            letterSpacing: 2,
                            shadows: [Shadow(color: Colors.black38, blurRadius: 8)],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Slogan
                        Text(
                          'A Second Life for Quality Goods\nA Better Life for the Planet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.amber[100],
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 44),
                    Center(
                      child: Text(
                        "Produk Pilihan",
                        style: TextStyle(
                          color: cream,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: 1.4,
                          shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Filter Garansi: ",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(width: 8),
                          DropdownButton<int?>(
                            value: _garansiFilter,
                            dropdownColor: Colors.grey[900], // supaya kontras gelap
                            hint: Text("Semua", style: TextStyle(color: Colors.white)),
                            items: [
                              DropdownMenuItem(value: null, child: Text("Semua", style: TextStyle(color: Colors.white))),
                              DropdownMenuItem(value: 1, child: Text("Aktif", style: TextStyle(color: Colors.white))),
                              DropdownMenuItem(value: 0, child: Text("Mati", style: TextStyle(color: Colors.white))),
                            ],
                            onChanged: (value) {
                              setState(() => _garansiFilter = value);
                            },
                            iconEnabledColor: Colors.white,
                            underline: Container(height: 1, color: Colors.white54),
                            style: TextStyle(color: Colors.white), // warna teks pilihan aktif
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<Barang>>(
                        future: BarangClient.fetchBarangTersedia(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return GridView.builder(
                              itemCount: 6,
                              padding: EdgeInsets.all(16),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 0.72,
                              ),
                              itemBuilder: (c, i) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Gagal mengambil data barang.",
                                style: TextStyle(color: Colors.redAccent, fontSize: 16),
                              ),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                "Belum ada barang tersedia.",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16),
                              ),
                            );
                          }
                          final barangList = snapshot.data!
                            .where((b) => _garansiFilter == null || b.garansi == _garansiFilter)
                            .toList();
                          return GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: barangList.length,
                            itemBuilder: (context, i) {
                              final b = barangList[i];
                              return GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      barrierDismissible: true,
                                      pageBuilder: (context, _, __) =>
                                          BarangDetailDialog(barang: b),
                                      transitionsBuilder: (c, anim, _, child) => FadeTransition(
                                        opacity: anim,
                                        child: ScaleTransition(
                                          scale: Tween<double>(begin: 0.92, end: 1.0)
                                              .animate(CurvedAnimation(
                                                  parent: anim, curve: Curves.easeOut)),
                                          child: child,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: 'foto-barang-${b.idBarang}',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.96),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Color(0xFFB2E3F7), width: 1.5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(18)),
                                          child: Image.network(
                                            '${AppConfig.baseUrl}/image/${b.fotoBarang}',
                                            height: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, o, s) => Container(
                                              height: 90,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.image_not_supported),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                b.namaBarang,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.black87),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 2),
                                              Text("Rp ${b.hargaBarang}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[700])),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2C5364), Color(0xFF203A43)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FutureBuilder<List<Penitip>>(
                future: PenitipClient.fetchTopPenitip(), // Pastikan ini sudah sorted by bulan sebelumnya
                builder: (context, snapshot) {
                  String getLastMonthName() {
                    final now = DateTime.now();
                    final lastMonth = now.month == 1
                        ? DateTime(now.year - 1, 12)
                        : DateTime(now.year, now.month - 1);
                    const monthNames = [
                      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
                      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
                    ];
                    return "${monthNames[lastMonth.month]} ${lastMonth.year}";
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.amber));
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Gagal memuat data top penitip", style: TextStyle(color: Colors.redAccent)),
                    );
                  }

                  final list = snapshot.data ?? [];
                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.star, size: 100, color: Colors.amber),
                            const SizedBox(height: 16),
                            Text(
                              "Top Seller of the Month",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.amber[100],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              getLastMonthName(),
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      if (list.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              "Belum ada data top seller bulan lalu.",
                              style: TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ...list.map((p) {
                        bool isTop = list.indexOf(p) == 0;
                        final total = (p.totalHarga ?? 0);
                        final bonus = isTop && total > 0 ? (total * 0.01).round() : 0;
                        final totalDiterima = isTop ? total + bonus : total;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.account_circle_rounded, size: 54, color: Color(0xFF3A3A3A)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.namaPenitip, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                    Text("Barang terjual: ${p.totalBarang ?? 0}"),
                                    Text("Total penjualan: Rp. ${p.totalHarga ?? 0}"),
                                    if (isTop && total > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Bonus Top Seller: Rp. $bonus",
                                              style: TextStyle(
                                                color: Colors.orange[800],
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Text(
                                              "Total diterima: Rp. $totalDiterima",
                                              style: TextStyle(
                                                color: Colors.green[700],
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                isTop ? Icons.workspace_premium_rounded : Icons.verified_user_rounded,
                                color: isTop ? Colors.amber : Colors.blueAccent,
                                size: 34,
                              ),
                            ],
                          ),
                        );
                      }),

                    ],
                  );
                },
              ),
            ),

            // SLIDE 4 — Top Sellers by Nominal
          // Container(
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Color(0xFF2C5364), Color(0xFF203A43)],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //   ),
          //   child: FutureBuilder<List<Penitip>>(
          //     future: PenitipClient.fetchTopPenitipByNominal(), // Fetch top penitips sorted by nominal sales
          //     builder: (context, snapshot) {
          //       String getLastMonthName() {
          //         final now = DateTime.now();
          //         final lastMonth = now.month == 1
          //             ? DateTime(now.year - 1, 12)
          //             : DateTime(now.year, now.month - 1);
          //         const monthNames = [
          //           '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          //           'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
          //         ];
          //         return "${monthNames[lastMonth.month]} ${lastMonth.year}";
          //       }

          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator(color: Colors.amber));
          //       }
          //       if (snapshot.hasError) {
          //         return Center(
          //           child: Text("Gagal memuat data top penitip berdasarkan nominal", style: TextStyle(color: Colors.redAccent)),
          //         );
          //       }

          //       final list = snapshot.data ?? [];
          //       return ListView(
          //         padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
          //         children: [
          //           Center(
          //             child: Column(
          //               children: [
          //                 const Icon(Icons.star, size: 100, color: Colors.amber),
          //                 const SizedBox(height: 16),
          //                 Text(
          //                   "Top Seller by Nominal",
          //                   style: TextStyle(
          //                     fontSize: 24,
          //                     color: Colors.amber[100],
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 const SizedBox(height: 2),
          //                 Text(
          //                   getLastMonthName(),
          //                   style: const TextStyle(
          //                     fontSize: 17,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.w600,
          //                     letterSpacing: 1.1,
          //                   ),
          //                 ),
          //                 const SizedBox(height: 30),
          //               ],
          //             ),
          //           ),
          //           if (list.isEmpty)
          //             Center(
          //               child: Padding(
          //                 padding: const EdgeInsets.only(top: 30),
          //                 child: Text(
          //                   "Belum ada data top seller berdasarkan nominal bulan lalu.",
          //                   style: TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic),
          //                 ),
          //               ),
          //             ),
          //           ...list.map((p) {
          //             bool isTop = list.indexOf(p) == 0;
          //             final total = (p.totalHarga ?? 0);
          //             final bonus = isTop && total > 0 ? (total * 0.01).round() : 0;
          //             final totalDiterima = isTop ? total + bonus : total;

          //             return Container(
          //               margin: const EdgeInsets.only(bottom: 20),
          //               padding: const EdgeInsets.all(14),
          //               decoration: BoxDecoration(
          //                 color: Colors.white.withOpacity(0.92),
          //                 borderRadius: BorderRadius.circular(15),
          //               ),
          //               child: Row(
          //                 children: [
          //                   const Icon(Icons.account_circle_rounded, size: 54, color: Color(0xFF3A3A3A)),
          //                   const SizedBox(width: 16),
          //                   Expanded(
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(p.namaPenitip, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          //                         Text("Barang terjual: ${p.totalBarang ?? 0}"),
          //                         Text("Total penjualan: Rp. ${p.totalHarga ?? 0}"),
          //                         if (isTop && total > 0)
          //                           Padding(
          //                             padding: const EdgeInsets.only(top: 3.0),
          //                             child: Column(
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   "Bonus Top Seller: Rp. $bonus",
          //                                   style: TextStyle(
          //                                     color: Colors.orange[800],
          //                                     fontSize: 13,
          //                                     fontWeight: FontWeight.bold,
          //                                     fontStyle: FontStyle.italic,
          //                                   ),
          //                                 ),
          //                                 Text(
          //                                   "Total diterima: Rp. $totalDiterima",
          //                                   style: TextStyle(
          //                                     color: Colors.green[700],
          //                                     fontSize: 14,
          //                                     fontWeight: FontWeight.bold,
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                       ],
          //                     ),
          //                   ),
          //                   Icon(
          //                     isTop ? Icons.workspace_premium_rounded : Icons.verified_user_rounded,
          //                     color: isTop ? Colors.amber : Colors.blueAccent,
          //                     size: 34,
          //                   ),
          //                 ],
          //               ),
          //             );
          //           }),

          //         ],
          //       );
          //     },
          //   ),
          // ),

              // SLIDE 3 — Splash & Aksi
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF17616E), Color(0xFF173B61)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.85, end: 1.0),
                        duration: Duration(milliseconds: 900),
                        curve: Curves.elasticOut,
                        builder: (c, scale, w) => Transform.scale(scale: scale, child: w),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: cream,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.20),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.recycling,
                              size: 80,
                              color: darkBlue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 800),
                        style: TextStyle(
                          color: cream,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: Offset(2, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Text('REUSE MART'),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'A Second Life for Quality Goods\nA Better Life for the Planet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: lightBlue,
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.10),
                                offset: Offset(1, 1),
                                blurRadius: 1.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      const SizedBox(height: 18),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: cream, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: cream,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // ==== DOTS ANIMATOR ====
          Positioned(
            bottom: 24,
            left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 420),
                  margin: EdgeInsets.symmetric(horizontal: 7),
                  width: _currentPage == i ? 32 : 12,
                  height: 9,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? cream : cream.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

/// Fade & scale transition dialog untuk detail barang
class BarangDetailDialog extends StatelessWidget {
  final Barang barang;
  const BarangDetailDialog({Key? key, required this.barang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      backgroundColor: Color(0xFFFFEBD0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 13),
              Text(
                "Detail Barang Titipan",
                style: TextStyle(
                  color: Color(0xFF173B61),
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 14),
              // === FOTO BARANG DENGAN PAGEVIEW ===
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
              SizedBox(height: 13),
              Text(
                barang.namaBarang,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7, horizontal: 0),
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, blurRadius: 8, offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Deskripsi Barang :\n",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                        children: [
                          TextSpan(
                            text: barang.deskripsiBarang ?? '-',
                            style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text("Kategori : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        Text(barang.kategori ?? '-'),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Status Garansi : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        Text(
                          barang.garansi == 1 ? "Aktif" : "Mati",
                          style: TextStyle(
                            color: barang.garansi == 1 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Harga :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    Text("Rp ${barang.hargaBarang}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 21),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text("Tutup", style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF173B61),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}
