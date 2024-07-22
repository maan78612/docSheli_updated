import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FStorageServices {
  Future<String> uploadSingleFile(
      {String bucketName = 'bucket', required File file, required String userId}) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("$bucketName/$userId/${DateTime.now().toString()}");
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot res = await uploadTask;
    String imageUrl = await res.ref.getDownloadURL();
    print("\n\nuploaded = $imageUrl\n\n");
    return imageUrl;
  }
}
