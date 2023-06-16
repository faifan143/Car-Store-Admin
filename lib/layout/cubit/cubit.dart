import 'dart:convert';
import 'dart:io';

import 'package:carrent_admin/layout/cubit/states.dart';
import 'package:carrent_admin/models/car_model/car_model.dart';
import 'package:carrent_admin/modules/admin_page/admin_page.dart';
import 'package:carrent_admin/shared/remot_local/cach_hilper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firestore_storage;
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ntp/ntp.dart';

import '../../models/MessageModel.dart';
import '../../models/employeeModel.dart';
import '../../models/menue_item.dart';
import '../../modules/delivery/delivery_screen.dart';
import '../../modules/drawer/drawer_screen.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/offers/offers_screen.dart';
import '../../modules/payment_page/payment_page.dart';
import '../../modules/signin/signin_screen.dart';
import '../../modules/upload/add_product_screen.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(InitialState());

  static MainCubit get(context) => BlocProvider.of(context);
  MenuIteme currentItem = MenuItems.Home;

  Future<void> initializeCubit() async {
    messageTextCtrl = TextEditingController();
    await getEmployeeData();
    await resetDaysOfWorkIfFirstDayOfMonth();
    await getNotification();
    generateQRCode();
  }

  refresh() {
    emit(ImageLoadingState());
  }

  Future<void> getEmployeeData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("companyUsers")
        .doc(uId)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      Constants.employeeModel = EmployeeModel.fromJson(data);
      emit(ImageLoadingState());
    } else {
      print("Failed GETTING The Employee");
    }
  }

  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    AddProductScreen(),
    const OffersScreen(),
    const DeliveryScreen(),
    AdminPage(),
  ];
  List<String> titles = [
    'Home',
    'Add product',
    'Add offers',
    'Delivers',
    'Admin Panel',
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void changeDrawer(MenuIteme index) {
    currentItem = index;
    emit(ChangeDrawerState());
  }

  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.Home:
        return const PaymentPage();
      default:
        return const OffersScreen();
    }
  }

  bool isManual = false;

  void changeManualOrAutomatic(bool isManual) {
    this.isManual = isManual;
    emit(ChangeContainerState());
  }

  bool isDiesel = false;

  void changeDieselOrFuel(bool isDiesel) {
    this.isDiesel = isDiesel;
    emit(ChangeContainerFState());
  }

  //Pick multi images
  List<File> selectedImages = [];
  final pickerMultiImages = ImagePicker();

  Future getMultiImages() async {
    final pickedFile = await pickerMultiImages.pickMultiImage(
      imageQuality: 100,
      maxWidth: 1050,
      maxHeight: 1050,
    );
    List<XFile> xfilePick = pickedFile;

    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
      }
      emit(MultiImagePickedSuccessState());
    } else {
      toast(msg: 'Nothing is selected', state: ToastState.ERROR);
    }
  }

  void removeOfSelectedImages(int index) {
    selectedImages.remove(selectedImages[index]);
    emit(MultiImagePickedDeletedState());
    toast(msg: 'Deleted successfully', state: ToastState.SUCCESS);
  }

  void clearSelectedImages() {
    selectedImages.clear();
    emit(MultiImagePickedDeletedState());
    toast(msg: 'Deleted successfully', state: ToastState.SUCCESS);
  }

  Future<List<String>> uploadImagesToFirebase({
    required List<File> imageFiles,
    required String carId,
  }) async {
    List<String> downloadURLs = [];
    print("11");
    for (var file in imageFiles) {
      print("12");
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('Cars/$carId/${Uri.file(file.path).pathSegments.last}');
      print("13");
      try {
        await ref.putFile(file);
        print("14");
        String downloadURL = await ref.getDownloadURL();
        print("15");
        downloadURLs.add(downloadURL);
        print("16");
      } catch (error) {
        print('Error uploading image: $error');
        changeAddingProductLoading(false);
        // Handle or log the error as needed
      }
    }
    print("17");
    return downloadURLs;
  }

  var speedController = TextEditingController();
  var doorController = TextEditingController();
  var seatsController = TextEditingController();
  var discriptionController = TextEditingController();
  var colorController = TextEditingController();
  var priceController = TextEditingController();
  var branchController = TextEditingController();
  var modelController = TextEditingController();
  var tankController = TextEditingController();

  Future<void> uploadProductToFirebase({
    required BuildContext context,
    required List<File> imageFiles,
    required bool isUsed,
    String? carId,
  }) async {
    final today = DateTime.now();
    final date =
        '${today.year}-${today.month}-${today.day} , ${today.hour}-${today.minute}-${today.second} ';
    try {
      changeAddingProductLoading(false);
      print(
          "=================\n=============\n============ started loading =================\n=============\n============");
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('cars');
      print("1");
      DocumentReference docRef =
          carId != null ? collectionRef.doc(carId) : collectionRef.doc();
      print("2");
      List<dynamic> downloadURLs = await uploadImagesToFirebase(
          imageFiles: imageFiles, carId: carId ?? docRef.id);
      print("3");
      String? adminPhone = await getAdminPhone();
      print(' admin phone : \n $adminPhone');
      CarModel carModel = CarModel(
        carId: carId ?? docRef.id,
        imageFiles: downloadURLs,
        color: colorController.text.trim(),
        branch: branchController.text.trim(),
        details: discriptionController.text.trim(),
        doors: doorController.text.trim(),
        price: priceController.text.trim(),
        seats: seatsController.text.trim(),
        speed: speedController.text.trim(),
        isUsed: isUsed,
        isDiesel: isDiesel,
        isManual: isManual,
        modelYear: modelController.text.trim(),
        tankCapacity: tankController.text.trim(),
        isOffered: false,
        offerExpirationDate: '',
        offerPercentage: '0',
        priceAfterOffer: priceController.text.trim(),
        date: date,
        adminNumber: adminPhone,
        carStatus: 'CarStatus.AVAILABLE',
      );
      print("4");
      await docRef.set(carModel.toJson());
      print("5");
      clearSelectedImages();
      speedController.clear();
      doorController.clear();
      seatsController.clear();
      discriptionController.clear();
      colorController.clear();
      priceController.clear();
      branchController.clear();
      modelController.clear();
      tankController.clear();
      changeAddingProductLoading(true);
      print(
          "=================\n=============\n============ finished loading =================\n=============\n============");
      await sendNotification(
          context: context,
          title: 'knock knock',
          body: 'new product',
          receiver: 'users');
      currentIndex = 0;
      navigateAndFinish(context, PaymentPage());
    } catch (error) {
      print('Error uploading product: $error');
      changeAddingProductLoading(false);

      // Handle or log the error as needed
    }
  }

  Future<void> updateProductInFirebase(
      {required List<File> imageFiles,
      required CarModel carModel,
      required BuildContext context}) async {
    try {
      final today = DateTime.now();
      final date =
          '${today.year}-${today.month}-${today.day} , ${today.hour}-${today.minute}-${today.second} ';
      changeAddingProductLoading(false);
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('cars');
      DocumentReference docRef = carModel.carId != null
          ? collectionRef.doc(carModel.carId)
          : collectionRef.doc();
      List<dynamic> downloadURLs = await uploadImagesToFirebase(
          imageFiles: imageFiles, carId: carModel.carId ?? docRef.id);
      carModel.imageFiles!.addAll(downloadURLs);
      carModel.date != date;
      await docRef.update(carModel.toJson());

      clearSelectedImages();

      changeAddingProductLoading(true);
      currentIndex = 0;
      await sendNotification(
          context: context,
          title: 'knock knock',
          body: 'new offer',
          receiver: 'users');
      navigateAndFinish(context, PaymentPage());
    } catch (error) {
      print('Error uploading product: $error');
      changeAddingProductLoading(false);

      // Handle or log the error as needed
    }
  }

  bool pickedImageLoading = false;

  changeImageLoadingState() {
    pickedImageLoading = !pickedImageLoading;
    emit(changeImageLoadingState());
  }

  bool emojiShowing = false;
  var focusNode = FocusNode();

  // Function to toggle the emoji showing state
  void emojiStage(BuildContext context) {
    emojiShowing = !emojiShowing;
    if (emojiShowing) {
      focusNode = FocusNode();
    } else {
      FocusScope.of(context).requestFocus(focusNode);
    }
    emit(changeImageLoadingState());
  }

  TextEditingController messageTextCtrl = TextEditingController();

  // Sends a message to a user with the given receiverId, text and postImage
  sendMessage({
    required String text,
    required String postImage,
  }) async {
    // Get the current time from NTP server
    final myTime = await NTP.now();
    final ntpOffset = await NTP.getNtpOffset(localTime: DateTime.now());
    // Add NTP offset to the current time to get the correct time
    final ntpTime = myTime.add(Duration(milliseconds: ntpOffset));
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('companyChat').doc();
    // Create a MessageModel with the message information
    final messageModel = MessageModel(
      text: text,
      ntpDateTime: ntpTime.toString(),
      senderId: uId!,
      postImage: postImage,
      senderEmail: Constants.usersModel!.email!,
      messageId: docRef.id,
    );
    docRef.set(messageModel.toMap());
  }

  // للتعامل مع صور المحادثات
  File? postImage;
  String? postImageLink;
  var postImagePicker = ImagePicker();

  // This function allows the user to pick an image from their gallery and upload it to Firebase storage
  Future<void> getPostImage() async {
    changePickedImageLoadingState();
    // Prompt the user to pick an image from their gallery
    final pickedFile =
        await postImagePicker.getImage(source: ImageSource.gallery);

    // If an image was picked
    if (pickedFile != null) {
      // Set postImage to the picked image
      postImage = File(pickedFile.path);

      // If postImage is not null
      if (postImage != null) {
        // Upload the image to Firebase storage
        firestore_storage.FirebaseStorage.instance
            .ref()
            .child("messages/${Uri.file(postImage!.path).pathSegments.last}")
            .putFile(postImage!)
            .then((value) {
          // When the upload is complete, get the download URL of the image
          return value.ref.getDownloadURL().then((imgLink) {
            // Set postImageLink to the download URL of the image
            postImageLink = imgLink;
            changePickedImageLoadingState();
          });
        }).catchError((onError) {
          changePickedImageLoadingState();
        });
      }
    } else {
      // If an image was not picked, set pickedImageLoading to false
      changePickedImageLoadingState();
    }
  }

  changePickedImageLoadingState() {
    pickedImageLoading = !pickedImageLoading;
    emit(ImageLoadingState());
  }

  void removePostImage() {
    postImage = null;
    postImageLink = '';
    emit(ImageLoadingState());
  }

  String qrCodeData = '';
  void generateQRCode() {
    final today = DateTime.now();
    final date = '${today.year}-${today.month}-${today.day}';
    qrCodeData = date;
  }

  Future<void> readQRCodeAndAddToAttendance() async {
    // Scan the QR code
    String qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#FF0000', // Color of the scanning animation
      'Cancel', // Text for the cancel button
      false, // Whether to show the flash icon
      ScanMode.QR, // Scan mode (QR code in this case)
    );
    // If the QR code scanning is successful and a value is obtained
    if (qrCode != '-1') {
      try {
        // Get the Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        // Create a reference to the document
        DocumentReference userRef =
            firestore.collection('companyUsers').doc(uId);
        // Update the attendance array field with the scanned QR code value
        await userRef.update({
          'attendance': FieldValue.arrayUnion([qrCode])
        });
        print('QR code value added to attendance array: $qrCode');
      } catch (e) {
        print('Error adding QR code value to attendance array: $e');
      }
    } else {
      print('QR code scanning cancelled');
    }
  }

  void logoutAndNavigateToSignInScreen(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Set uId to null or any desired value indicating user is logged out
      uId = null;
      CacheHelper.removData(key: "uId").then((value) {
        CacheHelper.removData(key: "userJobType").then((value) async {
          await FirebaseMessaging.instance.unsubscribeFromTopic('employee');
          await FirebaseMessaging.instance.unsubscribeFromTopic('admin');
          await FirebaseMessaging.instance
              .unsubscribeFromTopic(Constants.usersModel!.uId!);
          Constants.usersModel = null;
          Constants.employeeModel = null;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
            (route) => true,
          );
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error logging out. Please try again.');
      print(e);
    }
  }

  getNotification() async {
    if (userJobType == "JobTypes.ADMIN") {
      await FirebaseMessaging.instance.subscribeToTopic("admin");
    }
    await FirebaseMessaging.instance.subscribeToTopic("all");
    FirebaseMessaging.onMessage.listen((event) {});
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  }

  bool addingProductLoading = false;
  changeAddingProductLoading(bool finished) {
    addingProductLoading = !addingProductLoading;
    finished ? emit(ProductUploadedSuccessfully()) : emit(ImageLoadingState());
  }

  int activeIndex = 0;
  void changecarouseloption(int? index) {
    activeIndex = index!;
    emit(ChangeCarouselOptionState());
  }

  DateTime dateTime = DateTime.now();
  Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<void> scanQRCode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color of the scan view background
      'Cancel', // Text for the cancel button
      false, // Show flash icon
      ScanMode.QR, // Scan mode: QR, BARCODE, or DEFAULT
    );

    if (barcodeScanResult != '-1') {
      if (!Constants.employeeModel!.attendanceSchedule!
          .contains(barcodeScanResult)) {
        Constants.employeeModel!.attendanceSchedule!.add(barcodeScanResult);
        Constants.employeeModel!.daysOfWork =
            "${int.parse(Constants.employeeModel!.daysOfWork!) + 1}";
        FirebaseFirestore.instance
            .collection('companyUsers')
            .doc(Constants.employeeModel!.uId)
            .update(Constants.employeeModel!.toMap())
            .then((value) {
          print(
              'Scanned QR code: $barcodeScanResult ------------ \n ${Constants.employeeModel!.email}');
          return;
        });
      }
      print("failed");
      // Perform additional actions based on the scanned result
    } else {
      // QR code scan was cancelled by the user
      print('QR code scanning cancelled');
    }
    emit(ImageLoadingState());
  }

  Future<void> resetDaysOfWorkIfFirstDayOfMonth() async {
    try {
      DateTime currentDate = DateTime.now();
      bool isFirstDayOfMonth = currentDate.day == 1;

      if (!isFirstDayOfMonth) {
        print('Today is not the first day of the month. Skipping reset.');
        return;
      }

      CollectionReference companyUsersCollection =
          FirebaseFirestore.instance.collection('companyUsers');

      QuerySnapshot querySnapshot = await companyUsersCollection.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await companyUsersCollection
            .doc(documentSnapshot.id)
            .update({'daysOfWork': '0'});
      }

      print('Reset daysOfWork field successfully!');
    } catch (e) {
      print('Error resetting daysOfWork field: $e');
    }
  }

  Future<String?> getAdminPhone() async {
    // Get a reference to the Firestore collection
    final CollectionReference companyUsersCollection =
        FirebaseFirestore.instance.collection('companyUsers');

    // Create a query to filter documents where userType equals to JobTypes.ADMIN
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await companyUsersCollection
            .where('userType', isEqualTo: 'JobTypes.ADMIN')
            .limit(1)
            .get() as QuerySnapshot<Map<String, dynamic>>;

    // Check if any documents match the query
    if (snapshot.docs.isNotEmpty) {
      // Retrieve the phone field from the first matching document
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          snapshot.docs.first;
      final String? phone = documentSnapshot.data()!['phone'] as String?;
      return phone;
    }

    return null; // Return null if no matching document is found
  }

  Future<void> sendNotification({
    required BuildContext context,
    required String title,
    required String body,
    required String receiver,
  }) async {
    await http
        .post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAaAxG8lQ:APA91bFdB2jlnFxENfRE230BV6qU42tVn7jevPN_6ie3a_scggfB3homZXn-bZ7pt6tysec94Ug3SOFqPsatIy4ZwmVzU2MtENtgWtFFvxy_wT7ClXSueyFOK7_QrFzh5ZzDR5JioWra',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': {},
          'to': "/topics/$receiver",
        },
      ),
    )
        .then((value) async {
      print(value.statusCode);
      print("=========done=========");
      if (value.statusCode == 200) {
        print("=========notification send=========");
      } else {
        print("=========notification failed=========");
        print("=========false=========");
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
