import 'dart:io'; // Dosya işlemleri için gerekli paket.
import 'package:flutter/material.dart'; // Flutter'ın temel widget'ları için gerekli paket.
import 'package:image_picker/image_picker.dart'; // Cihazdan fotoğraf seçmek için kullanılan paket.

// Kullanıcı resmi seçme widget'ı (UserImagePicker)
class UserImagePicker extends StatefulWidget {
  // Yapıcı fonksiyon, onPickImage fonksiyonunu zorunlu kılar.
  const UserImagePicker({
    super.key,
    required this.onPickImage,
  });

  // Kullanıcının seçtiği resmi üst widget'a geri döndürmek için kullanılan fonksiyon.
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState(); // Widget'ın state'ini döndürür.
  }
}

// State sınıfı, resim seçme işlemini dinamik olarak yönetir.
class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile; // Seçilen resmin dosya verisini tutan değişken.

  // Cihazdan resim seçme işlemi.
  void _pickImage() async {
    // ImagePicker kullanarak kameradan fotoğraf çeker.
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera, // Kaynak olarak kamerayı kullanır.
      imageQuality: 50, // Fotoğrafın kalitesini belirler (50% kalite).
      maxWidth: 150, // Fotoğrafın maksimum genişliğini ayarlar.
    );

    // Eğer kullanıcı resim seçmediyse fonksiyonu bitirir.
    if (pickedImage == null) {
      return;
    }

    // Seçilen resmi _pickedImageFile değişkenine atar ve arayüzü günceller.
    setState(() {
      _pickedImageFile = File(pickedImage.path); // Dosya yolunu kullanarak File objesi oluşturur.
    });

    // Seçilen resmi, onPickImage fonksiyonu ile üst widget'a gönderir.
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Kullanıcı profil resmi göstermek için yuvarlak avatar widget'ı.
        CircleAvatar(
          radius: 40, // Çemberin yarıçapı.
          backgroundColor: Colors.grey, // Arka plan rengi gri.
          // Seçilen bir resim varsa onu gösterir, yoksa arka planı boş bırakır.
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        // Resim ekleme butonu (TextButton + İkon).
        TextButton.icon(
          onPressed: _pickImage, // Butona basıldığında _pickImage fonksiyonu çalışır.
          icon: const Icon(Icons.image), // Resim eklemek için kullanılan ikon (image ikonu).
          label: Text(
            'Resim Ekle', // Butonun yanında gösterilen yazı.
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary, // Butonun yazı rengi tema renginden alınır.
            ),
          ),
        )
      ],
    );
  }
}
/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);

     
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Resim Ekle',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        )
      ],
    );
  }
}
*/