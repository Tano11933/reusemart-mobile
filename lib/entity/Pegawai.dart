class Pegawai {
  final String idPegawai;
  final String namaPegawai;
  final String email;
  final String nomorTelepon;
  final String tglLahir;
  final String alamat;
  final String idJabatan;  // J3 atau J4 misalnya

  Pegawai({
    required this.idPegawai,
    required this.namaPegawai,
    required this.email,
    required this.nomorTelepon,
    required this.tglLahir,
    required this.alamat,
    required this.idJabatan,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      idPegawai: json['id_pegawai'] ?? '',
      namaPegawai: json['nama_pegawai'] ?? '',
      email: json['email'] ?? '',
      nomorTelepon: json['nomor_telepon'] ?? '',
      tglLahir: json['tgl_lahir'] ?? '',
      alamat: json['alamat'] ?? '',
      idJabatan: json['id_jabatan'] ?? '',
    );
  }
}
