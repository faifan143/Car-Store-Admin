import 'package:flutter/material.dart';


class GlobalMethods{
  static void showErrorDialog({required String error ,required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.error_outline_outlined,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Error occurred',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error,
                style:const TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        });
  }
}