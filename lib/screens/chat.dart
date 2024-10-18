import 'dart:ffi'; // Native FFI (Foreign Function Interface) kullanımı için gereken paket.

import 'package:firebase_auth/firebase_auth.dart'; // Firebase kimlik doğrulama fonksiyonları için kullanılan paket.
import 'package:firebase_core/firebase_core.dart'; // Firebase başlatma işlemleri için kullanılan paket.
import 'package:firebase_messaging/firebase_messaging.dart'; // Firebase Push bildirimlerini yönetmek için kullanılan paket.
import 'package:flutter/material.dart'; // Flutter widget'ları ve UI bileşenleri için gereken paket.
import 'package:seslen/widgets/chat_messages.dart'; // Sohbet mesajlarını görüntüleyen widget'ı içeren dosya.
import 'package:seslen/widgets/new_message.dart'; // Yeni mesaj giriş alanını içeren widget'ı içeren dosya.

// Chat ekranını temsil eden ana widget.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key}); // Stateful widget için gerekli olan anahtar parametre.

  @override
  State<ChatScreen> createState() => _ChatScreenState(); // State sınıfını oluşturur.
}

// Chat ekranının durumunu yöneten sınıf.
class _ChatScreenState extends State<ChatScreen> {

  // Push bildirimlerini yapılandıran fonksiyon.
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance; // Firebase Mesajlaşma örneğini oluşturur.

    await fcm.requestPermission(); // Kullanıcıdan bildirim izni talep eder.
    
    // Bildirim token'ını almak için kullanılabilecek bir seçenek.
    //final token = await fcm.getToken();
    //print(token);

    // Kullanıcıyı 'chat' adlı konuya abone yapar, böylece bu konudan bildirim alır.
    fcm.subscribeToTopic('chat');
  }

  // Widget ilk oluşturulduğunda çağrılan fonksiyon.
  @override
  void initState() {
    super.initState();
    setupPushNotifications(); // Bildirim ayarlarını ilk başta yapar.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seslen'), // Uygulama başlığını "Seslen" olarak ayarlar.
        actions: [
          // Sağ üst köşeye çıkış simgesi ekler.
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut(); // Kullanıcıyı oturumdan çıkarır.
            },
            icon: Icon(
              Icons.exit_to_app, // Çıkış ikonu.
              color: Theme.of(context).colorScheme.primary, // Tema rengine göre ikon rengini ayarlar.
            ),
          )
        ],
      ),
      body: Column(
        children: const [
          // Sohbet mesajlarını gösteren genişleyen widget.
          Expanded(
            child: ChatMessages(), // ChatMessages widget'ı ile sohbet mesajlarını gösterir.
          ),
          // Yeni mesaj giriş alanını gösteren widget.
          NewMessage(), // NewMessage widget'ı ile mesaj girişi sağlar.
        ],
      ),
    );
  }
}

/*import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seslen/widgets/chat_messages.dart';
import 'package:seslen/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    //final token = await fcm.getToken();
    //print(token);
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seslen'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
*/