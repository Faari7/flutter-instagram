import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

class StorageRepository extends BaseStorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String> _uploadImage(String ref, File image) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

    return downloadUrl;
  }

  @override
  Future<String> uploadProfileImage({String url, File image}) async {
    var imageId = Uuid().v4();

    /// update user profile image.
    if (url.isNotEmpty) {
      final exp = RegExp(r'userProfile_(*).jpg');
      imageId = exp.firstMatch(url)[0];
    }

    final downloadUrl = await _uploadImage(
      'images/users/userProfile_$imageId.jpg',
      image,
    );
    return downloadUrl;
  }

  @override
  Future<String> uploadPostImage({File image}) async {
    final imageId = Uuid().v4();
    final downloadUrl = await _uploadImage(
      'images/posts/post_$imageId.jpg',
      image,
    );
    return downloadUrl;
  }
}
