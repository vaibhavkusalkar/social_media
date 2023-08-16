import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final Function()? onTap;
  const LikeButton({
    super.key,
    required this.isLiked,
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
          isLiked ? Icons.favorite_outlined : Icons.favorite_border_outlined,
          color: isLiked ? Colors.red.shade600 : Colors.black87,
          size: 20,
        ),
        onPressed: onTap,
      ),
    );
  }
}
