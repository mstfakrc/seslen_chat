import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Mesaj baloncuğu (MessageBubble) sohbet ekranında tek bir mesajı gösterir.
class MessageBubble extends StatelessWidget {
  // Bu yapıcı ilk mesajı oluşturarak, mesaj baloncuğunun dizideki ilk mesaj olduğunu belirler.
  const MessageBubble.first({
    super.key,
    required this.userImage, // Kullanıcının profil resmi
    required this.username, // Kullanıcının adı
    required this.message, // Gönderilen mesaj içeriği
    required this.isMe, // Mesajı gönderen ben miyim?
  }) : isFirstInSequence = true;

  // Bu yapıcı devam eden mesaj dizileri için bir mesaj baloncuğu oluşturur.
  const MessageBubble.next({
    super.key,
    required this.message, // Mesaj içeriği
    required this.isMe, // Mesajı gönderen ben miyim?
  })  : isFirstInSequence = false,
        userImage = null, // Kullanıcı resmi gerekli değil
        username = null; // Kullanıcı adı gerekli değil

  // Aynı kullanıcıdan gelen ardışık mesajların ilki mi?
  // Mesaj baloncuğunun şekli ve görüntülenen öğeler bu duruma göre değişir.
  final bool isFirstInSequence;

  // Kullanıcının profil resmi, yalnızca ilk mesaj için gösterilir.
  final String? userImage;

  // Kullanıcının adı, yalnızca ilk mesaj için gösterilir.
  final String? username;

  // Mesaj içeriği
  final String message;

