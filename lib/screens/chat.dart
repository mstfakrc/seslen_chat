import 'dart:ffi';
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
  Color _backgroundColor = Colors.blue.shade100; // Başlangıç arka plan rengi
  bool _isDarkMode = false; // Karanlık mod durumu

  // Renk paletini tanımlıyoruz
  final List<Map<String, dynamic>> _colors = [
    {'name': 'Mavi', 'color': Colors.blue.shade100},
    {'name': 'Yeşil', 'color': Colors.green.shade100},
    {'name': 'Kırmızı', 'color': Colors.red.shade100},
    {'name': 'Sarı', 'color': Colors.yellow.shade100},
    {'name': 'Turuncu', 'color': Colors.orange.shade100},
    {'name': 'Mor', 'color': Colors.purple.shade100},
    {'name': 'Pembe', 'color': Colors.pink.shade100},
    {'name': 'Gri', 'color': Colors.grey.shade300},
    {'name': 'Kahverengi', 'color': Colors.brown.shade100},
    {'name': 'Açık Mavi', 'color': Colors.lightBlue.shade100},
  ];

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
  }

  // Temayı değiştiren fonksiyon
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode; // Modu değiştir
      _backgroundColor = _isDarkMode
          ? Colors.grey[850]!
          : Colors.blue.shade100; // Arka plan rengi
    });
  }

  // Seçilen rengi uygulamak için kullanılan fonksiyon
  void _changeBackgroundColor(Color color) {
    setState(() {
      _backgroundColor = color; // Arka plan rengini değiştir
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // AppBar'ın yüksekliği
        elevation: 10, // AppBar'a gölge ekler
        backgroundColor:
            Colors.transparent, // AppBar arka plan rengini şeffaf yapar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // Arka plana gradyan efekti ekler
              colors: [
                Colors.deepPurpleAccent, // Gradyanın başlangıç rengi
                Colors.purpleAccent, // Gradyanın bitiş rengi
              ],
              begin: Alignment.topLeft, // Gradyanın başlangıç noktası
              end: Alignment.bottomRight, // Gradyanın bitiş noktası
            ),
            // borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)), // Alt köşeleri yuvarlama, yorum satırında
          ),
        ),
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Başlık ve logo hizalaması
          children: [
            Container(
              margin: const EdgeInsets.only(
                  right: 10), // Logo ile başlık arasında boşluk
              child: Image.asset(
                'assets/images/chat.png', // Logo dosya yolu
                height: 80, // Logo yüksekliği
              ),
            ),
            const Text(
              'Sohbetçik', // Uygulama başlığı
              style: TextStyle(
                fontSize: 26, // Başlık yazı boyutu
                fontWeight: FontWeight.bold, // Başlık kalın yazı
                color: Colors.white, // Başlık yazı rengi
                shadows: [
                  Shadow(
                    color: Colors.black54, // Başlık gölge rengi
                    offset: Offset(1, 1), // Gölgenin konumu
                    blurRadius: 3, // Gölgenin bulanıklığı
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Karanlık mod ve aydınlık mod ikonları
          IconButton(
            onPressed:
                _toggleTheme, // Temayı değiştirmek için çağrılan fonksiyon
            icon: Icon(
              _isDarkMode // Karanlık mod aktifse
                  ? Icons.wb_sunny // Aydınlık mod simgesi göster
                  : Icons.nightlight_round, // Karanlık mod simgesi göster
              color: Colors.white, // İkon rengi
            ),
          ),
          // Renk paleti açılır menüsü
          PopupMenuButton<Color>(
            icon: Icon(Icons.palette, color: Colors.white), // Renk paleti ikonu
            onSelected:
                _changeBackgroundColor, // Renk seçildiğinde bu fonksiyon çağrılır
            itemBuilder: (context) {
              return _colors.map((colorInfo) {
                // Renk listesinden öğeleri döner
                return PopupMenuItem<Color>(
                  value: colorInfo['color'], // Renk değeri
                  child: Row(
                    children: [
                      Container(
                        width: 20, // Renk kutusunun genişliği
                        height: 20, // Renk kutusunun yüksekliği
                        color: colorInfo['color'], // Renk kutusunun rengi
                        margin: EdgeInsets.only(
                            right: 8), // Renk kutusu ile yazı arasında boşluk
                      ),
                      Text(colorInfo['name']), // Renk ismi
                    ],
                  ),
                );
              }).toList(); // Renk öğelerini liste olarak döner
            },
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut(); // Kullanıcıyı oturumdan çıkarır
            },
            icon: Icon(
              Icons.exit_to_app, // Çıkış ikonu
              color: Colors.white, // İkon rengi
            ),
          ),
        ],
      ),
      body: Container(
        color: _backgroundColor, // Arka plan rengi
        child: Column(
          children: [
            Expanded(
              child: ChatMessages(), // Sohbet mesajlarını gösteren widget
            ),
            Padding(
              padding:
                  const EdgeInsets.all(8.0), // Yeni mesaj girişi için padding
              child: NewMessage(), // Yeni mesaj girişi widget'ı
            ),
          ],
        ),
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