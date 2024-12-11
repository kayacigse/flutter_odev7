import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:odev/models/ogrenci.dart';

class OgrenciService {
  final String baseUrl = 'http://localhost:5002'; // API URL'si

  // Öğrencilerin listesini al
  Future<List<Ogrenci>> fetchOgrenciler() async {
    final response = await http.get(Uri.parse('$baseUrl/ogrenci'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Ogrenci.fromJson(json)).toList();
    } else {
      throw Exception('Veri alınamadı');
    }
  }

  // Öğrenci ekle
  Future<void> addOgrenci(Ogrenci ogrenci) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ogrenci'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ogrenci.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Öğrenci eklenemedi');
    }
  }

  // Öğrenci güncelle
  Future<void> updateOgrenci(Ogrenci ogrenci) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ogrenci/${ogrenci.ogrenci_id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ogrenci.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Öğrenci güncellenemedi');
    }
  }

  // Öğrenci sil
  Future<void> deleteOgrenci(int ogrenciID) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/ogrenci/$ogrenciID'),
    );

    if (response.statusCode != 200) {
      throw Exception('Öğrenci silinemedi');
    }
  }
}
