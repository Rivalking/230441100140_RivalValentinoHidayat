class Transaksi {
  final String? id;
  final String judul;
  final String jenis; // 'Pemasukan' atau 'Pengeluaran'
  final String tanggal;
  final int jumlah;
  final String? deskripsi;
  final String? foto; // ✅ Tambahkan ini

  Transaksi({
    this.id,
    required this.judul,
    required this.jenis,
    required this.tanggal,
    required this.jumlah,
    this.deskripsi,
    this.foto, // ✅ Tambahkan ini
  });

  factory Transaksi.fromJson(Map<String, dynamic> json, String id) {
    return Transaksi(
      id: id,
      judul: json['judul'],
      jenis: json['jenis'],
      tanggal: json['tanggal'],
      jumlah: json['jumlah'],
      deskripsi: json['deskripsi'],
      foto: json['foto'], // ✅ Ambil dari json juga
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'jenis': jenis,
      'tanggal': tanggal,
      'jumlah': jumlah,
      'deskripsi': deskripsi,
      'foto': foto, // ✅ Masukkan ke Firebase
    };
  }
}
