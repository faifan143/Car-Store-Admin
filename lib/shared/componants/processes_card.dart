import 'package:carrent_admin/layout/cubit/cubit.dart';
import 'package:carrent_admin/models/process_model.dart';
import 'package:carrent_admin/modules/chat/InChatScreen.dart';
import 'package:carrent_admin/shared/componants/componants.dart';
import 'package:carrent_admin/shared/componants/reusable_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles/icon_brokin.dart';

class ProcessesCard extends StatelessWidget {
  ProcessesCard({
    super.key,
    required this.processModel,
    this.empId,
    required this.show,
  });
  final ProcessModel processModel;
  String? empId;
  bool show = false;
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
            height: processModel.requestStatus! == "RequestStatus.WAITING"
                ? 490
                : 350,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_sharp,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        processModel.requestDate!.toDate().toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Client Email :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        processModel.clientEmail!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Client Phone Number :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        processModel.clientNumber!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Car :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        processModel.car!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Request Type :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        processModel.dealType!.split(".")[1],
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Duration :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        processModel.duration!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Delivery Date :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        processModel.receivingDate!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Status :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        processModel.requestStatus!.split(".")[1],
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total Cost :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        processModel.totalCost!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'jannah',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: ReUsableButton(
                          height: 20,
                          colour: Colors.white54,
                          text: "Show Image",
                          radius: 10,
                          textColor: Colors.black,
                          onPressed: () {
                            navigateTo(context,
                                ShowImage(image: processModel.carImage!));
                          },
                        ),
                      ),
                      if (show) const SizedBox(width: 10),
                      if (show)
                        Expanded(
                          child: ReUsableButton(
                            height: 20,
                            colour: Colors.white54,
                            text: "Match it",
                            radius: 10,
                            textColor: Colors.black,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title:
                                      const Text("Do you want to match it ?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("No")),
                                    TextButton(
                                        onPressed: () async {
                                          matchDeliveryProcess(context);
                                          await MainCubit.get(context)
                                              .sendNotification(
                                                  context: context,
                                                  title: 'Done ..',
                                                  body: 'Car On The Way',
                                                  receiver: processModel
                                                      .clientNumber!);
                                        },
                                        child: const Text("Yes")),
                                  ],
                                  elevation: 2,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  if (processModel.requestStatus! == "RequestStatus.WAITING")
                    const SizedBox(height: 5),
                  if (processModel.requestStatus! == "RequestStatus.WAITING")
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ReUsableButton(
                            height: 20,
                            colour: Colors.white54,
                            text: "Reject",
                            radius: 10,
                            textColor: Colors.black,
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("processes")
                                  .doc(processModel.processId)
                                  .update({
                                "requestStatus": "RequestStatus.REJECTED",
                                "deliveryId": '',
                              });
                              MainCubit.get(context).sendNotification(
                                  context: context,
                                  title: 'Oops!',
                                  body: 'Process Rejected',
                                  receiver: processModel.clientNumber!);
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: ReUsableButton(
                            height: 20,
                            colour: Colors.lightGreenAccent,
                            text: "Allow",
                            textColor: Colors.black,
                            radius: 10,
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("processes")
                                  .doc(processModel.processId)
                                  .update({
                                "requestStatus": "RequestStatus.APPROVED",
                              });
                              MainCubit.get(context).sendNotification(
                                  context: context,
                                  title: 'Congrats',
                                  body: 'Process Approved',
                                  receiver: processModel.clientNumber!);
                            },
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

  void matchDeliveryProcess(BuildContext context) {
    FirebaseFirestore.instance.collection("companyUsers").doc(empId).update({
      "isAvailable": false,
      "assignedProcessId": processModel.processId,
      "assignedProcessLocation": processModel.location,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("processes")
          .doc(processModel.processId)
          .update({
        "requestStatus": "RequestStatus.ONTHEWAY",
        "deliveryId": empId,
      }).then((value) async {
        String email = await FirebaseFirestore.instance
            .collection("companyUsers")
            .doc(empId)
            .get()
            .then((value) => value.data()!['email']);
        sendEmail(
            email: email,
            subject: 'Open Up !!',
            text: 'Process Assigned to You');
        MainCubit.get(context).logoutAndNavigateToSignInScreen(context);
      }).catchError((onError) {
        print(onError);
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  void sendEmail(
      {required String email,
      required String subject,
      required String text}) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$text',
    );

    final String emailUrl = params.toString();

    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      throw 'Could not launch $emailUrl';
    }
  }
}
