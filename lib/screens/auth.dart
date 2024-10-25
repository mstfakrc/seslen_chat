import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore kütüphanesi
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage kütüphanesi
import 'package:flutter/material.dart'; // Flutter materyal kütüphanesi
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth kütüphanesi
import 'package:seslen/widgets/user_image_picker.dart'; // Kullanıcı resmi seçme bileşeni
import 'dart:io'; // Dosya işlemleri için gerekli

final _firebase = FirebaseAuth.instance; // Firebase Auth örneği

class AuthScreen extends StatefulWidget {
  // Giriş ve Kayıt ekranı
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState(); // Durum sınıfı oluşturuluyor
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>(); // Form için anahtar
  var _isLogin = true; // Giriş modu değişkeni
  var _enteredEmail = ''; // Girilen email adresi
  var _enteredPassword = ''; // Girilen şifre
  var _enteredUsername = ''; // Girilen kullanıcı adı
  File? _selectedImage; // Seçilen kullanıcı resmi
  var _isAuthenticating = false; // Kullanıcının kimlik doğrulama durumu

  // Giriş ve Kayıt işlemleri için submit fonksiyonu
  void _submit() async {
    final isValid =
        _form.currentState!.validate(); // Form geçerliliğini kontrol et
    if (!isValid || (!_isLogin && _selectedImage == null)) {
      // Geçerli değilse veya resim seçilmemişse çık
      return;
    }
    _form.currentState!.save(); // Form verilerini kaydet

    try {
      setState(() {
        _isAuthenticating = true; // Kimlik doğrulama sürecini başlat
      });

      if (_isLogin) {
        // Giriş yapma işlemi
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        // Yeni kullanıcı oluşturma
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        // Kullanıcı resmi Firebase Storage'a yükleniyor
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!); // Resmi yükle
        final imageUrl =
            await storageRef.getDownloadURL(); // Yüklenen resmin URL'sini al

        // Kullanıcı bilgileri Firestore'a kaydediliyor
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername, // Kullanıcı adı
          'email': _enteredEmail, // Email adresi
          'image_url': imageUrl, // Resim URL'si
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
          .clearSnackBars(); // Mevcut Snackbar'ları temizle
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              error.message ?? 'authentication failed'), // Hata mesajını göster
        ),
      );
      setState(() {
        _isAuthenticating = false; // Kimlik doğrulama sürecini sonlandır
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold ile ana ekran yapısı oluşturuluyor
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary, // Arka plan rengi
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // İçerik kadar boyutlanması için
                  children: [
                    Image.asset('assets/images/chat.png'), // Uygulamanın logosu
                    const SizedBox(
                        height: 10), // Logo ile metin arasında boşluk
                    Text(
                      'SESLEN', // Uygulamanın adı
                      style: TextStyle(
                        fontSize: 32, // Daha büyük yazı boyutu
                        fontWeight: FontWeight.bold, // Kalın yazı stili
                        color: Colors.white, // Yazı rengi beyaz
                        letterSpacing: 1.5, // Harfler arası boşluk
                        shadows: [
                          // Gölge efekti ekleniyor
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.7),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 8, // Gölgelendirme efekti
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Kenar yuvarlama
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24), // İç padding artırıldı
                    child: Form(
                      key: _form, // Form anahtarını tanımla
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin) // Kayıt formu için resim seçici
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage =
                                    pickedImage; // Seçilen resmi kaydet
                              },
                            ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  'Email Address', // Email etiketini gösterir
                              labelStyle: TextStyle(
                                color:
                                    Colors.deepPurpleAccent, // Etiketin rengi
                                fontWeight:
                                    FontWeight.bold, // Etiketin kalınlığı
                                fontSize: 16, // Etiketin yazı boyutu
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Kenar yuvarlama
                                borderSide: BorderSide(
                                  color: Colors
                                      .deepPurpleAccent, // Kenar çizgisinin rengi
                                  width: 2, // Kenar çizgisinin kalınlığı
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Odaklandığında yuvarlak kenarlar
                                borderSide: BorderSide(
                                  color: Colors
                                      .deepPurple, // Odaklanıldığında kenar rengi
                                  width: 2, // Odaklandığında kenar kalınlığı
                                ),
                              ),
                              filled: true, // Arka plan rengini doldur
                              fillColor:
                                  Colors.grey[100], // Arka plan renginin tonu
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12), // İçerik boşlukları
                              hintText:
                                  'example@domain.com', // Kullanıcıya örnek bir e-posta adresi gösterir
                              hintStyle: TextStyle(
                                color: Colors.grey, // Hint yazısının rengi
                                fontStyle:
                                    FontStyle.italic, // Hint yazısının stili
                              ),
                            ),
                            keyboardType: TextInputType
                                .emailAddress, // Klavye türü: E-posta girişi için uygun
                            autocorrect: false, // Otomatik düzeltmeyi kapat
                            textCapitalization: TextCapitalization
                                .none, // Büyük harf kullanımı yok
                            validator: (value) {
                              // Geçerlilik kontrolü
                              // Email adresinin geçerli olup olmadığını kontrol eder
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Lütfen email adresini düzgün girin'; // Hatalı email mesajı
                              }
                              return null; // Geçerli email durumu
                            },
                            onSaved: (value) {
                              _enteredEmail =
                                  value!; // Girilen e-posta adresini kaydet
                            },
                          ),

                          const SizedBox(height: 12), // Elemanlar arası boşluk
                          if (!_isLogin) // Kayıt formu için kullanıcı adı alanı

                            TextFormField(
                              decoration: InputDecoration(
                                labelText:
                                    'Username', // Kullanıcı adı etiketini gösterir
                                labelStyle: TextStyle(
                                  color:
                                      Colors.deepPurpleAccent, // Etiketin rengi
                                  fontWeight:
                                      FontWeight.bold, // Etiketin kalınlığı
                                  fontSize: 16, // Etiketin yazı boyutu
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Kenar yuvarlama
                                  borderSide: BorderSide(
                                    color: Colors
                                        .deepPurpleAccent, // Kenar çizgisinin rengi
                                    width: 2, // Kenar çizgisinin kalınlığı
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Odaklandığında yuvarlak kenarlar
                                  borderSide: BorderSide(
                                    color: Colors
                                        .deepPurple, // Odaklanıldığında kenar rengi
                                    width: 2, // Odaklandığında kenar kalınlığı
                                  ),
                                ),
                                filled: true, // Arka plan rengini doldur
                                fillColor:
                                    Colors.grey[100], // Arka plan renginin tonu
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12), // İçerik boşlukları
                                hintText:
                                    'Kullanıcı adınızı girin', // Kullanıcıya ne girmesi gerektiğini gösterir
                                hintStyle: TextStyle(
                                  color: Colors.grey, // Hint yazısının rengi
                                  fontStyle:
                                      FontStyle.italic, // Hint yazısının stili
                                ),
                              ),
                              enableSuggestions: false, // Öneri kapalı
                              validator: (value) {
                                // Geçerlilik kontrolü
                                // Kullanıcı adının en az 4 karakter uzunluğunda olup olmadığını kontrol eder
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Lütfen 4 harften uzun bir kullanıcı adı girin'; // Hatalı kullanıcı adı mesajı
                                }
                                return null; // Geçerli kullanıcı adı durumu
                              },
                              onSaved: (value) {
                                _enteredUsername =
                                    value!; // Girilen kullanıcı adını kaydet
                              },
                            ),

                          const SizedBox(height: 12), // Elemanlar arası boşluk
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password', // Şifre etiketini gösterir
                              labelStyle: TextStyle(
                                color:
                                    Colors.deepPurpleAccent, // Etiketin rengi
                                fontWeight:
                                    FontWeight.bold, // Etiketin kalınlığı
                                fontSize: 16, // Etiketin yazı boyutu
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Kenar yuvarlama
                                borderSide: BorderSide(
                                  color: Colors
                                      .deepPurpleAccent, // Kenar çizgisinin rengi
                                  width: 2, // Kenar çizgisinin kalınlığı
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Odaklandığında yuvarlak kenarlar
                                borderSide: BorderSide(
                                  color: Colors
                                      .deepPurple, // Odaklanıldığında kenar rengi
                                  width: 2, // Odaklandığında kenar kalınlığı
                                ),
                              ),
                              filled: true, // Arka plan rengini doldur
                              fillColor:
                                  Colors.grey[100], // Arka plan renginin tonu
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12), // İçerik boşlukları
                              hintText:
                                  'Şifrenizi girin', // Kullanıcıya ne girmesi gerektiğini gösterir
                              hintStyle: TextStyle(
                                color: Colors.grey, // Hint yazısının rengi
                                fontStyle:
                                    FontStyle.italic, // Hint yazısının stili
                              ),
                            ),
                            obscureText: true, // Şifre gizleme
                            validator: (value) {
                              // Geçerlilik kontrolü
                              // Şifrenin en az 6 karakter uzunluğunda olup olmadığını kontrol eder
                              if (value == null || value.trim().length < 6) {
                                return 'Şifreniz en az 6 karakterli olmalı'; // Hatalı şifre mesajı
                              }
                              return null; // Geçerli şifre durumu
                            },
                            onSaved: (value) {
                              _enteredPassword =
                                  value!; // Girilen şifreyi kaydet
                            },
                          ),

                          const SizedBox(
                              height: 20), // Daha fazla boşluk ekliyoruz
                          if (_isAuthenticating) // Kimlik doğrulama sürecinde dönen dairesel yükleme göstergesi
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating) // Kimlik doğrulama süreci bitince buton
                            ElevatedButton(
                              onPressed:
                                  _submit, // Butona tıklandığında _submit fonksiyonunu çağırır
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30, // Yatay boşluk
                                  vertical: 15, // Dikey boşluk
                                ),
                                backgroundColor: Colors
                                    .deepPurpleAccent, // Butonun varsayılan arka plan rengi
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Kenarları yuvarlar, daha modern bir görünüm sağlar
                                ),
                                elevation:
                                    5, // Butona hafif bir gölge ekler, derinlik hissi verir
                              ),
                              child: Text(
                                _isLogin
                                    ? 'Giriş Yap'
                                    : 'Kayıt Ol', // Butonun yazısını, login veya kayıt durumuna göre ayarlar
                                style: const TextStyle(
                                  fontSize:
                                      18, // Yazı boyutunu artırarak okunabilirliği artırır
                                  fontWeight: FontWeight
                                      .bold, // Yazıyı kalın yapar, dikkat çekici hale getirir
                                  color: Colors
                                      .white, // Yazı rengini beyaz yapar, arka planla kontrast oluşturur
                                ),
                              ),
                              onHover: (isHovered) {
                                // Buton üzerine gelindiğinde rengi değiştirmek için
                                final color = isHovered
                                    ? Colors.purple
                                    : Colors
                                        .deepPurpleAccent; // Hover durumuna göre renk değişimi
                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                      color, // Hover durumunda arka plan rengini değiştirir
                                );
                              },
                            ),

                          const SizedBox(height: 10), // Elemanlar arası boşluk
                          if (!_isAuthenticating) // Kimlik doğrulama süreci bitince başka bir buton
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin =
                                      !_isLogin; // Giriş/kayıt durumunu değiştirir
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12), // Dikey boşluk
                                backgroundColor: Colors
                                    .transparent, // Arka plan rengi şeffaf
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary, // Varsayılan yazı rengi
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Kenarları yuvarlar
                                ),
                                overlayColor: Colors.deepPurple.withOpacity(
                                    0.1), // Hover durumu için arka plan rengi
                              ),
                              child: Text(
                                _isLogin
                                    ? 'Hesabın yok mu? Kayıt ol!' // Kayıt olma mesajı
                                    : 'Zaten bir hesabın var mı? Giriş yap!', // Giriş yapma mesajı
                                style: TextStyle(
                                  fontSize: 16, // Yazı boyutunu ayarlar
                                  fontWeight: FontWeight
                                      .w500, // Yazının kalınlığını ayarlar
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary, // Tema rengine göre yazı rengi
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seslen/widgets/user_image_picker.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  File? _selectedImage;
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final UserCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'authentication failed'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Lütfen email adresini düzgün girin';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'username'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'lütfen mesajı 4 harften fazla girin';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Şifreniz en az 6 karakterli olmak zorunda';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (!_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: Text(_isLogin ? 'Giriş Yap' : 'Kayıt ol'),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Hesap Oluştur'
                                  : 'Zaten hesabım var'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
