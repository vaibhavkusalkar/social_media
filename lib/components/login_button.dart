import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String label;
  const MyButton({
    super.key,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        fixedSize: MaterialStatePropertyAll(Size(365,50))
      ),
      child: Text(label),
      onPressed: onTap,
    );
  }
}
