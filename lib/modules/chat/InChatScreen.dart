import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/MessageModel.dart';
import '../../models/siginup_model/users_model.dart';
import '../../shared/componants/constants.dart';

class InChatScreen extends StatelessWidget {
  InChatScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  UsersModel model;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(
                IconlyBroken.arrow_left,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                const Text(
                  "Company Chat",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: cubit.pickedImageLoading,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('companyChat') // Changed collection name
                          .orderBy('ntpDateTime', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return SingleChildScrollView(
                          reverse: true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 20,
                            ),
                            child: Column(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                MessageModel message =
                                    MessageModel.fromJson(data);

                                return Column(
                                  children: [
                                    if (uId == message.senderId)
                                      BuildMyMessage(
                                        messageModel: message,
                                      )
                                    else
                                      BuildContactMessage(
                                        messageModel: message,
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Add your input widget here
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      if (cubit.postImage != null)
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: FileImage(cubit.postImage!),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.removePostImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.lightBlue,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 5),
                      Container(
                        height: 61,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(35.0),
                                  boxShadow: [
                                    const BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                        color: Colors.grey)
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        autofocus: true,
                                        controller: cubit.messageTextCtrl,
                                        keyboardType: TextInputType.multiline,
                                        decoration: const InputDecoration(
                                            hintText: "Type Something...",
                                            hintStyle: TextStyle(
                                                color: Colors.blueAccent),
                                            border: InputBorder.none),
                                        onTap: () {
                                          cubit.emojiShowing = false;
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.photo_camera,
                                          color: Colors.blueAccent),
                                      onPressed: () {
                                        cubit.getPostImage();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            InkWell(
                              onTap: () {
                                if (cubit.messageTextCtrl.text.isNotEmpty ||
                                    cubit.postImage != null) {
                                  cubit.sendMessage(
                                    text: cubit.messageTextCtrl.text,
                                    postImage: cubit.postImageLink ?? '',
                                  );
                                  cubit.messageTextCtrl.clear();
                                  if (cubit.emojiShowing) {
                                    cubit.emojiStage(context);
                                  }
                                  cubit.removePostImage();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: const BoxDecoration(
                                    boxShadow: [
                                      const BoxShadow(
                                          offset: Offset(0, 3),
                                          blurRadius: 5,
                                          color: Colors.grey)
                                    ],
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BuildMyMessage extends StatelessWidget {
  BuildMyMessage({
    Key? key,
    required this.messageModel,
  }) : super(key: key);
  MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Do You Want To Delete It ?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('companyChat')
                        .doc(messageModel.messageId)
                        .delete();
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes")),
            ],
          ),
        );
      },
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
              ],
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientDarkColor,
                  AppColors.gradientLightColor,
                ],
              ),
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                  bottomStart: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  messageModel.senderEmail,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white60,
                  ),
                ),
              ),
              if (messageModel.postImage != '')
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShowImage(image: messageModel.postImage),
                          ));
                    },
                    child: Image(
                        height: 200,
                        image: NetworkImage(messageModel.postImage))),
              if (messageModel.postImage != '')
                const SizedBox(
                  height: 5,
                ),
              Text(
                messageModel.text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildContactMessage extends StatelessWidget {
  BuildContactMessage({
    Key? key,
    required this.messageModel,
  }) : super(key: key);
  MessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
            ],
            gradient: LinearGradient(
              colors: [Color(0xff0D324D), Color(0xff7F5A83)],
            ),
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomEnd: Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                messageModel.senderEmail,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white60,
                ),
              ),
            ),
            if (messageModel.postImage != '')
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShowImage(image: messageModel.postImage),
                        ));
                  },
                  child: Image(
                      height: 200,
                      image: NetworkImage(messageModel.postImage))),
            if (messageModel.postImage != '')
              const SizedBox(
                height: 5,
              ),
            Text(
              messageModel.text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({
    Key? key,
    required this.image,
  }) : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          child: Image(image: NetworkImage(image)),
        ),
      ),
    );
  }
}
