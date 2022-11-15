import 'package:chat_application/model/ChatUser.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.user, required this.onTap})
      : super(key: key);
  final ChatUser user;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name ?? 'No name'),
      subtitle: Text(user.email ?? 'No email'),
      leading: const Icon(Icons.person),
      onTap: onTap,
    );
  }
}
