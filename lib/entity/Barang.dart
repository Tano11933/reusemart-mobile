class Barang {
  final String idBarang;
  final String idPenitip;
  final String idPegawai;
  final String namaBarang;
  final String deskripsiBarang;
  final String kategori;
  final int hargaBarang;
  final DateTime? tglTitip;
  final DateTime? tglGaransi;
  final DateTime? tglLaku;
  final DateTime? tglAkhir;
  final int garansi;
  final int perpanjangan;
  final String status;
  final String fotoBarang;
  final String fotoBarang2;
  final String? idHunter;

  Barang({
    required this.idBarang,
    required this.idPenitip,
    required this.idPegawai,
    required this.namaBarang,
    required this.deskripsiBarang,
    required this.kategori,
    required this.hargaBarang,
    this.tglTitip,
    this.tglGaransi,
    this.tglLaku,
    this.tglAkhir,
    this.idHunter,
    required this.garansi,
    required this.perpanjangan,
    required this.status,
    required this.fotoBarang,
    required this.fotoBarang2,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? str) {
      if (str == null || str.isEmpty) return null;
      try {
        return DateTime.parse(str);
      } catch (_) {
        return null;
      }
    }

    return Barang(
      idBarang: json['id_barang'] ?? '',
      idPenitip: json['id_penitip'] ?? '',
      idPegawai: json['id_pegawai'] ?? '',
      namaBarang: json['nama_barang'] ?? '',
      deskripsiBarang: json['deskripsi_barang'] ?? '',
      kategori: json['kategori'] ?? '',
      hargaBarang: int.tryParse(json['harga_barang'].toString()) ?? 0,
      tglTitip: parseDate(json['tgl_titip']),
      tglGaransi: parseDate(json['tgl_garansi']),
      tglLaku: parseDate(json['tgl_laku']),
      tglAkhir: parseDate(json['tgl_akhir']),
      garansi: (json['garansi'] is bool)
          ? (json['garansi'] ? 1 : 0)
          : int.tryParse(json['garansi'].toString()) ?? 0,
      perpanjangan: (json['perpanjangan'] is bool)
          ? (json['perpanjangan'] ? 1 : 0)
          : int.tryParse(json['perpanjangan'].toString()) ?? 0,
      status: json['status'] ?? '',
      fotoBarang: json['foto_barang'] ?? '',
      fotoBarang2: json['foto_barang2'] ?? '',
      idHunter: json['id_hunter'],
    );
  }
}