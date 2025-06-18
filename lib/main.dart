import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '/model/model.dart';
import 'service/service.dart';
import 'screen/tambah_data_screen.dart';
import 'screen/detail_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 👈 gunakan ini
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => TransaksiService()),
      ],
      child: MaterialApp(
        title: 'Catatan Keuangan',
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
        home: const HomeScreen(),
        routes: {
          '/tambah': (context) => const TambahDataScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transaksiService = Provider.of<TransaksiService>(context);

    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF1A1444),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.greenAccent),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/tambah');
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<int>(
                stream: transaksiService.hitungSaldo(),
                builder: (context, snapshot) {
                  final saldo = snapshot.data ?? 0;
                  return Text(
                    'Saldo : ${NumberFormat('#,###').format(saldo)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<Transaksi>>(
                  stream: transaksiService.getTransaksiStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Belum ada transaksi'));
                    }

                    final transaksi = snapshot.data!;

                    return ListView.builder(
                      itemCount: transaksi.length,
                      itemBuilder: (context, index) {
                        final item = transaksi[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4DB6AC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/uang.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item.judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "${item.jenis}\nTanggal : ${item.tanggal}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Text(
                              'Rp. ${NumberFormat('#,###').format(item.jumlah)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(transaksi: item),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tanji
// 230441100045
// Pember 4A
// Mas tAMAM
