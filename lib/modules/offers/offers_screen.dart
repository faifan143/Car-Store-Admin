import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/car_model/car_model.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../home/home_screen.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Offers',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'jannah',
                        ),
                      ),
                      defaultTextButton(
                        context: context,
                        label: 'View all',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('cars')
                      .where("isOffered", isEqualTo: true)
                      .where('carStatus', isEqualTo: 'CarStatus.AVAILABLE')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'Something is Wrong',
                        style: Constants.arabicTheme.textTheme.bodyText1!
                            .copyWith(color: Colors.black),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return snapshot.data!.docs.isEmpty
                        ? SizedBox(
                            height: 250,
                            child: Center(
                                child: Text(
                              "No Offered Cars",
                              style: Constants.arabicTheme.textTheme.bodyText1!
                                  .copyWith(color: Colors.black),
                            )),
                          )
                        : SizedBox(
                            height: 220.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    CarModel carModel = CarModel.fromJson(data);

                                    return Row(
                                      children: [
                                        if (snapshot.data!.docs.length <= 1)
                                          const SizedBox(width: 30),
                                        SizedBox(
                                          width: 350.0,
                                          child: CarCard(carModel: carModel),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    );
                                  })
                                  .toList()
                                  .cast(),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
