import 'package:flutter/material.dart';

class UserSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const UserSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Padding(
             padding: const EdgeInsets.only(left: 10.0, bottom: 4.0,right: 2,),
            child: Text(
              'No $title available.',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          )
        else
          ...items.map((item) =>  Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 4.0,right: 2,
            ),
            child: Text('• $item',style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic),),
          ),).toList(),

      ],
    );
  }
}
