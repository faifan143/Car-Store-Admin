import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.black,
  bool isUpperCase = true,
  double radius = 12,
  required Function function,
  required String text,
  TextStyle stylee = const TextStyle(
    color: Colors.white,
  ),
}) =>
    Container(
      width: width,
      height: 45.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(isUpperCase ? text.toUpperCase() : text, style: stylee),
      ),
    );

Widget defaultTextButton({
  required BuildContext context,
  required String label,
  required Function onTap,
  double size = 14,
  double? width,
  double? height,
  Color? color,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        onPressed: () {
          onTap();
        },
        child: Text(
          label,
          style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: 14, color: Colors.amber.shade300, fontFamily: 'jannah'),
        ),
      ),
    );
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  GestureTapCallback? onTap,
  bool isPassword = false,
  required FormFieldValidator<String>? validate,
  String? label,
  String? hint,
  String? initialValue,
  IconData? prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
  bool readOnly = false,
}) =>
    TextFormField(
      initialValue: initialValue,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: label,
        prefixIcon: Icon(
          prefix,
          size: 30,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
ShowTost({
  required String text,
  required ToastState state,
}) {
  Fluttertoast.showToast(
    msg: text,
    gravity: ToastGravity.BOTTOM,
    textColor: Colors.white,
    backgroundColor: choseColorToast(state),
    toastLength: Toast.LENGTH_SHORT,
  );
}

toast({
  required String msg,
  required ToastState state,
}) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    textColor: Colors.white,
    backgroundColor: choseColorToast(state),
    toastLength: Toast.LENGTH_SHORT,
  );
}

enum ToastState { SUCCESS, ERROR, WRINING }

Color choseColorToast(state) {
  late Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WRINING:
      color = Colors.amber;
      break;
  }

  return color;
}

class TextFormFields extends StatelessWidget {
  TextFormFields({
    super.key,
    required this.controller,
    required this.enabled,
    required this.function,
    required this.maxlength,
    required this.type,
    this.validation,
    this.sufix,
    this.suffixPressed,
    this.onTapOutside,
    this.label,
    this.isFocused,
  });
  final TextEditingController controller;
  final bool enabled;
  final Function function;
  final int maxlength;
  final TextInputType type;
  final FormFieldValidator<String>? validation;
  final IconData? sufix;
  final Function? suffixPressed;
  final void Function(PointerDownEvent)? onTapOutside;
  final String? label;
  bool? isFocused;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: TextFormField(
        controller: controller,
        autofocus: isFocused ?? false,
        validator: validation,
        onTapOutside: onTapOutside,
        enabled: enabled,
        style: const TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'jannah'),
        maxLines: 1,
        maxLength: maxlength,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
          suffix: Icon(sufix),
          filled: true,
          fillColor: Colors.white,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

Widget myDivider() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 1,
        color: Colors.grey.shade300,
      ),
    );
