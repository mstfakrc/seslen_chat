import 'dart:ffi'; // Firebase'in gerekli olmadığı bir durum, kaldırılabilir.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore bağlantısı için gerekli paket.
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication için gerekli paket.
import 'package:flutter/material.dart'; // Flutter'ın temel widget'ları için paket.

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

  @override
  void dispose() {
    _messageController.dispose(); // Bellek sızıntısını önlemek için kontrolcü temizlenir.
    super.dispose();
  }

  // Mesaj gönderme fonksiyonu (Firebase Firestore ve Authentication ile bağlantı)
  void _submitMessage() async {
    final enteredMessage = _messageController.text; // Kullanıcının yazdığı mesaj alınır.

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
      child: Row(
        children: [
          Expanded(
            // Mesaj yazmak için metin kutusu
            child: TextField(
              controller: _messageController, // Mesaj giriş kontrolcüsü atanır.
              textCapitalization: TextCapitalization.sentences, // Cümle başında otomatik büyük harf yapar.
              autocorrect: true, // Yazım hatalarını düzeltir.
              enableSuggestions: true, // Kelime önerilerini açar.
              decoration: const InputDecoration(labelText: 'send a message...'), // Giriş kutusunun içindeki etiket (placeholder)
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary, // Gönder butonunun rengi, uygulama temasına uygun şekilde ayarlanır.
            icon: const Icon(
              Icons.send, // Gönderme ikonu (ok işareti)
            ),
            onPressed: _submitMessage, // Butona tıklandığında mesaj gönderme işlemi tetiklenir.
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