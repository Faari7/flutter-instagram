import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository _userRepository;

  SearchCubit({@required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchState.initial());

  void searchUsers({@required String query}) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final searchUsers = await _userRepository.searchUsers(query: query);
      emit(state.copyWith(users: searchUsers, status: SearchStatus.loaded));
    } catch (error) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
          failure:
              const Failure(message: 'Something went wrong! Please try again'),
        ),
      );
    }
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchStatus.initital));
  }
}
