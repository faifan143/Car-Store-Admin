import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carrent_admin/shared/componants/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/componants/constants.dart';
import '../../shared/remot_local/cach_hilper.dart';
import '../../shared/styles/icon_brokin.dart';
import '../signin/signin_screen.dart';
import 'cubitsignup/cubit.dart';
import 'cubitsignup/states.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  FocusNode _fullnameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _positionFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();

  bool hasImage = false;
  File? image;
  ImagePicker imagePicker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? url;
  bool _isloading = false;
  @override
  void dispose() {
    _animationController.dispose();
    SigningUpCubit.get(context).emailTextController.dispose();
    SigningUpCubit.get(context).passwordTextController.dispose();
    SigningUpCubit.get(context).phoneTextController.dispose();
    SigningUpCubit.get(context).fullNameTextController.dispose();
    SigningUpCubit.get(context).positionCPTextController.dispose();
    _fullnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _positionFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => SigningUpCubit(),
      child: BlocConsumer<SigningUpCubit, SiginUpState>(
          listener: (context, state) {
        if (state is SiginUpCreetSacsessState) {
          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
            CacheHelper.saveData(key: "userJobType", value: state.userJobType)
                .then((value) {
              navigateAndFinish(context, SignInScreen());
            });
          }).onError((error, stackTrace) {
            print("cacheHelper error : $error ");
          });
        }
      }, builder: (context, state) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CachedNetworkImage(
                imageUrl:
                    "https://media.istockphoto.com/photos/business-team-collaboration-discussing-working-analysis-with-data-picture-id1208208415?k=20&m=1208208415&s=612x612&w=0&h=z2IkXBvfe6W65VYpLfR0zBpf4z1xAQRiysdR-8kU6GE=",
                placeholder: (context, url) => Image.asset(
                  'assets/images/wallpaper.jpg',
                  fit: BoxFit.fill,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: FractionalOffset(_animation.value, 0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Already have an account?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: 'Login',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignInScreen(),
                                    ),
                                  ),
                            style: TextStyle(
                              color: Colors.blue.shade500,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  focusNode: _fullnameFocusNode,
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(_emailFocusNode),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    final RegExp nameExp =
                                        RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');

                                    if (!nameExp.hasMatch(value)) {
                                      return 'Please enter a valid name';
                                    }
                                  },
                                  controller: SigningUpCubit.get(context)
                                      .fullNameTextController,
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'Full name',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.pink.shade700,
                                      ),
                                    ),
                                    errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Stack(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: size.width * 0.24,
                                          height: size.width * 0.24,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 3,
                                              color: Colors.deepOrange,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                SigningUpCubit.get(context)
                                                            .imagePath !=
                                                        ''
                                                    ? SigningUpCubit.get(
                                                            context)
                                                        .imagePath!
                                                    : 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                                                fit: BoxFit.cover,
                                              )),
                                        )),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          SigningUpCubit.get(context)
                                              .pickAndUploadImage(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.deepOrange,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              IconBroken.Camera,
                                              size: 18,
                                              color: Colors.deepOrange,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _emailFocusNode,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passwordFocusNode),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email must not be empty';
                              }
                              final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                            },
                            controller:
                                SigningUpCubit.get(context).emailTextController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink.shade700,
                                ),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _passwordFocusNode,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_phoneFocusNode),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password must not be empty';
                              }
                              // Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character
                              final RegExp regex = RegExp(
                                  r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&\*~]).{8,}$');
                              if (!regex.hasMatch(value)) {
                                return '''Password must contain at least one uppercase letter, one lowercase letter
                                    , one digit, and one special character and be at least 8 characters long''';
                              }
                            },
                            obscureText: _obscureText,
                            controller: SigningUpCubit.get(context)
                                .passwordTextController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink.shade700,
                                ),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _phoneFocusNode,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_positionFocusNode),
                            validator: (phoneNumber) {
                              if (phoneNumber == null ||
                                  !phoneNumber.toString().startsWith('09') ||
                                  phoneNumber
                                          .toString()
                                          .replaceAll(RegExp(r'[^\d]'), '')
                                          .length !=
                                      10) {
                                return 'Please enter a valid phone number starting with 09 and with 10 digits';
                              }
                            },
                            controller:
                                SigningUpCubit.get(context).phoneTextController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              hintStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink.shade700,
                                ),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomSingleSelectField<String>(
                                  items: Constants.jobList,
                                  title: "Jobs",
                                  onSelectionDone: (value) {
                                    SigningUpCubit.get(context)
                                        .selectLevel(value);
                                  },
                                  itemAsString: (item) => item,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      SigningUpCubit.get(context).pickFile(),
                                  child: TextFormField(
                                    enabled: false,
                                    //textInputAction: TextInputAction.done,
                                    focusNode: _positionFocusNode,
                                    controller: SigningUpCubit.get(context)
                                        .picpdfcontroller,
                                    style: const TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: SigningUpCubit.get(context)
                                          .pickFileHint,
                                      hintStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      disabledBorder:
                                          const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.pink.shade700,
                                        ),
                                      ),
                                      errorBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _isloading
                        ? Center(
                            child: Container(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : MaterialButton(
                            color: Colors.deepOrange,
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.0)),
                            onPressed: () {
                              final RegExp phoneNumberRegex =
                                  RegExp(r'^09\d{8}$');
                              if (_signUpFormKey.currentState!.validate()) {
                                if (phoneNumberRegex.hasMatch(
                                    SigningUpCubit.get(context)
                                        .phoneTextController
                                        .text
                                        .trim())) {
                                  print('2');
                                  SigningUpCubit.get(context).signUp(context);
                                } else {
                                  snackBar(
                                      context: context,
                                      contentType: ContentType.warning,
                                      title: 'Watch out !!',
                                      body:
                                          '${SigningUpCubit.get(context).phoneTextController.text.trim()} is not a valid phone number');
                                }
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    'SignUp',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Please choose an option ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => CameraPage()));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () =>
                      SigningUpCubit.get(context).pickAndUploadImage(context),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.image_outlined,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void showJopDialog(size) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Jobs',
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
                        SigningUpCubit.get(context)
                            .positionCPTextController
                            .text = Constants.jobList[index];
                        Navigator.pop(context);
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
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic),
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
            ],
          );
        });
  }
}
