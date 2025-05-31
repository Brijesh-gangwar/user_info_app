import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;

  const UserAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
            ? NetworkImage(imageUrl!)
            : null,
        child: (imageUrl == null || imageUrl!.isEmpty)
            ? const Icon(Icons.person, size: 50)
            : null,
      ),
    );
  }
}
