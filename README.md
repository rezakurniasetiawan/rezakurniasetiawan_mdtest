Tentu, ini versi Markdown dari teks yang Anda berikan.

# FAN IT Mobile Developer Test (Flutter)

Project ini adalah implementasi tes teknikal **Mobile Developer** untuk FAN IT.
Aplikasi dikembangkan menggunakan **Flutter**, dengan **Firebase Authentication** dan **Cloud Firestore** sebagai backend.
State management menggunakan **Provider** dengan struktur folder berbasis **Clean Architecture** sederhana.

-----

## 🚀 Fitur Utama

1.  **Authentication**

      - Login dengan email & password
      - Register akun baru dengan email & password
      - Forgot Password (reset password via email)
      - Email Verification (kirim & cek status)

2.  **Home Page**

      - Menampilkan data user yang sedang login (nama, email, status verifikasi)
      - Menampilkan daftar user dari Firestore
      - Filter daftar user berdasarkan status verifikasi (Verified / Not Verified)
      - Pencarian user berdasarkan nama atau email

3.  **Extra**

      - Splash Screen → redirect otomatis ke Home jika sudah login, ke Login jika belum
      - Logout
      - Error handling dasar (FirebaseAuthException ditangani & ditampilkan via SnackBar)
      - Struktur kode rapi & clean, mudah untuk dikembangkan lebih lanjut

-----

## 📂 Struktur Folder

```
lib/
├─ core/             # Error, utils
├─ data/
│  ├─ models/        # Model Firestore
│  └─ repositories/  # Implementasi AuthRepository (Firebase)
├─ domain/
│  ├─ entities/      # Entity User
│  └─ repositories/  # Abstraksi AuthRepository
├─ presentation/
│  ├─ providers/     # State management (Provider/ChangeNotifier)
│  ├─ pages/         # UI pages (Login, Register, Forgot, Home, Splash)
│  └─ widgets/       # Widget kecil reusable
└─ main.dart         # Entry point + setup Firebase + Provider
```

-----

## 🛠️ Setup & Instalasi

### 1\. Clone Repository

```bash
git clone https://github.com/rezakurniasetiawan/rezakurniasetiawan_mdtest/tree/reza/dev
cd rezakurniasetiawan_mdtest
```

### 2\. Install Dependencies

```bash
flutter pub get
```

### 3\. Setup Firebase

1.  Buat project di [Firebase Console](https://console.firebase.google.com/).

2.  Tambahkan aplikasi Android & iOS.

3.  Download file konfigurasi:

      - `google-services.json` → taruh di `android/app/`
      - `GoogleService-Info.plist` → taruh di `ios/Runner/`

4.  Enable **Email/Password Authentication** di Firebase Console.

5.  Buat **Firestore Database** (gunakan mode test untuk development) dengan struktur berikut:

    ```
    users (collection)
     └─ <uid> (document)
          ├─ name: string
          ├─ email: string
          ├─ emailVerified: bool
          └─ createdAt: timestamp
    ```

### 4\. Jalankan Aplikasi

```bash
flutter run
```

-----

## 📱 Teknologi yang Digunakan

  - **Flutter (3.x)**
  - **Provider** (state management)
  - **Firebase Authentication** (Email/Password, Email Verification, Password Reset)
  - **Cloud Firestore** (User list & data)
  - **Dart** (Null Safety, Clean Code Principle)

-----

## 👤 Author

**Reza Kurnia Setiawan**
Mobile Developer | Flutter Enthusiast