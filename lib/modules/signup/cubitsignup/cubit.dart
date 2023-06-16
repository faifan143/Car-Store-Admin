import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carrent_admin/layout/cubit/cubit.dart';
import 'package:carrent_admin/models/employeeModel.dart';
import 'package:carrent_admin/modules/signup/cubitsignup/states.dart';
import 'package:carrent_admin/shared/componants/job_types.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/siginup_model/users_model.dart';
import '../../../shared/componants/snackbar.dart';

final firebaseStorage = firebase_storage.FirebaseStorage.instance;

class SigningUpCubit extends Cubit<SiginUpState> {
  SigningUpCubit() : super(SiginUpInetialState());

  static SigningUpCubit get(context) => BlocProvider.of(context);
  late UsersModel model;
  late TextEditingController emailTextController =
      TextEditingController(text: '');
  late TextEditingController passwordTextController =
      TextEditingController(text: '');
  late TextEditingController fullNameTextController =
      TextEditingController(text: '');
  late TextEditingController phoneTextController =
      TextEditingController(text: '');

  late TextEditingController positionCPTextController =
      TextEditingController(text: '');

  late TextEditingController picpdfcontroller = TextEditingController(text: '');

  Future<void> checkEmailAndPhoneAvailability(
      String email, String phone) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('companyUsers')
        .where('email', isEqualTo: email)
        .where('phone', isEqualTo: phone)
        .get();

