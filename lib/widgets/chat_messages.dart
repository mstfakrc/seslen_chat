import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seslen/widgets/message_bubble.dart';

// Sohbet ekranında mesajları gösteren widget.
class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase'den mevcut oturum açan kullanıcıyı alıyoruz.
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    
    return StreamBuilder(
      // Firestore'dan 'chat' koleksiyonunu dinleriz ve mesajları 'createdAt' alanına göre sıralarız.
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt', // Mesajları oluşturulma zamanına göre sıralar.
            descending: true, // En yeni mesajlar en üstte olacak şekilde sıralar.
          )
          .snapshots(), // Veritabanından gerçek zamanlı veri alır.
          
      builder: (ctx, chatSnapshot) {
        // Veriler yüklenirken gösterilecek dairesel ilerleme göstergesi.
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(), // Yüklenme animasyonu.
          );
        }

        // Eğer veri yoksa veya boşsa, kullanıcıya mesaj bulunmadığını gösterir.
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Mesaj bulunamadı'), // Türkçeleştirilmiş mesaj.
          );
        }

        // Veritabanına erişimde bir hata meydana geldiyse hata mesajı gösterir.
        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Bir hata oluştu...'), // Türkçeleştirilmiş hata mesajı.
          );
        }

        // Mesajları yüklüyoruz ve liste olarak saklıyoruz.
        final loadedMessages = chatSnapshot.data!.docs;

        // Mesajları liste olarak ekranda göstermek için ListView kullanıyoruz.
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13), // Mesajların altına ve yanlarına boşluk ekler.
          reverse: true, // Mesajları ters çevirir, böylece en yeni mesajlar en üstte olur.
          itemCount: loadedMessages.length, // Mesajların sayısını alır.
          itemBuilder: (ctx, index) {
            // Her bir mesajı veritabanından çeker.
            final chatMessage = loadedMessages[index].data();

            // Bir sonraki mesajı kontrol eder, böylece mesajların aynı kişiden olup olmadığını belirleyebiliriz.
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId']; // Mevcut mesajın kullanıcı kimliğini alır.
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null; // Sonraki mesajın kullanıcı kimliğini alır.
                
            // Sonraki mesajın aynı kullanıcıdan gelip gelmediğini kontrol eder.
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            // Eğer bir sonraki mesaj aynı kullanıcıdan ise 'next' stili kullanarak mesajı göstereceğiz.
            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'], // Mesajın içeriğini alır.
                isMe: authenticatedUser.uid == currentMessageUserId, // Kullanıcı kimliği kontrolü yapar (mesaj benim mi?).
              );
            } 
            // Farklı kullanıcıdan gelen ilk mesaj için 'first' stili kullanarak mesajı göstereceğiz.
            else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'], // Mesajı gönderen kullanıcının profil resmini alır.
                username: chatMessage['username'], // Mesajı gönderen kullanıcının adını alır.
                message: chatMessage['text'], // Mesajın içeriğini alır.
                isMe: authenticatedUser.uid == currentMessageUserId, // Kullanıcı kimliği kontrolü yapar (mesaj benim mi?).
              );
            }
          },
        );
      },
    );
  }
}

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seslen/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No message found'),
          );
        }
        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('something went wrong ...'),
          );
        }

        final loadedMessages = chatSnapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
*/
