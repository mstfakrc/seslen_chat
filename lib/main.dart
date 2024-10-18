import 'package:flutter/material.dart'; // Flutter'ın temel widget'ları için gerekli paket.
import 'package:firebase_auth/firebase_auth.dart'; // Firebase kimlik doğrulama işlevleri için kullanılan paket.
import 'package:firebase_core/firebase_core.dart'; // Firebase'i başlatmak için kullanılan paket.
import 'package:seslen/screens/splash.dart'; // SplashScreen'i içeren dosyayı import eder.
import 'package:seslen/screens/chat.dart'; // ChatScreen'i içeren dosyayı import eder.
import 'firebase_options.dart'; // Firebase yapılandırma ayarlarını içeren dosyayı import eder.
import 'package:seslen/screens/auth.dart'; // AuthScreen'i içeren dosyayı import eder.

void main() async {
  // Uygulamayı başlatmadan önce Firebase'i başlatmak için Flutter'ın widget bağlama işlemlerini başlatır.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i platforma özel yapılandırmalarla başlatır.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase ayarlarını platforma göre kullanır.
  );

  runApp(const App()); // Uygulamanın ana widget'ını çalıştırır.
}

// Uygulamanın ana widget'ı olan 'App' sınıfı.
class App extends StatelessWidget {
  const App({super.key}); // Stateless widget için gerekli olan anahtar parametre.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seslen', // Uygulamanın başlık ismi.
      theme: ThemeData(
        useMaterial3: true, // Material Design 3 özelliklerini kullanır.
      ).copyWith(
        // Uygulamanın tema ayarlarını özelleştirir.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177), // Tema rengi olarak tohum renk kullanır.
        ),
      ),
      // Kullanıcının oturum açıp açmadığını kontrol eden StreamBuilder.
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), // Firebase'in oturum açma durumunu dinler.
        builder: (ctx, snapshot) {
          // Firebase oturum durumu değişimlerini yakalayıp ekrana yansıtır.

          // Eğer bağlantı bekleme durumundaysa SplashScreen'i gösterir.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // Oturum durumu yüklenirken Splash ekranı gösterilir.
          }

          // Eğer kullanıcı oturum açtıysa Chat ekranını gösterir.
          if (snapshot.hasData) {
            return const ChatScreen(); // Kullanıcı oturum açmışsa Chat ekranına yönlendirir.
          }

          // Kullanıcı oturum açmamışsa Giriş ekranını gösterir.
          return const AuthScreen(); // Oturum yoksa Giriş ekranına yönlendirir.
        },
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seslen/screens/splash.dart';
import 'package:seslen/screens/chat.dart';
import 'firebase_options.dart';
import 'package:seslen/screens/auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seslen',
      theme: ThemeData(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return const ChatScreen();
            }
            return const AuthScreen();
          }),
    );
  }
}
*/