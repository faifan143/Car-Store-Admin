import 'package:carrent_admin/modules/admin_page/employee_control/add_cubit.dart';
import 'package:carrent_admin/modules/admin_page/employee_control/admin_states.dart';
import 'package:carrent_admin/shared/componants/reusable_button.dart';
import 'package:carrent_admin/shared/componants/reusable_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/componants/constants.dart';

class DeleteEmployeeScreen extends StatelessWidget {
  const DeleteEmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCubit, AdminStates>(listener: (context, state) {
      if (state is EmployeeCrDeleteSuccessState) {
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
                          "Fire Employee",
                          style: Constants.arabicTheme.textTheme.headline1!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ReusableFormField(
                      isPassword: false,
                      icon: const Icon(Icons.email_outlined),
                      checkValidate: (value) {
                        if (value!.isEmpty) {
                          return 'Email must not be empty';
                        }
                        final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                      },
                      controller: cubit.deleteEmailController,
                      hint: "Enter email",
                      label: "email",
                      keyType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    ReUsableButton(
                      onPressed: () async {
                        if (cubit.formState.currentState!.validate()) {
                          await cubit.deleteDocumentByEmail();
                        }
                      },
                      height: 25,
                      radius: 20,
                      text: "Fire Employee",
                      colour: Colors.redAccent,
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
