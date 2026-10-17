import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../entity/Barang.dart';
import '../client/BarangClient.dart';
import '../entity/Penitip.dart';
import '../client/PenitipClient.dart';
import 'LoginPage.dart';
import 'HomePage.dart';
import '/config.dart';
import '../theme.dart';

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
    return Scaffold(
      backgroundColor: ReuseColors.background,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              // SLIDE 1 — Welcome, scrollable card info
              AnimatedSwitcher(
                duration: Duration(milliseconds: 700),
                child: Container(
                  key: ValueKey(_currentPage),
                  // Satu gradient tipis khusus slide pembuka.
                  decoration:
                      const BoxDecoration(gradient: ReuseColors.softGradient),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo Maskot
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: ReuseStyles.card(radius: 28),
                          child: Image.asset(
                            'assets/images/a.png',
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Judul utama
                        Text(
                          'Welcome to',
                          style: ReuseText.label.copyWith(
                            fontSize: 16,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          'ReuseMart',
                          style: ReuseText.display.copyWith(fontSize: 34),
                        ),
                        const SizedBox(height: 12),
                        // Slogan
                        Text(
                          'A Second Life for Quality Goods\nA Better Life for the Planet',
                          textAlign: TextAlign.center,
                          style: ReuseText.slogan,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 64,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: ReuseColors.accent,
                            borderRadius: ReuseColors.borderPill,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Produk Pilihan",
                        style: ReuseText.display,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: ReuseStyles.card(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Filter Garansi: ",
                              style: ReuseText.label,
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<int?>(
                              value: _garansiFilter,
                              dropdownColor: ReuseColors.surface,
                              hint: const Text("Semua", style: ReuseText.body),
                              items: const [
                                DropdownMenuItem(value: null, child: Text("Semua", style: ReuseText.body)),
                                DropdownMenuItem(value: 1, child: Text("Aktif", style: ReuseText.body)),
                                DropdownMenuItem(value: 0, child: Text("Mati", style: ReuseText.body)),
                              ],
                              onChanged: (value) {
                                setState(() => _garansiFilter = value);
                              },
                              iconEnabledColor: ReuseColors.primary,
                              underline: Container(height: 1, color: ReuseColors.line),
                              style: ReuseText.body, // warna teks pilihan aktif
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<Barang>>(
                        future: BarangClient.fetchBarangTersedia(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return GridView.builder(
                              itemCount: 6,
                              padding: const EdgeInsets.all(16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 0.72,
                              ),
                              itemBuilder: (c, i) => Shimmer.fromColors(
                                baseColor: ReuseColors.line,
                                highlightColor: ReuseColors.background,
                                child: Container(
                                  decoration: ReuseStyles.card(),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                "Gagal mengambil data barang.",
                                style: TextStyle(color: ReuseColors.danger, fontSize: 16),
                              ),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                "Belum ada barang tersedia.",
                                style: TextStyle(
                                    color: ReuseColors.muted,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16),
                              ),
                            );
                          }
                          final barangList = snapshot.data!
                            .where((b) => _garansiFilter == null || b.garansi == _garansiFilter)
                            .toList();
                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(14, 18, 14, 44),
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
                                    decoration: ReuseStyles.card(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        ClipRRect(
                                          borderRadius: ReuseColors.borderTop,
                                          child: Image.network(
                                            '${AppConfig.baseUrl}/image/${b.fotoBarang}',
                                            height: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, o, s) => Container(
                                              height: 90,
                                              color: ReuseColors.primarySoft,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: ReuseColors.muted,
                                              ),
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
                                                style: ReuseText.cardTitle
                                                    .copyWith(fontSize: 13),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text("Rp ${b.hargaBarang}",
                                                  style: ReuseText.price
                                                      .copyWith(fontSize: 12)),
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

              SafeArea(
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
                      return const Center(child: CircularProgressIndicator(color: ReuseColors.primary));
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Gagal memuat data top penitip", style: TextStyle(color: ReuseColors.danger)),
                      );
                    }

                    final list = snapshot.data ?? [];
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(18, 30, 18, 44),
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: ReuseColors.accentSoft,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.star, size: 56, color: ReuseColors.accent),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Top Seller of the Month",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: ReuseColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                getLastMonthName(),
                                style: ReuseText.label.copyWith(fontSize: 15, letterSpacing: 1.1),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                        if (list.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                "Belum ada data top seller bulan lalu.",
                                style: TextStyle(color: ReuseColors.muted, fontSize: 16, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ...list.map((p) {
                          bool isTop = list.indexOf(p) == 0;
                          final total = (p.totalHarga ?? 0);
                          final bonus = isTop && total > 0 ? (total * 0.01).round() : 0;
                          final totalDiterima = isTop ? total + bonus : total;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(14),
                            decoration: ReuseStyles.card(),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: ReuseColors.primarySoft,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 28,
                                    color: ReuseColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.namaPenitip,
                                          style: ReuseText.cardTitle.copyWith(fontSize: 16)),
                                      const SizedBox(height: 2),
                                      Text("Barang terjual: ${p.totalBarang ?? 0}",
                                          style: ReuseText.caption),
                                      Text("Total penjualan: Rp. ${p.totalHarga ?? 0}",
                                          style: ReuseText.caption),
                                      if (isTop && total > 0)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 4),
                                                decoration: ReuseStyles.chip(),
                                                child: Text(
                                                  "Bonus Top Seller: Rp. $bonus",
                                                  style: const TextStyle(
                                                    color: ReuseColors.ink,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Total diterima: Rp. $totalDiterima",
                                                style: const TextStyle(
                                                  color: ReuseColors.success,
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
                                  isTop
                                      ? Icons.workspace_premium_rounded
                                      : Icons.verified_user_rounded,
                                  color: isTop ? ReuseColors.accent : ReuseColors.muted,
                                  size: 30,
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
                color: ReuseColors.background,
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
                            color: ReuseColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: ReuseColors.cardShadow,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.recycling,
                              size: 72,
                              color: ReuseColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 800),
                        style: const TextStyle(
                          color: ReuseColors.primary,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                        child: Text('REUSE MART'),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'A Second Life for Quality Goods\nA Better Life for the Planet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ReuseColors.muted,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ReuseStyles.primaryButton,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            child: const Text('Login'),
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
                  duration: const Duration(milliseconds: 420),
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  width: _currentPage == i ? 32 : 12,
                  height: 9,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? ReuseColors.primary
                        : ReuseColors.primary.withValues(alpha: 0.25),
                    borderRadius: ReuseColors.borderPill,
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      backgroundColor: ReuseColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: ReuseColors.border),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              const Text(
                "Detail Barang Titipan",
                style: TextStyle(
                  color: ReuseColors.ink,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              // === FOTO BARANG DENGAN PAGEVIEW ===
              SizedBox(
                height: 180,
                child: PageView(
                  children: [
                    ClipRRect(
                      borderRadius: ReuseColors.borderSmall,
                      child: Image.network(
                        '${AppConfig.baseUrl}/image/${barang.fotoBarang}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
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
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: ReuseColors.primarySoft,
                            child: const Icon(Icons.broken_image,
                                size: 64, color: ReuseColors.muted),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                barang.namaBarang,
                style: ReuseText.cardTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: ReuseColors.background,
                  borderRadius: ReuseColors.border,
                  border: Border.all(color: ReuseColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Deskripsi Barang :\n",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ReuseColors.ink,
                            fontSize: 15),
                        children: [
                          TextSpan(
                            text: barang.deskripsiBarang ?? '-',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: ReuseColors.ink),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Kategori : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ReuseColors.ink,
                                fontSize: 15)),
                        Expanded(
                          child: Text(barang.kategori ?? '-', style: ReuseText.body),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text("Status Garansi : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ReuseColors.ink,
                                fontSize: 15)),
                        Text(
                          barang.garansi == 1 ? "Aktif" : "Mati",
                          style: TextStyle(
                            color: barang.garansi == 1
                                ? ReuseColors.success
                                : ReuseColors.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text("Harga :",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ReuseColors.ink,
                            fontSize: 15)),
                    Text("Rp ${barang.hargaBarang}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ReuseColors.primary,
                          fontSize: 21),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ReuseColors.primary,
                  foregroundColor: ReuseColors.surface,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: const RoundedRectangleBorder(
                      borderRadius: ReuseColors.borderPill),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Tutup"),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
