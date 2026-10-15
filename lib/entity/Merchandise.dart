class Merchandise {
  final String idMerch;
  final String namaMerch;
  final int stok;
  final int harga;
  final String? gambarMerch;

  Merchandise({
    required this.idMerch,
    required this.namaMerch,
    required this.stok,
    required this.harga,
    required this.gambarMerch,
  });

  factory Merchandise.fromJson(Map<String, dynamic> json) {
    return Merchandise(
      idMerch: json['id_merch']?.toString() ?? '',
      namaMerch: json['nama_merch'] ?? '',
      stok: json['stok'],
      harga: json['harga_poin'],
      gambarMerch: json['gambar_merch'] ?? '',
    );
  }

  static Merchandise? tryFromDynamic(dynamic json) {
    try {
      if (json is Map<String, dynamic>) {
        return Merchandise.fromJson(json);
      }
    } catch (_) {}
    return null;
  }
  
}
