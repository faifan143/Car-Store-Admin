import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hexcolor/hexcolor.dart';

import '../modules/drawer/drawer_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key, context});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return ZoomDrawer(
          controller: z,
          angle: -8,
          menuBackgroundColor: HexColor('D6F4DC'),
          showShadow: true,
          drawerShadowsBackgroundColor: Colors.black,
          borderRadius: 40,
          slideWidth: MediaQuery.of(context).size.width * 0.6,
          menuScreen: Builder(builder: (context) {
            return DrawerScreen(
              currentItem: cubit.currentItem,
              onSelectItem: (item) {
                cubit.changeDrawer(item);
                ZoomDrawer.of(context)!.close();
              },
            );
          }),
          mainScreen: cubit.getScreen(),
        );
      },
    );
  }
}

final ZoomDrawerController z = ZoomDrawerController();
