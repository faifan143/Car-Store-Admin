import 'package:flutter/material.dart';

import '../../shared/componants/constants.dart';
import '../../shared/remot_local/cach_hilper.dart';
import '../signin/signin_screen.dart';

class MyBehavioure extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

final List<Color> colors = [
  Colors.amber,
  Colors.pink,
  Colors.orange,
  Colors.purple,
  Colors.brown,
  Colors.blue,
];

String? uId = '';
void logOut(context) {
  CacheHelper.removData(key: 'uId').then((value) {
    if (value) {
      navigateAndFinish(context, SignInScreen());
    }
  });
}
