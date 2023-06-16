import 'package:carrent_admin/models/complaint_model.dart';
import 'package:carrent_admin/shared/componants/complaints_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/process_model.dart';
import '../../shared/componants/constants.dart';
import '../../shared/componants/processes_card.dart';
import '../../shared/styles/icon_brokin.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Processes",
                style: Constants.arabicTheme.textTheme.headline1!
                    .copyWith(color: Colors.black),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('processes')
                    .where("requestStatus", isEqualTo: "RequestStatus.WAITING")
                    .orderBy("requestDate", descending: true)
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
                            "No Processes",
                            style: Constants.arabicTheme.textTheme.bodyText1!
                                .copyWith(color: Colors.black),
                          )),
                        )
                      : SizedBox(
                          height: 390.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  ProcessModel processModel =
                                      ProcessModel.fromJson(data);
                                  return Row(
                                    children: [
                                      if (snapshot.data!.docs.length <= 1)
                                        const SizedBox(width: 30),
                                      SizedBox(
                                        width: 350.0,
                                        child: ProcessesCard(
                                          processModel: processModel,
                                          show: false,
                                        ),
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
              const SizedBox(height: 18),
              if (userJobType == "JobTypes.ADMIN")
                Text(
                  "Complaints",
                  style: Constants.arabicTheme.textTheme.headline1!
                      .copyWith(color: Colors.black),
                ),
              if (userJobType == "JobTypes.ADMIN") const SizedBox(height: 10),
              if (userJobType == "JobTypes.ADMIN")
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('complaints')
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
                              "No Complaints",
                              style: Constants.arabicTheme.textTheme.bodyText1!
                                  .copyWith(color: Colors.black),
                            )),
                          )
                        : SizedBox(
                            height: 200.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    ComplaintModel complaintModel =
                                        ComplaintModel.fromJson(data);
                                    return Row(
                                      children: [
                                        if (snapshot.data!.docs.length <= 1)
                                          const SizedBox(width: 30),
                                        SizedBox(
                                          width: 350.0,
                                          child: ComplaintsCard(
                                            complaintModel: complaintModel,
                                          ),
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
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      IconBroken.Delete,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            height: 175,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.timer_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        'Message Time : 12:48 AM',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        'Client Name :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Mohamad Almatar',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Text(
                        'Client Phone Number :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '0981681916',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Text(
                        'Car Name :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'BMW 2022',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
