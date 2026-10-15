class Komisi {
  final String idKomisi;
  final String idBarang;
  final String idPemesanan;
  final String idPegawai;
  final double komisiPerusahaan;
  final double komisiHunter;
  final double bonus;
  final String? fotoBarang;
  final String? tglPesan;

  Komisi({
    required this.idKomisi,
    required this.idBarang,
    required this.idPemesanan,
    required this.idPegawai,
    required this.komisiPerusahaan,
    required this.komisiHunter,
    required this.bonus,
    this.fotoBarang,
    this.tglPesan,
  });

  factory Komisi.fromJson(Map<String, dynamic> json) {
    return Komisi(
      idKomisi: json['id_komisi'],
      idBarang: json['id_barang'],
      idPemesanan: json['id_pemesanan'],
      idPegawai: json['id_pegawai'],
      komisiPerusahaan: (json['komisi_perusahaan'] ?? 0).toDouble(),
      komisiHunter: (json['komisi_hunter'] ?? 0).toDouble(),
      bonus: (json['bonus'] ?? 0).toDouble(),
      fotoBarang: json['barang']?['foto_barang'],
      tglPesan: json['tgl_pesan'],
    );
  }
}
