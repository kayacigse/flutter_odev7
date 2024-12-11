require('dotenv').config();
const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 5002;

// Veritabanı bağlantısı
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
  });
  

db.connect((err) => {
  if (err) {
    console.error('Veritabanına bağlanılamadı: ' + err.stack);
    return;
  }
  console.log('Veritabanına bağlanıldı.');
});

app.use(cors());
app.use(bodyParser.json());

// Öğrenci listesi
app.get('/ogrenci', (req, res) => {
  db.query('SELECT * FROM ogrenci', (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Veri alınamadı' });
    }
    res.json(results);
  });
});

// Öğrenci ekle
app.post('/ogrenci', (req, res) => {
  const { ad, soyad, bolum_id } = req.body;
  db.query(
    'INSERT INTO ogrenci (ad, soyad, bolum_id) VALUES (?, ?, ?)',
    [ad, soyad, bolum_id],
    (err, results) => {
      if (err) {
        return res.status(500).json({ message: 'Öğrenci eklenemedi' });
      }
      res.status(201).json({ message: 'Öğrenci eklendi' });
    }
  );
});

// Öğrenci güncelle
app.put('/ogrenci/:id', (req, res) => {
  const ogrenciID = req.params.id;
  const { ad, soyad, bolum_id } = req.body;
  db.query(
    'UPDATE ogrenci SET ad = ?, soyad = ?, bolum_id = ? WHERE ogrenci_id = ?',
    [ad, soyad, bolum_id, ogrenciID],
    (err, results) => {
      if (err) {
        return res.status(500).json({ message: 'Öğrenci güncellenemedi' });
      }
      if (results.affectedRows === 0) {
        return res.status(404).json({ message: 'Öğrenci bulunamadı' });
      }
      res.json({ message: 'Öğrenci güncellendi' });
    }
  );
});

// Öğrenci sil
app.delete('/ogrenci/:id', (req, res) => {
  const ogrenciID = req.params.id;
  db.query(
    'DELETE FROM ogrenci WHERE ogrenci_id = ?',
    [ogrenciID],
    (err, results) => {
      if (err) {
        return res.status(500).json({ message: 'Öğrenci silinemedi' });
      }
      if (results.affectedRows === 0) {
        return res.status(404).json({ message: 'Öğrenci bulunamadı' });
      }
      res.json({ message: 'Öğrenci silindi' });
    }
  );
});

// Server başlatma
app.listen(port, () => {
  console.log(`Sunucu http://localhost:${port} adresinde çalışıyor`);
});
