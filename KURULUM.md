# Tarif Defteri – APK alma (bilgisayara Flutter kurmadan)

1. github.com'da ücretsiz hesap açın, yeni bir depo (repository) oluşturun.
2. Bu zip'in içindeki dosyaları (codemagic.yaml, pubspec.yaml, lib klasörü) depoya yükleyin.
   (GitHub sayfasında "Add file > Upload files" ile sürükleyip bırakabilirsiniz.)
3. codemagic.io'ya GitHub hesabınızla giriş yapın, "Add application" deyip bu depoyu seçin.
   Proje türü olarak Flutter seçin, yapılandırma için codemagic.yaml kullanılacağını belirtin.
4. "Start new build" deyin, workflow olarak "Tarif Defteri APK" seçin.
5. Derleme bitince Artifacts bölümünden APK'yı indirin.
6. APK'yı Samsung telefona atıp açın. İlk seferde "bilinmeyen kaynaklardan yüklemeye izin ver" sorusuna onay verin.

Alternatif: Flutter'ı kendi bilgisayarınıza kurup `flutter create` ve `flutter run` ile de çalıştırabilirsiniz.
