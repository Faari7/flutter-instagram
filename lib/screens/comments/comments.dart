import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/blocs/auth/auth_bloc.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/repositories/post/post_repository.dart';
import 'package:flutter_instagram/screens/comments/bloc/comments_bloc.dart';
import 'package:flutter_instagram/screens/screens.dart';
import 'package:flutter_instagram/widgets/widgets.dart';
import 'package:flutter_instagram/extensions/extensions.dart';

class CommentsScreenArgs {
  final Post post;

  CommentsScreenArgs({@required this.post});
}

class Comments extends StatefulWidget {
  static const String routeName = '/comments';

  static Route route({@required CommentsScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CommentsBloc>(
        create: (_) => CommentsBloc(
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(CommentsFetchComments(post: args.post)),
        child: Comments(),
      ),
    );
  }

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Comments'),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.only(bottom: 60),
            itemCount: state.comments.length,
            itemBuilder: (BuildContext context, int index) {
              final comment = state.comments[index];

              return ListTile(
                leading: UserProfileImage(
                  radius: 22,
                  profileImageUrl: comment.author.profileImageURL,
                ),
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: comment.author.username,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: comment.content),
                    ],
                  ),
                ),
                subtitle: Text(
                  comment.date.timeAgo(),
                  //DateFormat.yMd().add_jm().format(comment.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  ProfileScreen.routeName,
                  arguments: ProfileScreenArgs(userId: comment.author.id),
                ),
              );
            },
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.status == CommentStatus.submitting)
                  const LinearProgressIndicator(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: false,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Write a comment...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        final content = _commentController.text.trim();
                        if (content.isNotEmpty) {
                          context
                              .read<CommentsBloc>()
                              .add(CommentsPostComment(content: content));
                          _commentController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
