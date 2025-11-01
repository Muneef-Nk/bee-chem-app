import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final bool isRequired;
  final String? Function(String?)? customValidator;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    required this.textInputAction,
    this.onChanged,
    this.maxLines = 1,
    this.isRequired = true,
    this.customValidator,
  });

  String? _defaultValidator(String? value) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return '$hint is required';
    }

    if (hint == 'Full Name' && value != null && value.isNotEmpty) {
      final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
      if (!nameRegex.hasMatch(value)) return 'Full Name can only contain letters and spaces';
    }

    if (hint == 'Post Code' && value != null && value.isNotEmpty) {
      final postCodeRegex = RegExp(r'^\d{5,6}$');
      if (!postCodeRegex.hasMatch(value)) return 'Enter a valid Post Code';
    }

    if (hint == 'Contact Number' && value != null && value.isNotEmpty) {
      final phoneRegex = RegExp(r'^[0-9]{10}$');
      if (!phoneRegex.hasMatch(value)) return 'Enter a valid 10-digit contact number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide.none,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        validator: customValidator ?? _defaultValidator,
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
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.black87, size: 20) : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
