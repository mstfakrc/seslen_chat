import 'dart:ffi'; // Firebase'in gerekli olmadığı bir durum, kaldırılabilir.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore bağlantısı için gerekli paket.
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication için gerekli paket.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Flutter'ın temel widget'ları için paket.

// Yeni mesajın yazılacağı widget (NewMessage)
class NewMessage extends StatefulWidget {
  const NewMessage({super.key}); // Yapıcı fonksiyon, key ile widget tanımlanır.

  @override
  State<StatefulWidget> createState() {
    return _NewMessageState(); // Widget'ın state'ini döndürür.
  }
}

// State sınıfı, dinamik mesaj gönderme işlemi için.
class _NewMessageState extends State<NewMessage> {
  // Mesaj metin kontrolcüsü, kullanıcının yazdığı mesajı takip eder.
  final _messageController = TextEditingController();

  bool _isPressed = false; // Buton basılı mı kontrolü için
  @override
  void dispose() {
    _messageController
        .dispose(); // Bellek sızıntısını önlemek için kontrolcü temizlenir.
    super.dispose();
  }

  // Mesaj gönderme fonksiyonu (Firebase Firestore ve Authentication ile bağlantı)
  void _submitMessage() async {
    final enteredMessage =
        _messageController.text; // Kullanıcının yazdığı mesaj alınır.

    // Mesaj boşsa veya yalnızca boşluk karakterlerinden oluşuyorsa işlemi durdurur.
    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus(); // Klavyeyi kapatır.
    _messageController.clear(); // Mesaj kutusunu temizler.

    // Firebase Authentication ile şu anki kullanıcıyı alır.
    final user = FirebaseAuth.instance.currentUser!;

    // Firestore'dan kullanıcı bilgilerini alır.
    final userData = await FirebaseFirestore.instance
        .collection('users') // 'users' koleksiyonundan
        .doc(user.uid) // Belirtilen kullanıcının verilerini alır.
        .get(); // Veriyi getirir.

    // Firestore'da 'chat' koleksiyonuna mesajı ekler.
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage, // Mesaj içeriği
      'createdAt': Timestamp.now(), // Mesajın gönderilme zamanı
      'userId': user.uid, // Mesajı gönderen kullanıcının ID'si
      'username': userData.data()!['username'], // Kullanıcı adı
      'userImage': userData.data()!['image_url'], // Kullanıcının profil resmi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Mesaj kutusunun etrafına boşluk ekler (sol, sağ ve alt taraf).
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: // Buton basılı mı kontrolü için

          Row(
        children: [
          Expanded(
            // Mesaj yazmak için şık bir metin kutusu
            child: TextField(
              controller: _messageController, // Mesaj giriş kontrolcüsü
              textCapitalization: TextCapitalization
                  .sentences, // Cümle başlarını otomatik büyük yapar
              autocorrect: true, // Yazım hatalarını düzeltir
              enableSuggestions: true, // Kelime önerilerini etkinleştirir
              decoration: InputDecoration(
                filled:
                    true, // Arka planı doldurur, daha modern bir görünüm sağlar
                fillColor: Colors.grey[200], // Hafif gri arka plan rengi
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15), // İçerik etrafında boşluklar
                labelText:
                    'Send a message...', // Kullanıcıya mesaj girmesi için ipucu sağlar
                labelStyle: TextStyle(
                  color: Colors.grey[
                      600], // Yazının daha şık ve pastel renkte görünmesini sağlar
                  fontStyle: FontStyle
                      .italic, // Etiket yazısına italik stil kazandırır
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Köşeleri yuvarlatılmış sınır
                  borderSide: BorderSide
                      .none, // Kenarlık olmadan, sade bir görünüm sağlar
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      30), // Fokus olduğunda da köşeler yuvarlatılmış kalır
                  borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Fokus olduğunda ana temanın birincil rengine döner
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
              width:
                  10), // Gönder butonu ile metin kutusu arasında boşluk bırakır
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                _isPressed =
                    true; // Butona basıldığında animasyonu tetikleyelim
              });
            },
            onTapUp: (_) {
              setState(() {
                _isPressed = false; // Bırakıldığında eski haline döner
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100), // Animasyon süresi
              height: _isPressed ? 40 : 45, // Basıldığında buton boyutu küçülür
              width: _isPressed ? 40 : 45, // Basıldığında genişlik küçülür
              decoration: BoxDecoration(
                color: _messageController.text.isEmpty
                    ? Colors.grey // Mesaj kutusu boşsa buton gri olur
                    : Theme.of(context)
                        .colorScheme
                        .primary, // Mesaj yazıldığında buton ana renk olur
                shape: BoxShape.circle, // Buton yuvarlak olur
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Hafif gölge eklenir
                    blurRadius: 10, // Gölge yayılma etkisi
                    offset: Offset(0, 4), // Gölgenin dikey konumlandırılması
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send, // Gönderme ikonu
                  color: Colors.white, // İkon rengi beyaz yapılır
                ),
                onPressed: _messageController.text.isEmpty
                    ? null // Mesaj boşsa buton pasif olur
                    : () {
                        HapticFeedback.lightImpact(); // Hafif titreşim eklenir
                        _submitMessage(); // Mesaj gönderme işlevi tetiklenir
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

   
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}
*/