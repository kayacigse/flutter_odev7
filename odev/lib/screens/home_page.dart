import 'package:flutter/material.dart';
import 'ogrenci_service.dart';
import 'ogrenci.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Ogrenci>> ogrenciler;

  @override
  void initState() {
    super.initState();
    ogrenciler = OgrenciService().fetchOgrenciler();
  }

  // Öğrenci silme fonksiyonu
  void deleteOgrenci(int ogrenciID) {
    OgrenciService().deleteOgrenci(ogrenciID).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğrenci silindi')),
      );
      setState(() {
        ogrenciler = OgrenciService().fetchOgrenciler(); // Listeyi güncelle
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme işlemi başarısız: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci Listesi'),
      ),
      body: FutureBuilder<List<Ogrenci>>(
        future: ogrenciler,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Hiç öğrenci yok.'));
          }

          List<Ogrenci> ogrenciList = snapshot.data!;

          return ListView.builder(
            itemCount: ogrenciList.length,
            itemBuilder: (context, index) {
              Ogrenci ogrenci = ogrenciList[index];
              return ListTile(
                title: Text('${ogrenci.ad} ${ogrenci.soyad}'),
                subtitle: Text('Bölüm ID: ${ogrenci.bolum_id}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Silme işlemi
                    deleteOgrenci(ogrenci.ogrenci_id);
                  },
                ),
                onTap: () {
                  // Öğrenci güncelleme ekranına gitmek için
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OgrenciForm(ogrenci: ogrenci),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
