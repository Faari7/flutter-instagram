import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/enums/bottom_nav_item.dart';
import 'package:flutter_instagram/models/notification_model.dart';
import 'package:flutter_instagram/screens/comments/comments.dart';
import 'package:flutter_instagram/widgets/user_profile_image.dart';
import 'package:flutter_instagram/extensions/extensions.dart';

import '../../screens.dart';

class NotificationTile extends StatelessWidget {
  final Notif notification;

  const NotificationTile({
    Key key,
    @required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserProfileImage(
        radius: 18,
        profileImageUrl: notification.fromUser.profileImageURL,
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: notification.fromUser.username,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: ' '),
            TextSpan(text: _getText(notification)),
          ],
        ),
      ),
      subtitle: Text(
        notification.date.timeAgo(),
        //DateFormat.yMd().add_jm().format(comment.date),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        ProfileScreen.routeName,
        arguments: ProfileScreenArgs(userId: notification.fromUser.id),
      ),
      trailing: _getTrailing(context, notification),
    );
  }

  String _getText(Notif notification) {
    switch (notification.type) {
      case NotificationType.comment:
        return 'comment on your post';
      case NotificationType.follow:
        return 'followed you';
      case NotificationType.like:
        return 'liked your post';
      default:
        return '';
    }
  }

  Widget _getTrailing(BuildContext context, Notif notification) {
    if (notification.type == NotificationType.like ||
        notification.type == NotificationType.comment) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          Comments.routeName,
          arguments: CommentsScreenArgs(
            post: notification.post,
          ),
        ),
        child: CachedNetworkImage(
          height: 60,
          width: 60,
          imageUrl: notification.post.imageUrl,
          fit: BoxFit.cover,
        ),
      );
    } else if (notification.type == NotificationType.follow) {
      return const SizedBox(
        height: 60,
        width: 60,
        child: Icon(Icons.person_add),
      );
    }
    return const SizedBox.shrink();
  }
}
