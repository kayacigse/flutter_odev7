import 'package:flutter/material.dart';
import 'package:odev/models/ogrenci.dart';
import 'package:odev/services/ogrenci_service.dart';

class OgrenciForm extends StatefulWidget {
  final Ogrenci? ogrenci; // Öğrenci verisi opsiyonel, güncelleme için

  const OgrenciForm({Key? key, this.ogrenci}) : super(key: key);

  @override
  State<OgrenciForm> createState() => _OgrenciFormState();
}

class _OgrenciFormState extends State<OgrenciForm> {
  final _formKey = GlobalKey<FormState>();
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final _bolumIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.ogrenci != null) {
      _adController.text = widget.ogrenci!.ad;
      _soyadController.text = widget.ogrenci!.soyad;
      _bolumIdController.text = widget.ogrenci!.bolum_id.toString();
    }
  }

  void _saveOgrenci() {
    final ogrenci = Ogrenci(
      ogrenci_id: widget.ogrenci?.ogrenci_id ?? 0,  // Güncelleme durumunda ID kullanılır
      ad: _adController.text,
      soyad: _soyadController.text,
      bolum_id: int.parse(_bolumIdController.text),
    );

    if (widget.ogrenci == null) {
      // Yeni öğrenci ekleme
      OgrenciService().addOgrenci(ogrenci).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Öğrenci eklenemedi: $error'),
        ));
      });
    } else {
      // Öğrenci güncelleme
      OgrenciService().updateOgrenci(ogrenci).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Öğrenci güncellenemedi: $error'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ogrenci == null ? 'Yeni Öğrenci' : 'Öğrenci Güncelle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _adController,
                decoration: const InputDecoration(labelText: 'Ad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ad gereklidir';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _soyadController,
                decoration: const InputDecoration(labelText: 'Soyad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Soyad gereklidir';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bolumIdController,
                decoration: const InputDecoration(labelText: 'Bölüm ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bölüm ID gereklidir';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveOgrenci();
                  }
                },
                child: Text(widget.ogrenci == null ? 'Ekle' : 'Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