  // Mesaj baloncuğunun ekranda nasıl hizalanacağını kontrol eder.
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context); // Uygulamanın temasıyla renkleri uyumlu hale getirir

    return Stack(
      children: [
        // Eğer kullanıcının resmi varsa, resmi sağa veya sola hizalar
        if (userImage != null)
          Positioned(
            top: 15, // Resmi balonun üst kısmına hizalar
            right: isMe ? 0 : null, // Mesaj bana aitse sağa hizalar
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.onPrimary, // Sınır rengi
                  width: 2, // Sınır genişliği
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Gölgenin rengi
                    blurRadius: 6, // Bulanıklık
                    offset: Offset(2, 2), // Gölgenin konumu
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: userImage != null
                    ? NetworkImage(
                        userImage!) // Kullanıcının profil resmi URL'den yüklenir
                    : AssetImage('assets/images/chat.png'), // Yer tutucu resim
                backgroundColor: theme.colorScheme.primary
                    .withAlpha(180), // Hafif bir saydamlık efekti ekler
                radius: 25, // Resim boyutunu ayarlar
                child: userImage == null
                    ? Icon(
                        Icons
                            .person, // Kullanıcı resmi yoksa gösterilecek simge
                        color: Colors.white, // Simgenin rengi
                        size: 28, // Simgenin boyutu
                      )
                    : null, // Eğer kullanıcı resmi varsa simge göstermiyoruz
              ),
            ),
          ),
        Container(
          // Mesaj balonuna profil resmi için yeterli boşluk ekler
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            // Mesajın ekranda gösterileceği tarafı ayarlar (sağ/sol)
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // İlk mesajlar dizisinde görsel boşluk sağlar
                  if (isFirstInSequence) const SizedBox(height: 18),
                  // Kullanıcı adı varsa, gösterir
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13), // Yatay boşluğu simetrik yapar
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors
                              .grey[100], // Arka plana daha açık bir renk ekler
                          borderRadius:
                              BorderRadius.circular(12), // Kenarları yuvarlar
                          border: Border.all(
                            color: Colors
                                .grey[300]!, // İnce bir çerçeve rengi ekler
                            width: 1, // Çerçeve kalınlığı
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.1), // Gölge rengi
                              blurRadius: 6, // Bulanıklık
                              offset: Offset(2, 4), // Gölgenin konumu
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14), // İç boşluk
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Satır boyutunu minimumda tutar
                          children: [
                            Icon(Icons.person,
                                color:
                                    Colors.black54), // Kullanıcı simgesi ekler
                            const SizedBox(
                                width: 8), // İkon ile metin arasında boşluk
                            Text(
                              username!
                                  .toUpperCase(), // Kullanıcı adını büyük harflerle gösterir
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold, // Kalın font ile vurgular
                                color: Colors.black87, // Siyah renkte gösterir
                                fontSize: 16, // Yazı boyutunu ayarlar
                                letterSpacing:
                                    1.5, // Harfler arasındaki boşluğu artırır
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Mesajı çevreleyen konuşma baloncuğu (speech box)

// intl paketini import ediyoruz

                  Container(
                    decoration: BoxDecoration(
                      // Mesaj balonunun arka plan rengini ayarlar
                      color: isMe
                          ? Colors
                              .grey[300] // Mesaj bana aitse gri renk kullanır
                          : theme.colorScheme.secondary.withAlpha(
                              200), // Diğer kişiden ise temadan renk alır
                      // Mesajın konuşma baloncuğunun şeklini ayarlar
                      borderRadius: BorderRadius.only(
                        topLeft: !isMe && isFirstInSequence
                            ? Radius.zero
                            : const Radius.circular(12),
                        topRight: isMe && isFirstInSequence
                            ? Radius.zero
                            : const Radius.circular(12),
                        bottomLeft: const Radius.circular(
                            12), // Balonun alt kenarlarını yuvarlar
                        bottomRight: const Radius.circular(12),
                      ),
                      // Gölgeli bir etki ekler
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.1), // Gölgenin rengi
                          blurRadius: 5, // Bulanıklık
                          offset: Offset(2, 2), // Gölgenin konumu
                        ),
                      ],
                    ),
                    // Mesaj balonunun genişlik sınırlamalarını ayarlar
                    constraints: const BoxConstraints(
                        maxWidth: 250), // Balonun maksimum genişliği artırıldı
                    padding: const EdgeInsets.symmetric(
                      vertical: 12, // Dikey boşluk artırıldı
                      horizontal: 16, // Yatay boşluk artırıldı
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 6, // Dikey margin artırıldı
                      horizontal: 14, // Yatay margin artırıldı
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Metin sola yaslı
                      children: [
                        Text(
                          message, // Mesaj metni
                          style: TextStyle(
                            height: 1.4, // Satır aralığını ayarlar
                            color: isMe
                                ? Colors
                                    .black87 // Mesaj bana aitse siyah renkte gösterir
                                : theme.colorScheme
                                    .onSecondary, // Diğer kişiden ise temaya uygun renk kullanır
                            fontSize: 16, // Yazı boyutunu ayarlar
                            fontWeight:
                                FontWeight.w400, // Yazı kalınlığını ayarlar
                          ),
                          softWrap: true, // Uzun metinlerin kaymasını sağlar
                        ),
                        if (isMe) // Eğer mesaj bana aitse, zaman damgasını gösterir
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              DateFormat('HH:mm')
                                  .format(DateTime.now()), // Zaman damgası
                              style: TextStyle(
                                fontSize: 12, // Daha küçük bir yazı boyutu
                                color: Colors.grey[600], // Daha soluk bir renk
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
/*import 'package:flutter/material.dart';

// A MessageBubble for showing a single chat message on the ChatScreen.
class MessageBubble extends StatelessWidget {
  // Create a message bubble which is meant to be the first in the sequence.
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  // Create a amessage bubble that continues the sequence.
  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  // Whether or not this message bubble is the first in a sequence of messages
  // from the same user.
  // Modifies the message bubble slightly for these different cases - only
  // shows user image for the first message from the same user, and changes
  // the shape of the bubble for messages thereafter.
  final bool isFirstInSequence;

  // Image of the user to be displayed next to the bubble.
  // Not required if the message is not the first in a sequence.
  final String? userImage;

  // Username of the user.
  // Not required if the message is not the first in a sequence.
  final String? username;
  final String message;

  // Controls how the MessageBubble will be aligned.
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (userImage != null)
          Positioned(
            top: 15,
            // Align user image to the right, if the message is from me.
            right: isMe ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userImage!,
              ),
              backgroundColor: theme.colorScheme.primary.withAlpha(180),
              radius: 23,
            ),
          ),
        Container(
          // Add some margin to the edges of the messages, to allow space for the
          // user's image.
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            // The side of the chat screen the message should show at.
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // First messages in the sequence provide a visual buffer at
                  // the top.
                  if (isFirstInSequence) const SizedBox(height: 18),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Text(
                        username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                  // The "speech" box surrounding the message.
                  Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.grey[300]
                          : theme.colorScheme.secondary.withAlpha(200),
                      // Only show the message bubble's "speaking edge" if first in
                      // the chain.
                      // Whether the "speaking edge" is on the left or right depends
                      // on whether or not the message bubble is the current user.
                      borderRadius: BorderRadius.only(
                        topLeft: !isMe && isFirstInSequence
                            ? Radius.zero
                            : const Radius.circular(12),
                        topRight: isMe && isFirstInSequence
                            ? Radius.zero
                            : const Radius.circular(12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                    ),
                    // Set some reasonable constraints on the width of the
                    // message bubble so it can adjust to the amount of text
                    // it should show.
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    // Margin around the bubble.
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        // Add a little line spacing to make the text look nicer
                        // when multilined.
                        height: 1.3,
                        color: isMe
                            ? Colors.black87
                            : theme.colorScheme.onSecondary,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
*/