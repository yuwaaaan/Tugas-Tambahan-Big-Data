# Reproducible Pipeline: Sepsis Risk Prediction
Repositori ini berisi implementasi analisis data untuk memprediksi risiko sepsis menggunakan data Rekam Medis Elektronik (EHR). Tugas ini menerapkan prinsip reproduksibilitas pada high dimensional data medis.

## Spesifikasi Lingkungan (Environment)
- **Bahasa Pemrograman**: R (v4.3.0 atau lebih baru)
- **Library Utama**: `dplyr` untuk data manipulasi berbasis vektorisasi, `readr` untuk I/O operasi yang efisien.
- **Input Data Asal**: Data sampel kohort sepsis fiktif.

## Data Dictionary
Dokumentasi ini menjelaskan versi software dan input data beserta metadata dari variabel input yang digunakan di dalam pipeline analisis.

| Nama Variabel Bebas | Tipe Data | Satuan Klinis | Deskripsi |
| :--- | :--- | :--- | :--- |
| `heart_rate` | Numerik | Beats per Minute (BPM) | Frekuensi detak jantung pasien. Indikator takikardia. |
| `systolic_bp` | Numerik | Millimeters of Mercury (mmHg) | Tekanan darah sistolik. Dimodifikasi menjadi `sys_bp_norm`. |
| `temperature` | Numerik | Derajat Celcius (°C) | Suhu inti tubuh pasien. Diekstraksi menjadi fitur biner `fever_sirs_flag`. |
| `is_sepsis` | Biner | N/A | Target variabel (ground truth) diagnosis. 1 = Sepsis, 0 = Tidak. |

**Output Variabel:**
- `sepsis_prob`: Nilai probabilitas kontinu (0 hingga 1) luaran model regresi logistik.
- `high_risk_alert`: Peringatan biner (1/0) bagi klinisi (threshold probabilitas 0.65).
