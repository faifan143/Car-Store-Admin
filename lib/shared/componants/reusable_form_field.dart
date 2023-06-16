import 'package:flutter/material.dart';

class ReusableFormField extends StatelessWidget {
  ReusableFormField({
    Key? key,
    this.label,
    this.hint,
    this.keyType,
    this.controller,
    this.onTap,
    this.onChange,
    required this.isPassword,
    required this.icon,
    required this.checkValidate,
  }) : super(key: key);
  final String? label;
  final String? hint;
  bool isPassword = false;
  final TextInputType? keyType;
  final TextEditingController? controller;
  Widget icon;
  VoidCallback? onTap;
  String? Function(String?)? checkValidate;
  void Function(String)? onChange;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      controller: controller,
      validator: checkValidate,
      keyboardType: keyType,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      obscureText: isPassword == null || isPassword == false ? false : true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderSide: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(10)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        suffixIcon: IconButton(onPressed: onTap, icon: icon),
        hintText: hint,
      ),
    );
  }
}
