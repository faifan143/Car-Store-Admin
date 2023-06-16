import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrent_admin/modules/home/payment_screen.dart';
import 'package:carrent_admin/shared/componants/componants.dart';
import 'package:carrent_admin/shared/componants/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/car_model/car_model.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';
import 'my_behaviour.dart';

class OpenProductScreen extends StatelessWidget {
  OpenProductScreen({super.key, required this.carModel});
  final CarModel carModel;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  scrolledUnderElevation: 0,
                  elevation: 0,
                  backgroundColor: HexColor(
                    '252527',
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      IconBroken.Arrow___Left_2,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                body: FadeInDown(
                  delay: const Duration(microseconds: 60),
                  child: ScrollConfiguration(
                    behavior: MyBehavioure(),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: size.width,
                                  height: size.height * 0.42,
                                  decoration: BoxDecoration(
                                    color: HexColor('D6F4DC'),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: size.height * 0.4,
                                      decoration: BoxDecoration(
                                        color: HexColor(
                                          '252527',
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(50),
                                          bottomLeft: Radius.circular(50),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            // top: size.height * 0.05,
                                            // right: size.width * 0.1,
                                            // left: size.width * 0.1,
                                            // bottom: size.height * 0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 70),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child:
                                                        CarouselSlider.builder(
                                                      carouselController:
                                                          controller,
                                                      itemCount: carModel
                                                          .imageFiles!.length,
                                                      itemBuilder: (
                                                        context,
                                                        index,
                                                        realIndex,
                                                      ) {
                                                        final urlImage = carModel
                                                            .imageFiles![index];
                                                        return buildImage(
                                                          urlImage,
                                                          index,
                                                        );
                                                      },
                                                      options: CarouselOptions(
                                                        autoPlay: false,
                                                        enableInfiniteScroll:
                                                            true,
                                                        enlargeCenterPage: true,
                                                        onPageChanged: (index,
                                                                reason) =>
                                                            cubit
                                                                .changecarouseloption(
                                                                    index),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  buildIndicator(
                                                      context,
                                                      carModel
                                                          .imageFiles!.length),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            left: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 0, 18, 0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        carModel.branch!,
                                                        style: Constants
                                                            .arabicTheme
                                                            .textTheme
                                                            .headline1,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        carModel.modelYear!,
                                                        style: Constants
                                                            .arabicTheme
                                                            .textTheme
                                                            .headline2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 4, 0, 4),
                              child: Text(
                                "Specifications",
                                style: TextStyle(
                                  fontFamily: 'Jannah',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: HexColor(
                                    '252527',
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      carDetailsItem(
                                        context,
                                        const AssetImage(
                                          'assets/images/speed.png',
                                        ),
                                        '${carModel.speed!} km/h',
                                      ),
                                      carDetailsItem(
                                          context,
                                          const AssetImage(
                                            'assets/images/cardoor.png',
                                          ),
                                          '${carModel.doors!} Doors'),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      carDetailsItem(
                                          context,
                                          const AssetImage(
                                            'assets/images/seat.png',
                                          ),
                                          '${carModel.seats!} Seats'),
                                      carDetailsItem(
                                          context,
                                          const AssetImage(
                                            'assets/images/tank.png',
                                          ),
                                          '${carModel.tankCapacity} Liters'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: HexColor('D6F4DC'),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    width: double.infinity,
                                    child: ReadMoreText(
                                      carModel.details!,
                                      trimLines: 2,
                                      //colorClickableText: Colors.blue,
                                      trimMode: TrimMode.Line,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                      trimCollapsedText: 'Show more',
                                      lessStyle:
                                          const TextStyle(color: Colors.red),
                                      trimExpandedText: 'Show less',
                                      moreStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        height: 2,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.04,
                                ),
                                ReUsableButton(
                                  height: 20,
                                  width: 180,
                                  onPressed: () {
                                    navigateTo(context,
                                        PayingScreen(carModel: carModel));
                                  },
                                  radius: 10,
                                  text: "Add Offer",
                                  colour: Colors.black,
                                  textColor: Colors.white,
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                )));
      },
    );
  }

  carDetailsItem(BuildContext context, AssetImage image, String text) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                height: size.height * 0.075,
                width: size.width * 0.45,
                // ignore: sort_child_properties_last
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                            height: 35,
                            width: 35,
                            child: Image(
                              image: image,
                              fit: BoxFit.cover,
                            ))),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: size.height * 0.05,
                      width: 2,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      text,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: HexColor('D6F4DC'),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> makeChatWhatsApp(String phone) async {
  final Uri whatsApp = Uri.parse('whatsapp://send?phone=$phone');
  if (await canLaunchUrl(whatsApp)) {
    await launchUrl(whatsApp);
  } else {
    throw 'Error occured coulnd\'t open link';
  }
}

String convertPhoneNumber(String phoneNumber) {
  if (phoneNumber.length != 10) {
    throw FormatException('Invalid phone number format');
  }

  String countryCode = '+963';
  String areaCode = phoneNumber.substring(0, 3);
  String firstPart = phoneNumber.substring(3, 6);
  String secondPart = phoneNumber.substring(6);

  return '$countryCode $areaCode $firstPart $secondPart';
}
