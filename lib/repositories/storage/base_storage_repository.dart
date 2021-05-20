import 'dart:io';

abstract class BaseStorageRepository {
  // can upload photo from camera and gallery
  Future<String> uploadProfileImage({String url, File image});
  // can upload photo from gallery
  Future<String> uploadPostImage({File image});
}
