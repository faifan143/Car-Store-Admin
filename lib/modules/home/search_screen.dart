import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/car_model/car_model.dart';
import '../../shared/componants/constants.dart';
import 'home_screen.dart';

class CarSearchWidget extends StatelessWidget {
  final String searchQuery;

  CarSearchWidget({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Searched Products : ",
                      style: Constants.arabicTheme.textTheme.headline1!
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('cars').snapshots(),
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

                    final carDocuments = snapshot.data!.docs;
                    final filteredCars = carDocuments
                        .where((doc) => doc
                            .data()
                            .toString()
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();

                    return filteredCars.isEmpty
                        ? SizedBox(
                            height: 250,
                            child: Center(
                                child: Text(
                              "No Newly Added Cars",
                              style: Constants.arabicTheme.textTheme.bodyText1!
                                  .copyWith(color: Colors.black),
                            )),
                          )
                        : SizedBox(
                            height: 220.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: filteredCars
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    CarModel carModel = CarModel.fromJson(data);

                                    return Row(
                                      children: [
                                        if (filteredCars.length <= 1)
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
        ),
      ),
    );
  }
}
