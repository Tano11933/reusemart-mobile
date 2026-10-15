class Pembeli {
  final String idPembeli;
  final String namaPembeli;
  final String email;
  final String nomorTelepon;
  final String jenisKelamin;
  final String tglLahir;
  final String? idRole; // nullable
  int? poin;      // nullable

  Pembeli({
    required this.idPembeli,
    required this.namaPembeli,
    required this.email,
    required this.nomorTelepon,
    required this.jenisKelamin,
    required this.tglLahir,
    this.idRole,
    this.poin,
  });

  factory Pembeli.fromJson(Map<String, dynamic> json) {
    return Pembeli(
      idPembeli: json['id_pembeli'] ?? '',
      namaPembeli: json['nama_pembeli'] ?? '',
      email: json['email'] ?? '', 
      nomorTelepon: json['nomor_telepon'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      tglLahir: json['tgl_lahir'] ?? '',
      idRole: json['id_role']?.toString(), // bisa null
      poin: json['poin'] != null ? int.tryParse(json['poin'].toString()) : null,
    );
  }
}