import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../layout/cubit/cubit.dart';
import '../../models/employeeModel.dart';
import '../../models/siginup_model/users_model.dart';
import '../../modules/signin/signin_screen.dart';
import '../remot_local/cach_hilper.dart';
import 'componants.dart';

class AppColors {
  // static const Color primaryColor = Color(0xFF5eb4c1);
  static const Color primaryColor = Colors.blueAccent;
  static const Color gradientLightColor = Color(0xff009FFD);
  static const Color gradientDarkColor = Color(0xff2A2A72);
}

enum RequestType { RENT, BUY }

enum RequestStatus { WAITING, REJECTED, APPROVED, ONTHEWAY, DELIVERED }

enum CarStatus { RENTED, SOLD, AVAILABLE }

final urlImages = [
  'assets/images/carr.png',
  'assets/images/carred.png',
  'assets/images/carred.png',
  'assets/images/carr.png',
  'assets/images/carred.png',
];

final controller = CarouselController();
void animateToSlide(int index) => controller.animateToPage(index);

Widget buildIndicator(context, int length) => AnimatedSmoothIndicator(
      onDotClicked: animateToSlide,
      effect: const ExpandingDotsEffect(
        dotColor: Colors.white,
        dotWidth: 10,
        activeDotColor: Colors.amber,
        dotHeight: 8,
      ),
      activeIndex: MainCubit.get(context).activeIndex,
      count: length,
    );

Widget buildImage(String urlImage, int index) =>
    Image.network(urlImage, fit: BoxFit.cover);

class Constants {
  static String fcmServerKey =
      "AAAAaAxG8lQ:APA91bFdB2jlnFxENfRE230BV6qU42tVn7jevPN_6ie3a_scggfB3homZXn-bZ7pt6tysec94Ug3SOFqPsatIy4ZwmVzU2MtENtgWtFFvxy_wT7ClXSueyFOK7_QrFzh5ZzDR5JioWra";
  static List<String> jobList = [
    'Admin',
    'Employee',
    'Delivery',
  ];
  static List<String> addingEmployeeJobList = [
    'Employee',
    'Delivery',
  ];
  static EmployeeModel? employeeModel;

  // Define the English theme
  static ThemeData englishTheme = ThemeData(
    // Set the font family to Nunito
    // Define the text styles for the different typography elements
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
      headline2: TextStyle(fontSize: 26, color: Colors.black),
      bodyText1: TextStyle(
        height: 2,
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Colors.black,
      ),
    ),
  );

// Define the Arabic theme
  static ThemeData arabicTheme = ThemeData(
    // Set the font family to Cairo
    // Define the text styles for the different typography elements
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: Colors.white,
      ),
      headline2: TextStyle(fontSize: 20, color: Colors.white),
      bodyText1: TextStyle(
        height: 2,
        fontSize: 17,
        color: Colors.white,
      ),
    ),
  );

  static UsersModel? usersModel;

  static Future<void> getUserData() async {
    await FirebaseMessaging.instance.subscribeToTopic('employee');
    print("==============================================================4564");
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("companyUsers")
        .doc(uId)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      usersModel = UsersModel.fromJson(data);
      userJobType = CacheHelper.getUId(key: 'userJobType');
      if (userJobType == 'JobTypes.ADMIN') {
        await FirebaseMessaging.instance.subscribeToTopic('admin');
      } else if (userJobType == 'JobTypes.DELIVERY') {
        await FirebaseMessaging.instance.subscribeToTopic(usersModel!.uId!);
      }
      FirebaseMessaging.onMessage.listen((event) {});
      FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    } else {}
  }
}

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

String? uId = '';
String? userJobType;
void logOut(context) {
  CacheHelper.removData(key: 'uId').then((value) {
    if (value) {
      navigateAndFinish(context, SignInScreen());
    }
  });
}

Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return ShowTost(
        text: 'Location services are disabled.', state: ToastState.ERROR);
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return ShowTost(
          text: 'Location permissinons are denied.', state: ToastState.ERROR);
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return ShowTost(
      text:
          'Location permissions are premanetly denied ,  we can\'t request permissions',
      state: ToastState.ERROR,
    );
  }
  return await Geolocator.getCurrentPosition();
}
