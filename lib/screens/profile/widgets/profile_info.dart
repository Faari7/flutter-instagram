import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String username;
  final String bio;

  const ProfileInfo({Key key, this.username, this.bio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          bio,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
