import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/blocs/auth/auth_bloc.dart';
import 'package:flutter_instagram/models/failure_model.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/repositories/post/post_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  FeedBloc({
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(FeedState.initial());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is FeedFetchPosts) {
      yield* _mapFeedFetchPostsToState();
    } else if (event is FeedPaginatePosts) {
      yield* _mapFeedPaginatePostsToState();
    }
  }

  Stream<FeedState> _mapFeedFetchPostsToState() async* {
    yield state.copyWith(status: FeedStatus.loading);
    try {
      final posts =
          await _postRepository.getUserFeed(userId: _authBloc.state.user.uid);
      yield state.copyWith(posts: posts, status: FeedStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: FeedStatus.error,
        failure:
            const Failure(message: 'Unable to fetch posts. Please try again'),
      );
    }
  }

  Stream<FeedState> _mapFeedPaginatePostsToState() async* {
    yield state.copyWith(status: FeedStatus.paginating);
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last.id : null;
      final posts = await _postRepository.getUserFeed(
          userId: _authBloc.state.user.uid, lastPostId: lastPostId);
      final updatedPosts = List<Post>.from(state.posts)..addAll(posts);
      yield state.copyWith(posts: updatedPosts, status: FeedStatus.loaded);
    } catch (err) {
      print("ERROR =>>>>>>>>  ${err}");
      print(err);
      yield state.copyWith(
        status: FeedStatus.error,
        failure:
            const Failure(message: 'Unable to fetch posts. Please try again'),
      );
    }
  }
}
