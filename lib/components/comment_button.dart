import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final Function()? onTap;
  const CommentButton({
    super.key,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white60,
      ),
      child: IconButton(
        icon: Icon(
          Icons.insert_comment_outlined,
          color: Colors.black87,
          size: 20,
        ),
        onPressed: onTap,
      ),
    );
  }
}
