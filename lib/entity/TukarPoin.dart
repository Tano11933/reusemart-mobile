class TukarPoin {
  final String namaMerch;
  final String gambarMerch;
  final int jumlah;
  final String tglTukar;
  final String status;

  TukarPoin({
    required this.namaMerch,
    required this.gambarMerch,
    required this.jumlah,
    required this.tglTukar,
    required this.status,
  });

  factory TukarPoin.fromJson(Map<String, dynamic> json) {
    return TukarPoin(
      namaMerch: json['nama_merch'],
      gambarMerch: json['gambar_merch'] ?? '',
      jumlah: json['jml'],
      tglTukar: json['tgl_tukar'],
      status: json['status'],
    );
  }
}
