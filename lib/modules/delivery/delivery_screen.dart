import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/employeeModel.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';
import 'delivery_profile_screen.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('companyUsers')
                    .where("userType", isEqualTo: "JobTypes.DELIVERY")
                    .where("isAvailable", isEqualTo: true)
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
                            "No Delivery Employees",
                            style: Constants.arabicTheme.textTheme.bodyText1!
                                .copyWith(color: Colors.black),
                          )),
                        )
                      : SizedBox(
                          height: 220.0,
                          child: ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  EmployeeModel employeeModel =
                                      EmployeeModel.fromJson(data);
                                  return Row(
                                    children: [
                                      if (snapshot.data!.docs.length <= 1)
                                        const SizedBox(width: 30),
                                      SizedBox(
                                        width: 350.0,
                                        child: BuildDeliveryWidget(
                                            employeeModel: employeeModel),
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

  void showTaskCategoryDialog(context, size) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Task category',
              style: TextStyle(color: Colors.pink.shade300, fontSize: 20),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.jobList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // print('index ${Constants.taskCategoryList[index]}');
                        // setState(() {
                        //   taksCategory = Constants.taskCategoryList[index];
                        // });
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.red.shade200,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              Constants.jobList[index],
                              style: const TextStyle(
                                color: Color(0xff00325A),
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  // setState(() {
                  //   taksCategory = null;
                  // });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel filter'),
              ),
            ],
          );
        });
  }
}

class BuildDeliveryWidget extends StatelessWidget {
  const BuildDeliveryWidget({
    super.key,
    required this.employeeModel,
  });
  final EmployeeModel employeeModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black26),
      child: ListTile(
        onTap: () {
          navigateTo(
            context,
            DeliveryProfileScreen(
              employeeModel: employeeModel,
            ),
          );
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 2.0, color: Colors.amber),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20.0,
            child: Image.network(
              employeeModel.image!,
            ),
          ),
        ),
        title: Text(
          employeeModel.name!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.linear_scale_outlined,
              color: Colors.blue,
            ),
            Text(
              employeeModel.email!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
        trailing: const Icon(
          IconBroken.Arrow___Right_2,
          size: 25,
          color: Colors.blue,
        ),
      ),
    );
  }
}
