# HR Admin

Bu proje, insan kaynakları yönetimi süreçlerini dijitalleştirmek ve kolaylaştırmak amacıyla geliştirilmiştir. HR Admin; çalışan bilgilerini yönetme, izin takibi, performans değerlendirmeleri ve daha birçok HR fonksiyonunu merkezi bir platformda sunar.

## Özellikler

- **Çalışan Yönetimi**: Çalışan ekleme, düzenleme ve silme işlemleri.
- **İzin Takibi**: Yıllık izin, hastalık izni ve diğer izinlerin kaydı ve yönetimi.
- **Departman Yönetimi**: Farklı departmanlar oluşturabilir ve çalışanları ilişkilendirebilirsiniz.
- **Performans Değerlendirmeleri**: Çalışan performansını izleme ve raporlama.
- **Raporlama**: Çeşitli HR metrikleri için rapor oluşturma imkanı.
- **Kullanıcı Dostu Arayüz**: Kolay kullanılabilir ve anlaşılır bir web arayüzü.

## Kurulum

1. Bu projeyi kendi bilgisayarınıza klonlayın:
   ```bash
   git clone https://github.com/Nalveiz/hr_admin.git
   ```
2. Gerekli bağımlılıkları yükleyin:
   ```bash
   # Örneğin Python için
   pip install -r requirements.txt
   # Veya Node.js için
   npm install
   ```
3. Veritabanı yapılandırmasını yapın (gerekirse).
4. Uygulamayı başlatın:
   ```bash
   # Backend için
   python manage.py runserver
   # Frontend için
   npm start
   ```

## Kullanım

Web arayüzü üzerinden giriş yaparak HR işlemlerinizi gerçekleştirebilirsiniz. Detaylı kullanım dökümantasyonu için `docs/` klasörüne göz atabilirsiniz.

## Katkı Sağlama

Katkı yapmak için lütfen bir "fork" oluşturun, değişikliklerinizi bir dalda yapın ve "pull request" gönderin.

## Lisans

Bu proje MIT lisansı ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakınız.

---

Herhangi bir sorunuz veya öneriniz varsa, [issue](https://github.com/Nalveiz/hr_admin/issues) açabilirsiniz.
