import 'package:carrent_admin/modules/admin_page/employee_control/add.dart';
import 'package:carrent_admin/modules/admin_page/employee_control/delete.dart';
import 'package:carrent_admin/modules/chat/InChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconly/iconly.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';
import '../notification/notification_screen.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(listener: (context, state) {
      if (state is userGottenSuccessfully) {
        print("======== ${Constants.usersModel!.email} =========");
        print("======== ${userJobType} =========");
      } else {
        print("======== ${Constants.usersModel!.email} =========");
      }
    }, builder: (context, state) {
      var cubit = MainCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              ZoomDrawer.of(context)!.toggle();
            },
            child: Icon(
              IconBroken.Category,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            cubit.titles[cubit.currentIndex],
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InChatScreen(model: Constants.usersModel!),
                    ));
              },
              child: Icon(
                IconBroken.Chat,
                size: 25,
              ),
            ),
            if (userJobType != "JobTypes.ADMIN") SizedBox(width: 15),
            if (userJobType != "JobTypes.ADMIN")
              InkWell(
                onTap: () {
                  cubit.scanQRCode();
                },
                child: Icon(
                  IconBroken.Scan,
                  size: 25,
                ),
              ),
            SizedBox(width: 5),
            if (userJobType == "JobTypes.ADMIN")
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddEmployeeScreen(),
                        ));
                      },
                      icon: const Icon(
                        IconlyBroken.plus,
                        size: 25,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DeleteEmployeeScreen(),
                        ));
                      },
                      icon: const Icon(
                        IconlyBroken.delete,
                        size: 25,
                        color: Colors.black,
                      )),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  navigateTo(context, const NotificationScreen());
                },
                icon: const Icon(
                  IconBroken.Notification,
                ),
              ),
            ),
          ],
        ),
        body: cubit.screens[cubit.currentIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GNav(
            onTabChange: (index) {
              cubit.changeBottomNavBar(index);
            },
            selectedIndex: cubit.currentIndex,
            gap: 8,
            padding: const EdgeInsets.all(8),
            activeColor: Colors.white,
            tabBackgroundColor: Colors.black,
            tabs: [
              const GButton(
                icon: IconBroken.Home,
                text: 'Home',
              ),
              const GButton(
                icon: IconBroken.Paper_Plus,
                text: 'Add post',
              ),
              const GButton(
                icon: IconBroken.Chart,
                text: 'Add offer',
              ),
              const GButton(
                icon: IconBroken.Profile,
                text: 'Delivers',
              ),
              if (userJobType == "JobTypes.ADMIN")
                const GButton(
                  icon: IconBroken.Graph,
                  text: 'Admin Panel',
                ),
            ],
          ),
        ),
      );
    });
  }
}
