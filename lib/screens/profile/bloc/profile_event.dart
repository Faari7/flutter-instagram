part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

/// when we need to load user profile.
/// we then required id of that user.
class ProfileLoadUser extends ProfileEvent {
  final String userId;
  ProfileLoadUser({@required this.userId});
  @override
  List<Object> get props => [userId];
}
