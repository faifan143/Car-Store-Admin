import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carrent_admin/modules/signin/cubitsignin/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/employeeModel.dart';
import '../../../models/siginup_model/users_model.dart';
import '../../../shared/componants/constants.dart';
import '../../../shared/componants/snackbar.dart';
import '../../map_tracking/map_tracking.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInetialState());

  static SignInCubit get(context) => BlocProvider.of(context);

  Future<void> userLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      emit(SignInLodingState());
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        if (user.emailVerified) {
          uId = await getUidByEmail(email);
          userJobType = await getJobTypeByEmail(email);

          if (uId != null) {
            DocumentSnapshot<Map<String, dynamic>> snapshot =
                await FirebaseFirestore.instance
                    .collection("companyUsers")
                    .doc(uId)
                    .get();
            if (snapshot.exists) {
              Map<String, dynamic> data = snapshot.data()!;
              Constants.usersModel = UsersModel.fromJson(data);
              Constants.employeeModel = EmployeeModel.fromJson(data);
              DocumentSnapshot<Map<String, dynamic>> snapshot2 =
                  await FirebaseFirestore.instance
                      .collection("companyUsers")
                      .doc(uId)
                      .get();
              if (snapshot2.exists) {
                Map<String, dynamic> data = snapshot2.data()!;
                if (Constants.employeeModel!.userType == "JobTypes.DELIVERY") {
                  if (Constants.employeeModel!.assignedProcessId != '') {
                    navigateAndFinish(context, const MapTracking());
                  } else {
                    snackBar(
                        context: context,
                        contentType: ContentType.failure,
                        title: "Failed logging in !!",
                        body: "There is No Process Assigned to you");
                    emit(SignInErorrState(
                        error: "There is No Process Assigned to you"));
                    return;
                  }
                }
                emit(SignInSacsessState(uId: uId!, jobType: userJobType!));
              } else {}
            } else {}
          } else {
            snackBar(
                context: context,
                contentType: ContentType.failure,
                title: "Failed logging in !!",
                body: "You are not an employee");
          }
        } else {
          snackBar(
              context: context,
              contentType: ContentType.failure,
              title: "Failed logging in !!",
              body:
                  "Email isn't verified , we are sending you another verification email ..");
          await user.sendEmailVerification();
        }
      } else {
        snackBar(
            context: context,
            contentType: ContentType.warning,
            title: "user-not-found",
            body: "No user found for that email.");
      }
    } on FirebaseAuthException catch (e) {
      // If the user is not found, display a snackbar message.
      if (e.code == 'user-not-found') {
        snackBar(
            context: context,
            contentType: ContentType.warning,
            title: "user-not-found",
            body: "No user found for that email.");
      }
      // If the password is incorrect, display a snackbar message.
      else if (e.code == 'wrong-password') {
        snackBar(
            context: context,
            contentType: ContentType.warning,
            title: "wrong-password",
            body: "Wrong password provided for that user.");
      }
      emit(SignInErorrState(error: onError.toString()));
      throw e;
    }
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  void changePasswordVisibitlity() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SignInIconState());
  }

  Future<String?> getUidByEmail(String email) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('companyUsers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.size > 0) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('uId')) {
          print("======UID======== ${data['uId']}");
          return data['uId'] as String;
        }
      }
      print("the document or 'uId' field does not exist");

      return null; // Return null if the document or 'uId' field does not exist
    } catch (e) {
      print('Error getting uid by email: $e');
      return null;
    }
  }

  Future<String?> getJobTypeByEmail(String email) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('companyUsers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.size > 0) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('userType')) {
          print("======jobType======== ${data['userType']}");
          return data['userType'] as String;
        }
      }
      print("the document or 'jobType' field does not exist");

      return null; // Return null if the document or 'uId' field does not exist
    } catch (e) {
      print('Error getting jobType by email: $e');
      return null;
    }
  }
}
