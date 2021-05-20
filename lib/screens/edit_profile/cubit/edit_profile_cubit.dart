import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/failure_model.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/screens/profile/bloc/profile_bloc.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final ProfileBloc _profileBloc;

  EditProfileCubit({
    @required UserRepository userRepository,
    @required StorageRepository storageRepository,
    @required ProfileBloc profileBloc,
  })  : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _profileBloc = profileBloc,
        super(EditProfileState.initial()) {
    /// to show already input data
    final user = _profileBloc.state.user;
    emit(state.copyWith(username: user.username, bio: user.bio));
  }

  void profileImageChanged(File image) {
    emit(
        state.copyWith(profileImage: image, status: EditProfileStatus.initial));
  }

  void userNameChanged(String username) {
    emit(state.copyWith(username: username, status: EditProfileStatus.initial));
  }

  void bioChanged(String bio) {
    emit(state.copyWith(bio: bio, status: EditProfileStatus.initial));
  }

  void submit() async {
    /// we are updating the profile
    emit(state.copyWith(status: EditProfileStatus.submitting));

    try {
      final user = _profileBloc.state.user;
      var profileImageUrl = user.profileImageURL;

      /// if user upload new image then
      /// upload that image to storage
      /// grab the downloaded url and
      /// update user object profile url
      if (state.profileImage != null) {
        profileImageUrl = await _storageRepository.uploadProfileImage(
          url: profileImageUrl,
          image: state.profileImage,
        );
      }

      /// create new copy of user which contains
      /// updated object of user
      final updatedUser = user.copyWith(
        username: state.username,
        bio: state.bio,
        profileImageURL: profileImageUrl,
      );

      await _userRepository.updateUser(user: updatedUser);

      /// profile bloc should alway have latest copy of user object
      _profileBloc.add(ProfileLoadUser(userId: updatedUser.id));

      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
            status: EditProfileStatus.error,
            failure:
                const Failure(message: 'We were unable to update profile')),
      );
    }
  }
}
