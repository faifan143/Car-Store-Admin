import 'package:carrent_admin/models/process_model.dart';
import 'package:carrent_admin/modules/chat/InChatScreen.dart';
import 'package:carrent_admin/shared/componants/componants.dart';
import 'package:carrent_admin/shared/componants/constants.dart';
import 'package:flutter/material.dart';

class ProcessDetails extends StatelessWidget {
  const ProcessDetails({Key? key, required this.processModel})
      : super(key: key);
  final ProcessModel processModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    """Process Details""",
                    style: Constants.arabicTheme.textTheme.headline1!
                        .copyWith(fontSize: 22, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Client Email : ",
                    style: Constants.arabicTheme.textTheme.headline2!
                        .copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    processModel.clientEmail!,
                    style: Constants.arabicTheme.textTheme.bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Client Number : ",
                    style: Constants.arabicTheme.textTheme.headline2!
                        .copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    processModel.clientNumber!,
                    style: Constants.arabicTheme.textTheme.bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Car : ",
                    style: Constants.arabicTheme.textTheme.headline2!
                        .copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    processModel.car!,
                    style: Constants.arabicTheme.textTheme.bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Car Image : ",
                    style: Constants.arabicTheme.textTheme.headline2!
                        .copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      navigateTo(
                          context, ShowImage(image: processModel.carImage!));
                    },
                    child: Text(
                      "click to show image",
                      style: Constants.arabicTheme.textTheme.bodyText1!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
