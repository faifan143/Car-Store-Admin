import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carrent_admin/layout/cubit/cubit.dart';
import 'package:carrent_admin/layout/cubit/states.dart';
import 'package:carrent_admin/models/announce_model.dart';
import 'package:carrent_admin/models/complaint_model.dart';
import 'package:carrent_admin/models/process_model.dart';
import 'package:carrent_admin/shared/componants/complaints_card.dart';
import 'package:carrent_admin/shared/componants/constants.dart';
import 'package:carrent_admin/shared/componants/processes_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../shared/componants/global_method.dart';
import '../../shared/componants/snackbar.dart';

class AdminPage extends StatelessWidget {
  AdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    final postFormKey = GlobalKey<FormState>();
    TextEditingController commentController = TextEditingController();
    TextEditingController aboutController = TextEditingController();

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        print("=====QR CODE======= is ======= :\n ${cubit.qrCodeData}");

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Center(
                  child: QrImage(
                    data: cubit.qrCodeData,
                    version: QrVersions.max,
                    size: 400.0,
                    semanticsLabel: "Attendance QR Code",
                  ),
                ),
                Text("Attendance QR Code"),
                Text(
                  "Processes",
                  style: Constants.arabicTheme.textTheme.headline1!
                      .copyWith(color: Colors.black),
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('processes')
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
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
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
                SizedBox(height: 10),
                Text(
                  "Complaints",
                  style: Constants.arabicTheme.textTheme.headline1!
                      .copyWith(color: Colors.black),
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('complaints')
                      .orderBy("date", descending: true)
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
                                              complaintModel: complaintModel),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade100,
                    shadowColor: Colors.blue.shade200,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Uploaded by',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.deepOrange,
                                  ),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          Constants.usersModel!.image!),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(Constants.usersModel!.name!),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Submit An Announcement :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Form(
                                    key: postFormKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          maxLength: 50,
                                          controller: aboutController,
                                          style: const TextStyle(
                                            color: Colors.brown,
                                          ),
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.pink),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          maxLength: 200,
                                          controller: commentController,
                                          style: const TextStyle(
                                            color: Colors.brown,
                                          ),
                                          keyboardType: TextInputType.text,
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.pink),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                value.length < 7) {
                                              return 'invalid announcement';
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          MaterialButton(
                                            onPressed: () async {
                                              if (commentController
                                                      .text.isEmpty ||
                                                  commentController
                                                          .text.length <
                                                      7) {
                                                GlobalMethods.showErrorDialog(
                                                    error:
                                                        'Comment can\'t be less than 7 characters',
                                                    context: context);
                                              } else {
                                                DocumentReference docRef =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'adminAnnounces')
                                                        .doc();
                                                AnnounceModel announce =
                                                    AnnounceModel(
                                                  date: Timestamp.fromDate(
                                                      DateTime.now()),
                                                  announcerEmail: Constants
                                                      .usersModel!.email,
                                                  announcerNumber: Constants
                                                      .usersModel!.phone,
                                                  announce: commentController
                                                      .text
                                                      .trim(),
                                                  announceAbout: aboutController
                                                      .text
                                                      .trim(),
                                                  announceId: docRef.id,
                                                );
                                                docRef
                                                    .set(announce.toJson())
                                                    .then((value) async {
                                                  snackBar(
                                                      context: context,
                                                      contentType:
                                                          ContentType.success,
                                                      title: 'Success',
                                                      body:
                                                          'Announce uploaded successfully');

                                                  await MainCubit.get(context)
                                                      .sendNotification(
                                                          context: context,
                                                          title: 'Announce!',
                                                          body:
                                                              'about : ${aboutController.text.trim()}',
                                                          receiver: 'users');
                                                  commentController.clear();
                                                  MainCubit.get(context)
                                                      .currentIndex = 0;
                                                  MainCubit.get(context)
                                                      .refresh();
                                                }).onError((error, stackTrace) {
                                                  print(error);
                                                  snackBar(
                                                      context: context,
                                                      contentType:
                                                          ContentType.failure,
                                                      title: 'Failure',
                                                      body:
                                                          'Announce is not uploaded');
                                                });
                                              }
                                            },
                                            color: Colors.blue,
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                side: BorderSide.none),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              child: Text(
                                                'Send',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
