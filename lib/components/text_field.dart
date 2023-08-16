import 'package:flutter/material.dart';
import 'package:social_media_material/pages/login_page.dart';

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.clear),
    onPressed: () => controller.clear(),
  );
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: icon,
          suffixIcon: _ClearButton(controller: controller),
          labelText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
