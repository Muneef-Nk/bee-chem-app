import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final IconData? prefixIcon;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    required this.textInputAction,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide.none,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // small space between fields
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // subtle shadow
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // moves shadow slightly down
          ),
        ],
      ),
      child: TextField(
        autofocus: false,
        controller: controller,
        obscureText: obscure,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black87, size: 20) : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
