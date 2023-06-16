import 'package:flutter/material.dart';

class ReUsableButton extends StatelessWidget {
  ReUsableButton({
    Key? key,
    this.onPressed,
    this.text,
    this.radius,
    this.height,
    this.textColor,
    this.width,
    this.colour,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String? text;
  double? height = 20;
  double? width;
  double? radius = 20;
  Color? colour;
  Color? textColor;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 4,
      padding: EdgeInsets.zero,
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius!),
            color: colour ?? Colors.black54),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: height!),
        child: Text(
          text!,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
