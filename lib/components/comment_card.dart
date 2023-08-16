import 'dart:developer';

import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  final String name;
  const CommentCard({
    super.key,
    required this.text,
    required this.user,
    required this.time,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //profile photo
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle
              ),
              child: ClipOval(child: Image.asset("lib/assets/profile_photo.png",height: 40,width: 40)),
            ),
            const SizedBox(width: 15),

            //comment,user
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 4),
                Text(
                  "$name ($user) . $time",
                  style: TextStyle(
                    fontSize: 10.9,
                    color: Colors.grey.shade900,
                    letterSpacing: 0.05
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                    text,
                    style: TextStyle(
                      //color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
