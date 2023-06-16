import 'package:animate_do/animate_do.dart';
import 'package:carrent_admin/layout/cubit/cubit.dart';
import 'package:carrent_admin/layout/main_layout.dart';
import 'package:carrent_admin/shared/componants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/car_model/car_model.dart';
import '../../shared/componants/componants.dart';
import '../../shared/styles/icon_brokin.dart';

class PayingScreen extends StatefulWidget {
  PayingScreen({super.key, required this.carModel});
  final CarModel carModel;
  @override
  State<PayingScreen> createState() => _PayingScreenState();
}

class _PayingScreenState extends State<PayingScreen> {
  var formKey = GlobalKey<FormState>();
  var dateController =
      TextEditingController(text: 'pick up offer\'s expiration date');
  var offerController = TextEditingController(text: '0');
  late CarModel carModel;
  @override
  void initState() {
    // TODO: implement initState
    carModel = widget.carModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? date;
    var offer = double.parse(carModel.price!) *
        (double.parse(offerController.text.trim().isEmpty
                ? '0'
                : offerController.text.trim()) /
            100);
    var priceAfterOffer = double.parse(carModel.price!) - offer;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Paying',
          style: TextStyle(fontFamily: 'jannah'),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            IconBroken.Arrow___Left_2,
          ),
        ),
      ),
      body: FadeInDown(
        delay: const Duration(
          milliseconds: 60,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        height: 75,
                        child: TextFormFields(
                          validation: (value) {
                            if (value!.isEmpty) return "Missing Field";
                            if (value == 'pick up offer\'s expiration date') {
                              return "Missing Field";
                            }
                          },
                          controller: dateController,
                          type: TextInputType.text,
                          enabled: false,
                          function: () async {
                            date =
                                await MainCubit.get(context).pickDate(context);
                            setState(() async {
                              dateController.text =
                                  "${date!.year}-${date!.month}-${date!.day}";
                            });
                          },
                          maxlength: 100,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              dateController.text =
                                  'pick up a offer expiration date';
                            });
                          },
                          icon: const Icon(
                            IconBroken.Delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 75,
                    child: TextFormFields(
                      onTapOutside: (p0) => setState(() {}),
                      validation: (value) {
                        if (value!.isEmpty) {
                          return "Missing Fields";
                        }
                        if (value == "0") {
                          return "Missing Fields";
                        }
                        final regex = r'^-?\d+(\.\d+)?$';
                        if (!RegExp(regex).hasMatch(value)) {
                          return "Invalid value. Please enter a valid number.";
                        }
                      },
                      label: 'Please enter the offer percentage . . .',
                      controller: offerController,
                      type: TextInputType.number,
                      enabled: true,
                      function: () {},
                      maxlength: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Car price',
                            style:
                                TextStyle(fontSize: 16, fontFamily: 'jannah'),
                          ),
                          Text(
                            '${carModel.price} \$',
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'jannah',
                                color: Colors.deepOrange),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Delivery price',
                            style:
                                TextStyle(fontSize: 16, fontFamily: 'jannah'),
                          ),
                          Text(
                            '90 \$',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'jannah',
                                color: Colors.deepOrange),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Car Price After Offer',
                            style:
                                TextStyle(fontSize: 16, fontFamily: 'jannah'),
                          ),
                          Text(
                            '$priceAfterOffer \$',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'jannah',
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total price',
                            style:
                                TextStyle(fontSize: 16, fontFamily: 'jannah'),
                          ),
                          Text(
                            '${priceAfterOffer + 90} \$',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'jannah',
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  defaultButton(
                    function: () {
                      if (formKey.currentState!.validate()) {
                        FirebaseFirestore.instance
                            .collection('cars')
                            .doc(carModel.carId)
                            .update({
                          "priceAfterOffer": priceAfterOffer.toString(),
                          "offerPercentage": offerController.text.trim(),
                          "offerExpirationDate": date.toString(),
                          "isOffered": true,
                        }).then((value) {
                          navigateAndFinish(context, const MainLayout());
                        });
                      }
                    },
                    text: 'Add Offer',
                    isUpperCase: false,
                    width: 150,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