    if (snapshot.docs.isNotEmpty) {}
  }

  Future<void> userSigningUp({required BuildContext context}) async {
    emit(SiginUpLodingState());
    if (imagePath != null || imagePath!.isNotEmpty) {
      if (filePath != null && filePath!.isNotEmpty) {
        // Check if user with the given email already exists
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailTextController.text.trim(),
                  password: passwordTextController.text.trim());
          if (userCredential.user != null &&
              userCredential.user!.emailVerified) {
            emit(SiginUpErorrState(
                error:
                    'User with this email already exists. Please try again.'));
            return;
          }
        } on FirebaseAuthException catch (e) {
          if (e.code != 'user-not-found') {
            emit(SiginUpErorrState(error: e.toString()));
            return;
          }
        }
        // Create new user and send verification email
        await secureUserCreation(context);
      } else {
        snackBar(
            context: context,
            title: "Ops !",
            body: "the pdf file isn't uploaded yet ..",
            contentType: ContentType.warning);
      }
    } else {
      snackBar(
          context: context,
          title: "Ops !",
          body: "the image isn't uploaded yet ..",
          contentType: ContentType.warning);
    }
  }

  Future<void> userCreate(String uId) async {
    model = UsersModel(
      email: emailTextController.text.trim(),
      name: fullNameTextController.text.trim(),
      phone: phoneTextController.text.trim(),
      uId: uId,
      pdfFile: filePath,
      image: imagePath,
      userType: selectedJob,
    );
    FirebaseFirestore.instance
        .collection('companyUsers')
        .doc(uId)
        .set(model.tomap())
        .then((value) {
      emit(SiginUpCreetSacsessState(uId: uId, userJobType: selectedJob));
    }).catchError((error) {
      print(error.toString());
      emit(SiginUpCreetErorrState());
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_off_outlined;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SiginUpIconState());
  }

  String pickFileHint = 'pick a file';
  String filePath = '';
  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      filePath = result.files.single.path!;
      final file = File(filePath!);
      try {
        final userEmail = emailTextController.text.trim();
        if (userEmail.isNotEmpty) {
          // Upload the file to Firebase Storage
          final storageRef =
              firebaseStorage.ref('users/$userEmail/${file.path}');
          await storageRef.putFile(file);

          // Retrieve the download URL of the uploaded file
          final downloadURL = await storageRef.getDownloadURL();

          // Update the filePath variable with the download URL
          filePath = downloadURL;
          pickFileHint = 'file is picked successfully';
          emit(FilePickerSuccess());
        } else {
          emit(FilePickerError('User email is empty'));
        }
      } catch (e) {
        emit(FilePickerError('Error uploading file'));
      }
    } else {
      emit(FilePickerError('User canceled the picker'));
    }
  }

  String imagePath = '';

  Future<void> pickAndUploadImage(BuildContext context) async {
    final imagePicker = ImagePicker();
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text('Camera'),
          ),
        ],
      ),
    );

    if (imageSource != null) {
      final pickedImage = await imagePicker.pickImage(source: imageSource);
      if (pickedImage != null) {
        final userEmail = emailTextController.text.trim();

        if (userEmail.isNotEmpty) {
          final file = File(pickedImage.path);

          try {
            final storageRef =
                firebaseStorage.ref('users/$userEmail/${file.path}');
            await storageRef.putFile(file);

            final downloadURL = await storageRef.getDownloadURL();

            imagePath = downloadURL;
            emit(ImagePickerSuccess());
          } catch (e) {
            emit(ImagePickerError('Error uploading image'));
          }
        } else {
          emit(ImagePickerError('User email is empty'));
        }
      } else {
        emit(ImagePickerError('No image selected'));
      }
    } else {
      emit(ImagePickerError('Image source not selected'));
    }
  }

  String selectedJob = '';
  selectLevel(String level) {
    switch (level) {
      case "Admin":
        selectedJob = JobTypes.ADMIN.toString();
        break;
      case "Employee":
        selectedJob = JobTypes.EMPLOYEE.toString();
        break;
      case "Delivery":
        selectedJob = JobTypes.DELIVERY.toString();
        break;
    }
    print(selectedJob);
  }

  Future<bool> isAdminExists() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('companyUsers')
        .where('userType', isEqualTo: 'JobTypes.ADMIN')
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> signUp(BuildContext context) async {
    emit(SiginUpLodingState());
    if (imagePath != null &&
        imagePath!.isNotEmpty &&
        filePath != null &&
        filePath.isNotEmpty &&
        selectedJob != '') {
      if (selectedJob == "JobTypes.ADMIN") {
        if (await isAdminExists() == false) {
          await secureUserCreation(context);
          DocumentReference docRef =
              FirebaseFirestore.instance.collection("companyUsers").doc();
          EmployeeModel employeeModel = EmployeeModel(
              name: fullNameTextController.text.trim(),
              email: emailTextController.text.trim(),
              phone: phoneTextController.text.trim(),
              uId: docRef.id,
              image: imagePath,
              userType: selectedJob,
              pdfFile: filePath,
              isAvailable: true,
              joiningDate: '',
              assignedProcessId: '',
              assignedProcessLocation: '',
              password: passwordTextController.text.trim(),
              attendanceSchedule: [],
              daysOfWork: '0');
          docRef.set(employeeModel.toMap());
        } else {
          print("admin already exists");
          snackBar(
              context: context,
              contentType: ContentType.failure,
              title: "Ops",
              body: "Admin already exists");
        }
      } else {
        try {
          if (await isEmailUsed(emailTextController.text.trim()) == false) {
            DocumentReference docRef =
                FirebaseFirestore.instance.collection("hiringRequests").doc();
            EmployeeModel employeeModel = EmployeeModel(
                name: fullNameTextController.text.trim(),
                email: emailTextController.text.trim(),
                phone: phoneTextController.text.trim(),
                uId: docRef.id,
                image: imagePath,
                userType: selectedJob,
                pdfFile: filePath,
                isAvailable: true,
                joiningDate: '',
                assignedProcessId: '',
                assignedProcessLocation: '',
                password: passwordTextController.text.trim(),
                attendanceSchedule: [],
                daysOfWork: '0');
            docRef.set(employeeModel.toMap());
            snackBar(
              context: context,
              title: "Congrats !",
              body: "Your Request Has Been Uploaded",
              contentType: ContentType.success,
            );
            await MainCubit.get(context).sendNotification(
                context: context,
                title: 'Make A Decission',
                body: 'Hiring Application',
                receiver: 'admin');
            emit(SiginUpCreetSacsessState(
                uId: docRef.id, userJobType: selectedJob));
          } else {
            snackBar(
              context: context,
              title: "Ops !",
              body: "Your Given Email is Used",
              contentType: ContentType.failure,
            );
          }
        } catch (e) {
          print(e);
        }
      }
    } else {
      print("some fields are empty");
      snackBar(
          context: context,
          contentType: ContentType.warning,
          title: "Watch out !!",
          body: "some fields are empty");
    }
  }

  Future<bool> isEmailUsed(String email) async {
    final hiringRequestsSnapshot = await FirebaseFirestore.instance
        .collection('hiringRequests')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (hiringRequestsSnapshot.docs.isNotEmpty) {
      return true;
    }

    final companyUsersSnapshot = await FirebaseFirestore.instance
        .collection('companyUsers')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return companyUsersSnapshot.docs.isNotEmpty;
  }

  Future<void> secureUserCreation(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text.trim(),
              password: passwordTextController.text.trim());
      userCredential.user!.sendEmailVerification();
      userCreate(userCredential.user!.uid);
      snackBar(
          context: context,
          title: "Congrats !",
          body: "Signed up successfully check your email to verify it ..",
          contentType: ContentType.success);
      emit(SiginUpCreetSacsessState(
          uId: userCredential.user!.uid, userJobType: selectedJob));
    } on FirebaseAuthException catch (e) {
      print(e);
      emit(SiginUpErorrState(error: e.toString()));
    }
  }
}
