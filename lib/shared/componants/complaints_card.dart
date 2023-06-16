import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/complaint_model.dart';
import '../styles/icon_brokin.dart';

class ComplaintsCard extends StatelessWidget {
  const ComplaintsCard({
    super.key,
    required this.complaintModel,
  });
  final ComplaintModel complaintModel;
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
                  children: [
                    IconButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('complaints')
                            .doc(complaintModel.complaintId!)
                            .delete();
                      },
                      icon: Icon(
                        IconBroken.Delete,
                        color: Colors.red,
                      ),
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
                        complaintModel.date!.toDate().toString(),
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
                        'Complainer Email :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        complaintModel.complainerEmail!,
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
                        'Complainer Phone Number :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        complaintModel.complainerNumber!,
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
                        'Complaint About :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        complaintModel.complaintAbout!,
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
                        'Complaint :',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'jannah',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        complaintModel.complaint!,
                        style: const TextStyle(
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
