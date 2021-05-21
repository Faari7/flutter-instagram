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

class ProfileToggleGridView extends ProfileEvent {
  final bool isGridView;

  ProfileToggleGridView({@required this.isGridView});
  @override
  List<Object> get props => [isGridView];
}

class ProfileUpdatePost extends ProfileEvent {
  final List<Post> posts;

  ProfileUpdatePost({@required this.posts});
  @override
  List<Object> get props => [posts];
}
