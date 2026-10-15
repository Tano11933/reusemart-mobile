class Pemesanan {
  final String idPemesanan;
  final String status;
  final int totalHarga;
  final String tanggalPesan;
  final List<DetailPemesanan> detail;

  Pemesanan({
    required this.idPemesanan,
    required this.status,
    required this.totalHarga,
    required this.tanggalPesan,
    required this.detail,    
  });

  factory Pemesanan.fromJson(Map<String, dynamic> json) {
    return Pemesanan(
      idPemesanan: json['id_pemesanan'] ?? '',
      status: json['status'] ?? '',
      totalHarga: json['total_harga_pesanan'] ?? 0,
      tanggalPesan: json['tgl_pesan'] ?? '',
      detail: (json['detail'] as List<dynamic>?)
          ?.map((d) => DetailPemesanan.fromJson(d))
          .toList() ?? [],       
    );
  }
}


class DetailPemesanan {
  final String idDetailPemesanan;
  final String namaBarang;
  final int harga;
  final String fotoBarang;
  final String kategori;
  final String deskripsi;
  final String statusGaransi;
  final String tanggalTitip;
  final String tanggalLaku; 

  DetailPemesanan({
    required this.idDetailPemesanan,
    required this.namaBarang,
    required this.harga,
    required this.fotoBarang,
    required this.kategori,
    required this.deskripsi,
    required this.statusGaransi,
    required this.tanggalTitip, 
    required this.tanggalLaku,
  });

  factory DetailPemesanan.fromJson(Map<String, dynamic> json) {
    return DetailPemesanan(
      idDetailPemesanan: json['id_detail_pemesanan'] ?? '',
      namaBarang: json['nama_barang'] ?? '',
      harga: json['harga'] ?? 0,
      fotoBarang: json['foto_barang'] ?? '',
      kategori: json['kategori'] ?? '-',
      deskripsi: json['deskripsi'] ?? '-',
      statusGaransi: json['status_garansi'] ?? 'Tidak Ada',
      tanggalTitip: json['tgl_titip'] ?? '',
      tanggalLaku: json['tgl_laku'] ?? '',
    );
  }
}