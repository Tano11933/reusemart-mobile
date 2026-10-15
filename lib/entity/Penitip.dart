class Penitip {
  final String idPenitip;
  final String namaPenitip;
  final String email;
  final String nomorTelepon;
  final String nikPenitip;
  final String jenisKelamin;
  final String tglLahir;
  final double rating;
  final int saldo;
  final int poin;
  final int? totalBarang;
  final int? totalHarga;
  final int? totalPenjualanBulanLalu;
  final int? bonusBulanLalu;
  final bool? isTopSellerBulanLalu;

  Penitip({
    required this.idPenitip,
    required this.namaPenitip,
    required this.email,
    required this.nomorTelepon,
    required this.nikPenitip,
    required this.jenisKelamin,
    required this.tglLahir,
    required this.rating,
    required this.saldo,
    required this.poin,
    this.totalBarang,
    this.totalHarga,
    this.totalPenjualanBulanLalu,
    this.bonusBulanLalu,
    this.isTopSellerBulanLalu,
  });

  factory Penitip.fromJson(Map<String, dynamic> json) {
    return Penitip(
      idPenitip: json['id_penitip'] ?? '',
      namaPenitip: json['nama_penitip'] ?? json['nama'] ?? '',
      email: json['email'] ?? '',
      nomorTelepon: json['nomor_telepon'] ?? '',
      nikPenitip: json['nik_penitip'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      tglLahir: json['tgl_lahir'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      saldo: int.tryParse(json['saldo'].toString()) ?? 0,
      poin: int.tryParse(json['poin'].toString()) ?? 0,
      totalBarang: int.tryParse(json['totalBarang']?.toString() ?? '0') ?? 0,
      totalHarga: int.tryParse(json['totalHarga']?.toString() ?? '0') ?? 0,

      // FIELD DARI BACKEND, MAP KE CAMEL CASE
      totalPenjualanBulanLalu: json['total_penjualan_bulan_lalu'] != null
          ? int.tryParse(json['total_penjualan_bulan_lalu'].toString())
          : null,
      bonusBulanLalu: json['bonus_bulan_lalu'] != null
          ? int.tryParse(json['bonus_bulan_lalu'].toString())
          : null,
      isTopSellerBulanLalu: json['is_top_seller_bulan_lalu'] is bool
          ? json['is_top_seller_bulan_lalu']
          : (json['is_top_seller_bulan_lalu'] == 1 || json['is_top_seller_bulan_lalu'] == true),
    );
  }

}