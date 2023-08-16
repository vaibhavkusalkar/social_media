import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double minHeight;
  const PostTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.minHeight
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                ),
              ),
            ),
          ),
        )
    );
  }
}
