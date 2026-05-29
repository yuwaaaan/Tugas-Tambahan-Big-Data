setwd("C:/Users/yuwan vira/OneDrive/Dokumen/BIG DATA")
d <- read.csv("data_final_beneran.csv")
d <- d[complete.cases(d), ]

d$x1 <- d$hr
d$x2 <- d$sbp
d$x3 <- d$temp
d$y <- d$sepsis

d$x2_norm <- (d$x2 - min(d$x2)) / (max(d$x2) - min(d$x2))

d$f <- 0
for(i in 1:nrow(d)) {
  if(d$x3[i] > 38.0) {
    d$f[i] <- 1
  } else {
    d$f[i] <- 0
  }
}

mod <- glm(y ~ x1 + x2_norm + f, data = d, family = "binomial")
res <- predict(mod, type="response")

d$pred <- 0
for(i in 1:nrow(d)){
  if(res[i] > 0.65){
    d$pred[i] <- 1
  }
}
write.csv(d, "hasil.csv")


# PIPELINE ANALISIS PREDIKSI RISIKO SEPSIS BERDASARKAN DATA EHR

# Mengatur lokasi folder kerja
setwd("C:/Users/yuwan vira/OneDrive/Dokumen/BIG DATA")

# Memanggil library untuk manipulasi data yang efisien
library(dplyr)

# 1. IMPORT DATA
ehr_raw <- read.csv("data_final_beneran.csv")

# 2. PENYELARASAN NAMA VARIABEL & PEMBERSIHAN 
# Alasan Klinis/Statistik: Mengubah nama variabel mentah yang ambigu (hr, sbp, temp) menjadi nama taksonomi medis baku. Standardisasi nomenklatur ini penting dalam EHR untuk memastikan interoperabilitas dan mencegah salah interpretasi fitur saat audit.
ehr_clean <- ehr_raw %>% 
  rename(
    heart_rate = hr,
    systolic_bp = sbp,
    temperature = temp,
    is_sepsis = sepsis
  ) %>%
  # Alasan Medis: Menggunakan fungsi penghapusan baris kosong (listwise deletion). 
  # Mengimputasi (menebak/mengisi) parameter medis akut yang hilang berisiko besar mengaburkan profil hemodinamik pasien yang sesungguhnya dan memicu salah diagnosis.
  na.omit()

# 3. REKAYASA FITUR (FEATURE ENGINEERING)
ehr_processed <- ehr_clean %>%
  mutate(
    # Alasan Statistik: Normalisasi Min-Max pada tekanan darah sistolik agar skala variabel ini seragam. 
    # Hal ini mencegah distorsi bobot koefisien oleh satuan ukur yang besar dan mempercepat konvergensi algoritma regresi.
    sys_bp_norm = (systolic_bp - min(systolic_bp)) / (max(systolic_bp) - min(systolic_bp)),
    
    # Alasan Medis: Binarisasi suhu tubuh (cut-off > 38.0 C) didasarkan pada definisi klinis demam dalam kriteria SIRS (Systemic Inflammatory Response Syndrome). 
    # Demam merupakan tanda awal peradangan sistemik sebelum pasien jatuh ke syok septik.
    fever_sirs_flag = ifelse(temperature > 38.0, 1, 0)
  )

# 4. PEMODELAN KLINIS
# Alasan Statistik: Menggunakan regresi logistik (binomial) karena target variabel bersifat dikotomi (Sepsis: Ya/Tidak). Model ini menghasilkan interpretabilitas tinggi (berupa Odds Ratio) yang sangat krusial bagi klinisi.
sepsis_model <- glm(
  is_sepsis ~ heart_rate + sys_bp_norm + fever_sirs_flag, 
  data = ehr_processed, 
  family = binomial(link = "logit")
)

# 5. PREDIKSI & PENILAIAN RISIKO
# Alasan Medis: Threshold probabilitas ditingkatkan ke 0.65 (bukan 0.5 default) untuk meningkatkan spesifisitas.
# Alarm peringatan dini (early warning system) medis yang terlalu sensitif akan menyebabkan 'alarm fatigue' di ruang ICU.
ehr_final <- ehr_processed %>%
  mutate(
    sepsis_prob = predict(sepsis_model, type = "response"),
    high_risk_alert = ifelse(sepsis_prob > 0.65, 1, 0)
  )

# Menyimpan hasil akhir dengan nama yang lebih profesional
write.csv(ehr_final, "ehr_sepsis_predictions_clean.csv", row.names = FALSE)
