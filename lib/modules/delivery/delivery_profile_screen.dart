import 'package:carrent_admin/layout/cubit/cubit.dart';
import 'package:carrent_admin/models/employeeModel.dart';
import 'package:carrent_admin/models/process_model.dart';
import 'package:carrent_admin/modules/home/open_product.dart';
import 'package:carrent_admin/shared/componants/processes_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/componants/constants.dart';

class DeliveryProfileScreen extends StatelessWidget {
  const DeliveryProfileScreen({super.key, required this.employeeModel});
  final EmployeeModel employeeModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Stack(
              children: [
                Card(
                  shadowColor: Colors.purple.shade100,
                  elevation: 10,
                  margin: const EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            employeeModel.name!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'jannah',
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'IT since joined date ${employeeModel.joiningDate}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'jannah',
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        const Text(
                          'Contact info :',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'jannah',
                          ),
                        ),
                        socialInfo(
                            label: 'Email : ', content: employeeModel.email!),
                        socialInfo(
                            label: 'Phone number : ',
                            content: employeeModel.phone!),
                        socialInfo(
                            label: 'Job : ',
                            content: employeeModel.userType!.split('.')[1]),
                        socialInfo(
                            label: 'Days Of Work : ',
                            content: employeeModel.daysOfWork!),
                        socialInfo(
                            label: 'Today Status : ',
                            content: employeeModel!.attendanceSchedule!
                                    .contains(MainCubit.get(context).qrCodeData)
                                ? 'Attended'
                                : 'Absent'),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            socialButtons(
                              color: Colors.green,
                              icon: Icons.messenger_outline_sharp,
                              function: () {
                                makeChatWhatsApp(
                                    convertPhoneNumber(employeeModel.phone!));
                              },
                            ),
                            socialButtons(
                              color: Colors.purple,
                              icon: Icons.call_outlined,
                              function: () {
                                makePhoneCall(employeeModel.phone!);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(),
                        const Divider(
                          thickness: 1,
                        ),
                        if (employeeModel.userType == "JobTypes.DELIVERY")
                          const SizedBox(
                            height: 15,
                          ),
                        if (employeeModel.userType == "JobTypes.DELIVERY")
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Available Processes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'jannah',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (employeeModel.userType == "JobTypes.DELIVERY")
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('processes')
                                .where("requestStatus",
                                    isEqualTo: "RequestStatus.APPROVED")
                                .orderBy("requestDate", descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Something is Wrong',
                                  style: Constants
                                      .arabicTheme.textTheme.bodyText1!
                                      .copyWith(color: Colors.black),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Center(
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
                                        "No Available Processes",
                                        style: Constants
                                            .arabicTheme.textTheme.bodyText1!
                                            .copyWith(color: Colors.black),
                                      )),
                                    )
                                  : SizedBox(
                                      height: 400.0,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                              Map<String, dynamic> data =
                                                  document.data()!
                                                      as Map<String, dynamic>;
                                              ProcessModel processModel =
                                                  ProcessModel.fromJson(data);

                                              return Row(
                                                children: [
                                                  if (snapshot
                                                          .data!.docs.length <=
                                                      1)
                                                    const SizedBox(width: 30),
                                                  SizedBox(
                                                    width: 350.0,
                                                    child: ProcessesCard(
                                                      processModel:
                                                          processModel,
                                                      show: true,
                                                      empId: employeeModel.uId!,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      shadowColor: Colors.blue.shade300,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(49.0)),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 6,
                            color: Colors.white,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                employeeModel.image!,
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialInfo({
    required String label,
    required String content,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'jannah',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'jannah',
            ),
          ),
        ),
      ],
    );
  }

  Widget socialButtons(
      {required Color color,
      required IconData icon,
      required Function function}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 23,
        child: IconButton(
          onPressed: () {
            function();
          },
          icon: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }
}
