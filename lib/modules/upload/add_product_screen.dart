import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/componants/componants.dart';
import '../../shared/styles/icon_brokin.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = MainCubit.get(context);
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: cubit.addingProductLoading,
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Add images',
                          style: TextStyle(fontSize: 18, fontFamily: 'jannah'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultButton(
                          width: 120,
                          background: Colors.blueAccent,
                          isUpperCase: false,
                          function: () {
                            cubit.getMultiImages();
                          },
                          text: 'Add Images',
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (cubit.selectedImages.isNotEmpty)
                          SizedBox(
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  buildImageItem(context, index),
                              separatorBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(height: 1, color: Colors.grey),
                              ),
                              itemCount: cubit.selectedImages.length,
                            ),
                          ),
                        if (cubit.selectedImages.isEmpty)
                          SizedBox(
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => Container(
                                height: 150,
                                width: 150,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.amber.shade100,
                                ),
                                child: const Icon(
                                  IconBroken.Image_2,
                                  size: 50,
                                  color: Colors.black45,
                                ),
                              ),
                              separatorBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(height: 1, color: Colors.grey),
                              ),
                              itemCount: 5,
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Add Description',
                          style: TextStyle(fontSize: 18, fontFamily: 'jannah'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: defaultFormField(
                                      controller: cubit.speedController,
                                      type: TextInputType.number,
                                      label: 'Speed',
                                      prefix: Icons.speed_rounded,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Missing field';
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: defaultFormField(
                                      controller: cubit.doorController,
                                      type: TextInputType.number,
                                      label: 'Doors',
                                      prefix: Icons.door_sliding_outlined,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Missing field';
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: defaultFormField(
                                      controller: cubit.seatsController,
                                      type: TextInputType.number,
                                      label: 'Seats',
                                      prefix: Icons.chair,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Missing field';
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: defaultFormField(
                                      controller: cubit.tankController,
                                      type: TextInputType.number,
                                      label: 'Tank Capacity',
                                      prefix: Icons.local_gas_station_outlined,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Missing field';
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: defaultFormField(
                                      controller: cubit.colorController,
                                      type: TextInputType.text,
                                      label: 'Color',
                                      prefix: Icons.color_lens,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Missing field';
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: defaultFormField(
                                      controller: cubit.priceController,
                                      type: TextInputType.number,
                                      label: 'Price',
                                      prefix: Icons.attach_money_outlined,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Missing field';
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: defaultFormField(
                                      controller: cubit.branchController,
                                      type: TextInputType.text,
                                      label: 'Branch',
                                      prefix: Icons.car_crash_outlined,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Missing field';
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: defaultFormField(
                                      controller: cubit.modelController,
                                      type: TextInputType.text,
                                      label: 'Model Year',
                                      prefix: Icons.car_crash_outlined,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Missing field';
                                        }
                                      },
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
                        const Text(
                          'Additional Details',
                          style: TextStyle(fontSize: 18, fontFamily: 'jannah'),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: cubit.discriptionController,
                          maxLines: 4,
                          maxLength: 200,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return "Missing Field";
                          },
                        ),
                        const Text(
                          'Statues Car',
                          style: TextStyle(fontSize: 18, fontFamily: 'jannah'),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                cubit.changeManualOrAutomatic(false);
                                print(cubit.isManual);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: !cubit.isManual
                                      ? Colors.blue.shade300
                                      : Colors.grey.shade100,
                                ),
                                child: const Text('Automatic'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'OR',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                cubit.changeManualOrAutomatic(true);
                                print(cubit.isManual);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: cubit.isManual
                                      ? Colors.blue.shade300
                                      : Colors.grey.shade100,
                                ),
                                child: const Text('Manual'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                cubit.changeDieselOrFuel(true);
                                print(cubit.isDiesel);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: cubit.isDiesel
                                      ? Colors.blue.shade300
                                      : Colors.grey.shade100,
                                ),
                                child: const Text('Diesel'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'OR',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                cubit.changeDieselOrFuel(false);
                                print(cubit.isDiesel);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: !cubit.isDiesel
                                      ? Colors.blue.shade300
                                      : Colors.grey.shade100,
                                ),
                                child: const Text('Fuel'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            defaultButton(
                              function: () async {
                                if (formState.currentState!.validate()) {
                                  cubit
                                      .uploadProductToFirebase(
                                    imageFiles: cubit.selectedImages,
                                    isUsed: false,
                                    context: context,
                                  )
                                      .then((value) {
                                    toast(
                                        msg: 'Added Successfully',
                                        state: ToastState.SUCCESS);
                                  }).catchError((error) {
                                    toast(
                                        msg: 'Failed to Add',
                                        state: ToastState.ERROR);
                                  });
                                }
                              },
                              text: 'Upload to new',
                              isUpperCase: false,
                              width: 150,
                            ),
                            const Text(
                              'OR',
                              style: TextStyle(color: Colors.grey),
                            ),
                            defaultButton(
                              function: () {
                                if (formState.currentState!.validate()) {
                                  cubit
                                      .uploadProductToFirebase(
                                    context: context,
                                    imageFiles: cubit.selectedImages,
                                    isUsed: true,
                                  )
                                      .then((value) {
                                    formState.currentState?.reset();
                                    cubit.clearSelectedImages();
                                    toast(
                                        msg: 'Added Successfully',
                                        state: ToastState.SUCCESS);
                                  }).catchError((error) {
                                    print(
                                        "======adding error============= $error");
                                    toast(
                                        msg: 'Failed to Add',
                                        state: ToastState.ERROR);
                                  });
                                }
                              },
                              text: 'Upload to used',
                              isUpperCase: false,
                              width: 150,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildImageItem(context, index) {
    var cubit = MainCubit.get(context);
    return InkWell(
      onTap: () {},
      onLongPress: () {
        cubit.removeOfSelectedImages(index);
      },
      child: Container(
        height: 150,
        width: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.amber.shade100,
        ),
        child: Image.file(
          cubit.selectedImages[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
