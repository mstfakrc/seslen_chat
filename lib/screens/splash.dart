import 'package:flutter/material.dart';

// Uygulamanın yüklendiği anı göstermek için kullanılan SplashScreen widget'ı.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key}); // Stateless widget için gerekli olan anahtar parametre.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sohbetcik'), // Uygulamanın başlığı olarak 'Sohbetcik' kullanıldı.
        centerTitle: true, // Başlığı ortalar, daha dengeli bir görünüm sağlar.
        backgroundColor: Theme.of(context).colorScheme.primary, // AppBar rengini temaya uygun hale getirir.
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Metni ekranın ortasında hizalar.
          children: [
            CircularProgressIndicator(), // Yükleme esnasında dönen bir animasyon ekler.
            SizedBox(height: 20), // Yükleme animasyonu ile yazı arasında boşluk bırakır.
            Text(
              'Yükleniyor...', // Ekranda gösterilecek yüklenme mesajı.
              style: TextStyle(
                fontSize: 18, // Yazı boyutunu biraz daha büyük yapar.
                fontWeight: FontWeight.bold, // Yazıyı kalın yaparak daha dikkat çekici hale getirir.
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{

const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sohbetcik'),
      ),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}
*/