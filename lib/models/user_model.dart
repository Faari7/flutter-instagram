import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String profileImageURL;
  final String bio;
  final int followers;
  final int following;

  const User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.profileImageURL,
    @required this.bio,
    @required this.followers,
    @required this.following,
  });

  static const empty = User(
    id: '',
    username: '',
    email: '',
    profileImageURL: '',
    bio: '',
    followers: 0,
    following: 0,
  );

  @override
  List<Object> get props =>
      [id, username, email, profileImageURL, bio, followers, following];

  User copyWith({
    String id,
    String username,
    String email,
    String profileImageURL,
    String bio,
    int followers,
    int following,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageURL: profileImageURL ?? this.profileImageURL,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }

  // =============================   //
  //      Helping methods           //
  // ============================= //

  /// This method will conver current model
  /// into a map. The keys which we enter
  /// here will exactly map on the Firebase
  ///
  /// We are not adding id, because that's
  /// auto generated
  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'email': email,
      'profileImageUrl': profileImageURL,
      'bio': bio,
      'followers': followers,
      'following': following,
    };
  }

  /// This method is mapping firebase
  /// model to client side model
  /// and return a User model where it called

  factory User.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileImageURL: data['profileImageUrl'] ?? '',
      bio: data['bio'] ?? '',
      followers: (data['followers'] ?? 0).toInt(),
      following: (data['following'] ?? 0).toInt(),
    );
  }
}
