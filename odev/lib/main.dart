import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'forms/ogrenci_form.dart'; // Öğrenci formu
import 'services/ogrenci_service.dart'; // Öğrenci servisi
import 'models/ogrenci.dart'; // Öğrenci modelini import et

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Ogrenci> ogrenciler = []; // Öğrenci listesi
  bool isLoading = true; // Veriler yükleniyor durumu

  @override
  void initState() {
    super.initState();
    fetchOgrenciler(); // Öğrenci verilerini API'den çek
  }

  // Öğrenci verilerini API'den al
  Future<void> fetchOgrenciler() async {
    try {
      final List<Ogrenci> fetchedOgrenciler = await OgrenciService().fetchOgrenciler();
      setState(() {
        ogrenciler = fetchedOgrenciler; // Gelen veriyi listeye ata
        isLoading = false; // Yükleniyor durumu kapat
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Yükleniyor durumu kapat
      });
      // Hata durumunda uyarı göster
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veriler yüklenirken bir hata oluştu: $e'),
      ));
    }
  }

  void _openOgrenciForm([Ogrenci? ogrenci]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OgrenciForm(ogrenci: ogrenci),
      ),
    );
  }

  // Öğrenci silme fonksiyonu
  void _deleteOgrenci(int ogrenciID) {
    OgrenciService().deleteOgrenci(ogrenciID).then((_) {
      fetchOgrenciler(); // Listeyi güncelle
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Öğrenci silindi'),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Silme işlemi başarısız: $error'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci Listesi'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Yükleniyor göstergesi
          : ListView.builder(
        itemCount: ogrenciler.length,
        itemBuilder: (context, index) {
          final ogrenci = ogrenciler[index];
          return ListTile(
            title: Text('${ogrenci.ad} ${ogrenci.soyad}'),
            subtitle: Text('Bölüm ID: ${ogrenci.bolum_id}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteOgrenci(ogrenci.ogrenci_id), // Silme işlemi
            ),
            onTap: () => _openOgrenciForm(ogrenci), // Güncelleme ekranına gitmek için
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openOgrenciForm(), // Yeni öğrenci eklemek için
        child: const Icon(Icons.add),
      ),
    );
  }
}
