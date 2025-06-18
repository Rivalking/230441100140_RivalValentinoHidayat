import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/model.dart';

class DetailScreen extends StatelessWidget {
  final Transaksi transaksi;

  const DetailScreen({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###', 'id_ID');
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Back button and Title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Detail',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              const SizedBox(height: 10),

              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/uang.jpg', // Ganti sesuai path kamu
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // Informasi
              buildLabelValue("Title :", transaksi.judul),
              buildLabelValue("Jenis :", transaksi.jenis),
              buildLabelValue("Tanggal :", transaksi.tanggal),
              buildLabelValue(
                "Jumlah :",
                'Rp ${currencyFormat.format(transaksi.jumlah)}',
              ),
              buildLabelValue(
                "Deskripsi :",
                transaksi.deskripsi ?? "-",
                isMultiline: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabelValue(String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF5D9BA3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
              maxLines: isMultiline ? null : 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
