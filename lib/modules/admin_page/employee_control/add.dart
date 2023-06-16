import 'package:carrent_admin/layout/main_layout.dart';
import 'package:carrent_admin/models/employeeModel.dart';
import 'package:carrent_admin/modules/admin_page/employee_control/add_cubit.dart';
import 'package:carrent_admin/modules/admin_page/employee_control/admin_states.dart';
import 'package:carrent_admin/shared/componants/reusable_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/componants/componants.dart';
import '../../../shared/componants/constants.dart';
import '../../../shared/styles/icon_brokin.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCubit, AdminStates>(listener: (context, state) {
      if (state is EmployeeCreateSuccessState) {
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      var cubit = AddCubit.get(context);
      return Scaffold(
        body: SafeArea(
            child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
              child: Form(
                key: cubit.formState,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Hire Employee",
                          style: Constants.arabicTheme.textTheme.headline1!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('hiringRequests')
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

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                  "No Hiring Requests Available",
                                  style: Constants
                                      .arabicTheme.textTheme.bodyText1!
                                      .copyWith(color: Colors.black),
                                )),
                              )
                            : SizedBox(
                                height: 220.0,
                                child: ListView(
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()! as Map<String, dynamic>;
                                        EmployeeModel employeeModel =
                                            EmployeeModel.fromJson(data);
                                        return Row(
                                          children: [
                                            if (snapshot.data!.docs.length <= 1)
                                              const SizedBox(width: 30),
                                            SizedBox(
                                              width: 350.0,
                                              child: BuildHiringWidget(
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        )),
      );
    });
  }
}

class BuildHiringWidget extends StatelessWidget {
  const BuildHiringWidget({
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
            HiringProfileScreen(
              employeeModel: employeeModel,
            ),
          );
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
          employeeModel.email!,
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
              employeeModel.userType!.split('.')[1],
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

class HiringProfileScreen extends StatelessWidget {
  const HiringProfileScreen({super.key, required this.employeeModel});
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 18),
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
                            '${employeeModel.userType!.split(".")[1]} request',
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
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: () async {
                                  if (await canLaunch(employeeModel.pdfFile!)) {
                                    await launch(employeeModel.pdfFile!);
                                  } else {
                                    throw 'Could not launch PDF';
                                  }
                                },
                                child: const Text("Click to Open CV"))),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(),
                        const Divider(
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ReUsableButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                          "Are You Sure You Want To Reject ?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("NO")),
                                        TextButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection("hiringRequests")
                                                  .doc(employeeModel.uId)
                                                  .delete()
                                                  .then((value) {
                                                navigateAndFinish(context,
                                                    const MainLayout());
                                              });
                                            },
                                            child: const Text("Yes")),
                                      ],
                                    ),
                                  );
                                },
                                height: 20,
                                colour: Colors.redAccent,
                                radius: 10,
                                text: "Reject",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ReUsableButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                          "Are You Sure You Want To Approve ?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("NO")),
                                        TextButton(
                                            onPressed: () async {
                                              FirebaseFirestore.instance
                                                  .collection("hiringRequests")
                                                  .doc(employeeModel.uId)
                                                  .delete();
                                              DateTime now = DateTime.now();
                                              String currentDate =
                                                  "${now.year}-${now.month}-${now.day}";

                                              employeeModel.joiningDate =
                                                  currentDate;
                                              DocumentReference docRef =
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "companyUsers")
                                                      .doc();
                                              employeeModel.uId = docRef.id;
                                              docRef
                                                  .set(employeeModel.toMap())
                                                  .then((value) {
                                                navigateAndFinish(context,
                                                    const MainLayout());
                                              });

                                              UserCredential userCredential =
                                                  await FirebaseAuth.instance
                                                      .createUserWithEmailAndPassword(
                                                email: employeeModel.email!,
                                                password:
                                                    employeeModel.password!,
                                              );
                                              sendEmail(
                                                  email: employeeModel.email!,
                                                  subject: 'Approval',
                                                  text: 'You Are Hired');
                                              // Send verification email
                                              userCredential.user!
                                                  .sendEmailVerification();
                                            },
                                            child: const Text("Yes")),
                                      ],
                                    ),
                                  );
                                },
                                height: 20,
                                colour: Colors.lightGreen,
                                radius: 10,
                                text: "Approve",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
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
