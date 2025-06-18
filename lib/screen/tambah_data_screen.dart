import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../model/model.dart';
import '../service/service.dart';

class TambahDataScreen extends StatefulWidget {
  const TambahDataScreen({super.key});

  @override
  State<TambahDataScreen> createState() => _TambahDataScreenState();
}

class _TambahDataScreenState extends State<TambahDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String _jenis = 'Pengeluaran';
  DateTime _tanggal = DateTime.now();

  File? _imageFile;
  Uint8List? _webImageBytes;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _webImageBytes = result.files.single.bytes!;
          _imageFile = null;
        });
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImageBytes = null;
        });
      }
    }
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggal = picked;
      });
    }
  }

  Future<void> _simpanData() async {
    try {
      String? base64Image;
      if (_webImageBytes != null) {
        base64Image = base64Encode(_webImageBytes!);
      } else if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      final transaksi = Transaksi(
        id: '',
        judul: _judulController.text,
        jenis: _jenis,
        tanggal: _tanggal.toIso8601String(),
        jumlah: int.parse(_jumlahController.text),
        deskripsi: _deskripsiController.text,
        foto: base64Image ?? '',
      );

      final service = TransaksiService();
      await service.addTransaksi(transaksi);
    } catch (e) {
      debugPrint('Gagal menyimpan: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(12));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple, width: 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        _webImageBytes != null
                            ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
                            : _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : Image.asset("assets/uang.jpg", fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Title :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  hintText: 'Beli Buku',
                  filled: true,
                  fillColor: const Color(0xFF3FA69B),
                  border: border,
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Judul tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Jenis :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _jenis,
                items:
                    ['Pemasukan', 'Pengeluaran']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) => setState(() => _jenis = value!),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF3FA69B),
                  border: border,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Tanggal :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => _pilihTanggal(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF3FA69B),
                    border: border,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd MMM yyyy').format(_tanggal)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Jumlah :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 40000',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: const Color(0xFF3FA69B),
                  border: border,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Jumlah tidak boleh kosong';
                  if (int.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Deskripsi :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Beli buku di gramedia',
                  filled: true,
                  fillColor: const Color(0xFF3FA69B),
                  border: border,
                ),
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _simpanData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data berhasil disimpan')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
