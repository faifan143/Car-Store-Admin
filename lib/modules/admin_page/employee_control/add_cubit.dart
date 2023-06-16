import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carrent_admin/models/employeeModel.dart';
import 'package:carrent_admin/modules/admin_page/employee_control/admin_states.dart';
import 'package:carrent_admin/shared/componants/job_types.dart';
import 'package:carrent_admin/shared/componants/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AddCubit extends Cubit<AdminStates> {
  AddCubit() : super(InitialState());

  static AddCubit get(context) => BlocProvider.of(context);
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;

  late TextEditingController deleteEmailController;

  String selectedJobType = '';
  initializeAddCubit() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    deleteEmailController = TextEditingController();
  }

  selectJobType(String jobType) {
    switch (jobType) {
      case "Employee":
        selectedJobType = JobTypes.EMPLOYEE.toString();
        break;
      case "Delivery":
        selectedJobType = JobTypes.DELIVERY.toString();
        break;
    }
  }

  late EmployeeModel employeeModel;
  createEmployee() async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    // Query the collection to check for existing documents
    QuerySnapshot existingDocuments = await FirebaseFirestore.instance
        .collection('companyUsers')
        .where('email', isEqualTo: email)
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: phone)
        .where('userType', isEqualTo: selectedJobType)
        .get();

    if (existingDocuments.docs.isNotEmpty) {
      snackBar(
          contentType: ContentType.failure,
          title: "Error !!",
          body: 'Employee already exists');
      // Document with the specified details already exists
      emit(EmployeeCreateErrorState(error: 'Employee already exists'));
      return;
    }

    // Create a new document
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('companyUsers').doc();
    DateTime now = DateTime.now();
    String currentDate = "${now.year}-${now.month}-${now.day}";

    employeeModel = EmployeeModel(
        email: email,
        name: name,
        phone: phone,
        uId: documentReference.id,
        pdfFile: '',
        image: '',
        userType: selectedJobType,
        isAvailable: true,
        joiningDate: currentDate,
        assignedProcessId: '',
        assignedProcessLocation: '',
        password: '',
        attendanceSchedule: [],
        daysOfWork: '0');

    documentReference.set(employeeModel.toMap()).then((value) {
      emit(EmployeeCreateSuccessState());
    }).catchError((error) {
      snackBar(
          contentType: ContentType.failure,
          title: "Error !!",
          body: 'Failed to create employee');
      emit(EmployeeCreateErrorState(error: 'Failed to create employee'));
    });
  }

  Future<void> deleteDocumentByEmail() async {
    print("1deleete");
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('companyUsers')
        .where('email', isEqualTo: deleteEmailController.text.trim())
        .get();
    print("2deleete");
    if (snapshot.docs.isNotEmpty) {
      // Delete the first matching document
      print("3deleete");
      await snapshot.docs.first.reference.delete();
      print("4deleete");
      sendEmail(
          email: deleteEmailController.text.trim(),
          subject: 'Firing',
          text: 'You Are Fired');
      emit(EmployeeCrDeleteSuccessState());
    } else {
      emit(EmployeeDeleteErrorState(
          error:
              'Document with email ${deleteEmailController.text.trim()} not found'));
    }
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
