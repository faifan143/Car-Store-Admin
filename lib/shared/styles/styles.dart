import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.deepOrange,
  textTheme: const TextTheme(
      bodyText1: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Jannah',
  )),
  dataTableTheme:const DataTableThemeData(dataTextStyle:TextStyle(color: Colors.teal)),
  scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    titleSpacing: 20.0,
    elevation: 0.0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Jannah',
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    unselectedItemColor: Colors.red,
    type: BottomNavigationBarType.fixed,
  ),
);

// ThemeData darkTheme = ThemeData(
//   scaffoldBackgroundColor: HexColor('46403F'),
//   primarySwatch: Colors.deepOrange,
//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     backgroundColor: Colors.deepOrange,
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     type: BottomNavigationBarType.fixed,
//     selectedItemColor: Colors.deepOrange,
//     unselectedItemColor: Colors.grey,
//     backgroundColor: HexColor('46403F'),
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: HexColor('46403F'),
//     titleSpacing: 20.0,
//     elevation: 0.0,
//     iconTheme: const IconThemeData(
//       color: Colors.white,
//     ),
//     titleTextStyle: const TextStyle(
//       color: Colors.white,
//       fontSize: 20.0,
//       fontWeight: FontWeight.bold,
//     ),
//     systemOverlayStyle: SystemUiOverlayStyle(
//       statusBarColor: HexColor('46403F'),
//       statusBarIconBrightness: Brightness.light,
//       systemNavigationBarColor: HexColor('46403F'),
//     ),
//   ),
//   textTheme: const TextTheme(
//     bodyText1: TextStyle(
//       fontSize: 18.0,
//       fontWeight: FontWeight.w600,
//       color: Colors.white,
//     ),
//   ),
//   fontFamily: 'Jannah',
// );
