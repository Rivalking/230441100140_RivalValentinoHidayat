import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../model/model.dart'; // file model Transaksi

class TransaksiService {
  static const String baseUrl = 'https://tes1-d6ae0-default-rtdb.firebaseio.com/transaksi';

  // Ambil semua transaksi (sekali ambil - Future)
  Future<List<Transaksi>> getTransaksi() async {
    final response = await http.get(Uri.parse('$baseUrl.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null) return [];

      return data.entries.map<Transaksi>((entry) {
        return Transaksi.fromJson(entry.value, entry.key);
      }).toList();
    } else {
      throw Exception('Gagal mengambil data transaksi');
    }
  }

  // Versi Stream: update otomatis setiap beberapa detik
  Stream<List<Transaksi>> getTransaksiStream() async* {
    while (true) {
      final data = await getTransaksi();
      yield data;
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  // Tambah transaksi
  Future<void> addTransaksi(Transaksi transaksi) async {
    await http.post(
      Uri.parse('$baseUrl.json'),
      body: json.encode(transaksi.toJson()),
    );
  }

  // Alias dari tambahTransaksi
  Future<void> tambahTransaksi(Transaksi transaksi) async {
    return addTransaksi(transaksi);
  }

  // Update transaksi
  Future<void> updateTransaksi(Transaksi transaksi) async {
    await http.patch(
      Uri.parse('$baseUrl/${transaksi.id}.json'),
      body: json.encode(transaksi.toJson()),
    );
  }

  // Put seluruh data transaksi
  Future<void> putTransaksi(Transaksi transaksi) async {
    await http.put(
      Uri.parse('$baseUrl/${transaksi.id}.json'),
      body: json.encode(transaksi.toJson()),
    );
  }

  // Hapus transaksi
  Future<void> deleteTransaksi(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id.json'));
  }

  // Hitung saldo (sekali hitung - Future)
  Future<int> getSaldo() async {
    final response = await http.get(Uri.parse('$baseUrl.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null) return 0;

      int saldo = 0;
      data.forEach((key, value) {
        final transaksi = Transaksi.fromJson(value, key);
        int jumlah = transaksi.jumlah;
        if (transaksi.jenis == 'Pemasukan') {
          saldo += jumlah;
        } else {
          saldo -= jumlah;
        }
      });
      return saldo;
    } else {
      throw Exception('Gagal menghitung saldo');
    }
  }

  // Versi Stream dari saldo (update otomatis)
  Stream<int> hitungSaldo() async* {
    while (true) {
      final saldo = await getSaldo();
      yield saldo;
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
