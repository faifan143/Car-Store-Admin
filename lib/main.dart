import 'package:carrent_admin/layout/cubit/states.dart';
import 'package:carrent_admin/modules/map_tracking/delivery_cubit.dart';
import 'package:carrent_admin/modules/map_tracking/map_tracking.dart';
import 'package:carrent_admin/modules/signin/signin_screen.dart';
import 'package:carrent_admin/shared/componants/constants.dart';
import 'package:carrent_admin/shared/remot_local/cach_hilper.dart';
import 'package:carrent_admin/shared/styles/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'layout/cubit/cubit.dart';
import 'layout/main_layout.dart';
import 'modules/admin_page/employee_control/add_cubit.dart';

Future<void> backgroundMessage(RemoteMessage event) async {
  print('Handling a background message ${event.messageId}');
  // Handle your background message here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundMessage);

  // Handle when the app is opened from a terminated state
  FirebaseMessaging.instance.getInitialMessage().then((message) {});

  // Handle when the app is opened from a background state
  FirebaseMessaging.onMessageOpenedApp.listen((message) {});

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  uId = CacheHelper.getUId(key: 'uId');
  userJobType = CacheHelper.getUId(key: 'userJobType');
  Widget widget;
  if (userJobType == "JobTypes.DELIVERY") {
    await Constants.getUserData();
    widget = const MapTracking();
  } else {
    if (uId != null) {
      await Constants.getUserData();
      widget = const MainLayout();
    } else {
      widget = SignInScreen();
    }
  }
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({
    Key? key,
    required this.startWidget,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainCubit()..initializeCubit()),
        BlocProvider(create: (context) => AddCubit()..initializeAddCubit()),
        BlocProvider(
            create: (context) => DeliveryCubit()..initializeDeliveryCubit()),
      ],
      child: BlocConsumer<MainCubit, MainStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home: startWidget,
          );
        },
      ),
    );
  }
}
