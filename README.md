# Reproducible Pipeline: Sepsis Risk Prediction

Repositori ini berisi implementasi analisis data untuk memprediksi risiko sepsis menggunakan data Rekam Medis Elektronik (EHR). Tugas ini mendemonstrasikan prinsip reproduksibilitas pada data medis, mulai dari tahap pembersihan data hingga pemodelan klinis.

## Spesifikasi Lingkungan (Environment)
- **Bahasa Pemrograman**: R 
- **Library Utama**: `dplyr` untuk manipulasi data dan vektorisasi. Operasi I/O (membaca/menyimpan data) murni menggunakan fungsi bawaan Base R (`read.csv` dan `write.csv`).
- **Input Data**: `data_final_beneran.csv` (Data sampel kohort sepsis fiktif).
- **Output Data**: `ehr_sepsis_predictions_clean.csv`

## Data Dictionary
Dokumentasi ini menjelaskan metadata dari variabel mentah, fitur yang direkayasa (*engineered features*), serta hasil luaran model di dalam *pipeline* analisis.

### 1. Variabel Mentah & Penyelarasan Nama (Mapping)
| Kolom Asal | Nama Standar | Tipe Data | Deskripsi |
| :--- | :--- | :--- | :--- |
| `hr` | `heart_rate` | Numerik | Frekuensi detak jantung (BPM). Indikator takikardia. |
| `sbp` | `systolic_bp` | Numerik | Tekanan darah sistolik dalam satuan mmHg. |
| `temp` | `temperature` | Numerik | Suhu inti tubuh pasien dalam derajat Celcius (°C). |
| `sepsis` | `is_sepsis` | Biner | Target variabel (*ground truth*) diagnosis. 1 = Sepsis, 0 = Tidak. |

### 2. Rekayasa Fitur (Feature Engineering)
| Nama Fitur | Tipe Data | Deskripsi Klinis & Statistik |
| :--- | :--- | :--- |
| `sys_bp_norm` | Numerik | Hasil normalisasi Min-Max dari tekanan darah sistolik agar skala metrik lebih seragam di dalam algoritma pemodelan. |
| `fever_sirs_flag` | Biner | Ekstraksi indikator demam (1 = suhu > 38.0°C, 0 = suhu <= 38.0°C) berdasarkan kriteria awal peradangan sistemik (SIRS). |

### 3. Output Probabilitas Risiko (Model Luaran)
| Nama Output | Tipe Data | Deskripsi Klinis |
| :--- | :--- | :--- |
| `sepsis_prob` | Numerik | Probabilitas kontinu (0-1) yang dihasilkan oleh model Regresi Logistik (Binomial). |
| `high_risk_alert` | Biner | Bendera peringatan bahaya (1 = Risiko Tinggi, 0 = Aman). Menggunakan batas ambang (*threshold*) probabilitas 0.65. |
