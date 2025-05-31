import 'package:flutter/material.dart';

import '../../models/User.dart';
import '../screens/user_detail_screen.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              user.image != null && user.image!.isNotEmpty
                  ? NetworkImage(user.image!)
                  : null,
          child:
              (user.image == null || user.image!.isEmpty)
                  ? const Icon(Icons.person)
                  : null,
        ),
        title: Text(user.fullName,style: TextStyle(fontSize: 18),),
        subtitle: Text(user.email,style: TextStyle(fontSize: 13),),
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserDetailScreen(userId: user.id),
              ),
            ),
      ),
    );
    
  }
}
