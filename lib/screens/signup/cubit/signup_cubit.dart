import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/models/failure_model.dart';
import 'package:flutter_instagram/repositories/auth/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: SignupStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void singUpWithCredentials() async {
    /// in case form conditions failed
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;

    // form is in submitting state
    emit(state.copyWith(status: SignupStatus.submitting));

    try {
      /// creating new account
      await _authRepository.signUpWithEmailAndPassword(
          username: state.username,
          email: state.email,
          password: state.password);

      /// form submitted successfully
      emit(state.copyWith(status: SignupStatus.success));
    } on Failure catch (err) {
      print('singUpWithCredentials: ' + err.message);

      /// form submission failed
      emit(state.copyWith(failure: err, status: SignupStatus.error));
    }
  }
}
