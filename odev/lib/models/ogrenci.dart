class Ogrenci {
  final int ogrenci_id;
  final String ad;
  final String soyad;
  final int bolum_id;

  Ogrenci({
    required this.ogrenci_id,
    required this.ad,
    required this.soyad,
    required this.bolum_id,
  });

  factory Ogrenci.fromJson(Map<String, dynamic> json) {
    return Ogrenci(
      ogrenci_id: json['ogrenci_id'],
      ad: json['ad'],
      soyad: json['soyad'],
      bolum_id: json['bolum_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ogrenci_id': ogrenci_id,
      'ad': ad,
      'soyad': soyad,
      'bolum_id': bolum_id,
    };
  }
}
