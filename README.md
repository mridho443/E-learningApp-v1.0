# 📘 E-Learning Application

Aplikasi pembelajaran daring berbasis web dan mobile dengan fitur:
- **Admin**: Kelola Materi, Ujian, dan Soal.
- **Siswa**: Ikuti Ujian, Lihat Materi, dan Cek Nilai.

---

## **📂 Backend (Laravel)**

### **🔧 Instalasi**
1. **Clone Repository**
   ```bash
   git clone
   cd backend/
   ```
2. **Install Dependensi**
   ```bash
   composer install
   ```
3. **Setup `.env`**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` untuk konfigurasi database:
   ```dotenv
   DB_DATABASE=your_db
   DB_USERNAME=your_user
   DB_PASSWORD=your_pass
   ```
4. **Generate Key & Migrasi Database**
   ```bash
   php artisan key:generate
   php artisan migrate --seed
   ```
5. **Jalankan Server**
   ```bash
   php artisan serve
   ```

---

## **🌐 Endpoint API**
| **Endpoint**        | **Method** | **Body**                        | **Deskripsi**              |
|----------------------|------------|----------------------------------|----------------------------|
| `/api/login`         | POST       | `{email, password}`             | Login Pengguna             |
| `/api/register`      | POST       | `{name, email, password}`       | Register Pengguna          |
| `/api/materials`     | GET        | -                                | Daftar Materi              |
| `/api/exams`         | GET        | -                                | Daftar Ujian               |
| `/api/exams/{id}`    | GET        | -                                | Detail Ujian Berdasarkan ID|
| `/api/grades/{id}`   | GET        | -                                | Nilai Ujian Siswa          |
| `/api/exams/{id}/questions` | GET | - | Daftar Soal Ujian Berdasarkan ID |
| `/api/exams/{id}/submit` | POST | `{user_id, answers}` | Kirim Jawaban Ujian |

---

## **📱 Frontend (Flutter)**

### **🔧 Instalasi**
1. **Clone Repository**
   ```bash
   git clone https://github.com/username/repo.git
   cd repo/frontend
   ```
2. **Install Dependensi**
   ```bash
   flutter pub get
   ```
3. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

### **📦 Build APK**
Untuk membangun file APK:
```bash
flutter build apk --release
```
APK akan tersedia di:
`build/app/outputs/flutter-apk/app-release.apk`

---

## **❓ FAQ**
### Apa saja fitur yang tersedia?
- Admin: Kelola Materi, Ujian, dan Soal.
- Siswa: Akses Materi, Ikuti Ujian, dan Lihat Nilai.

### Bagaimana jika terjadi masalah saat instalasi?
- Pastikan semua dependensi Laravel dan Flutter terinstal.
- Gunakan versi terbaru PHP, Composer, dan Flutter SDK.

