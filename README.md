# Connected IoT

Aplikasi bahan ajar IoT berbasis Flutter. Proyek ini sedang dikembangkan; layar dan alur yang masih berupa placeholder ditandai di UI.

## Struktur kode

```text
lib/
├── main.dart
├── app/                  # konfigurasi aplikasi dan navigasi utama
├── core/theme/           # token warna dan tema aplikasi
├── features/             # layar dan komponen berdasarkan fitur
│   ├── home/
│   ├── materials/
│   ├── simulation/
│   ├── results/
│   └── profile/
└── shared/widgets/       # widget yang dipakai lintas fitur
```

## Menjalankan untuk pengujian web

Dari root proyek:

```powershell
flutter pub get
flutter run -d chrome
```

## Menjalankan analisis dan pengujian

```powershell
flutter analyze
flutter test
```

## Membuat APK Android

Jalankan dari root proyek pada komputer yang sudah menyiapkan Android SDK dan Flutter:

```powershell
flutter build apk --release
```

APK biasanya dibuat di `build/app/outputs/flutter-apk/app-release.apk`.

## Catatan

- `android/local.properties` bersifat lokal untuk setiap komputer dan tidak disertakan.
- Folder cache dan hasil build tidak disertakan; Flutter akan membuatnya kembali saat diperlukan.
- Desain Figma Make menjadi acuan visual. Logika pembelajaran, penyimpanan lokal, onboarding, dan aturan akses pertemuan masih akan dikembangkan secara bertahap sesuai PRD.
