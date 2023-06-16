import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/car_model/car_model.dart';
import '../../shared/componants/componants.dart';
import '../../shared/styles/icon_brokin.dart';

class UpdateProductScreen extends StatefulWidget {
  final CarModel? carModel;

  UpdateProductScreen({Key? key, this.carModel}) : super(key: key);

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  var discriptionController = TextEditingController();
  var colorController = TextEditingController();
  var priceController = TextEditingController();
  final formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.carModel != null) {
      discriptionController.text = widget.carModel!.details!;
      colorController.text = widget.carModel!.color!;
      priceController.text = widget.carModel!.price!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
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
                                      controller: colorController,
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
                                      controller: priceController,
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
                          controller: discriptionController,
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
                          height: 30,
                        ),
                        defaultButton(
                            function: () {
                              widget.carModel!.color =
                                  colorController.text.trim();
                              widget.carModel!.price =
                                  priceController.text.trim();
                              widget.carModel!.details =
                                  discriptionController.text.trim();
                              widget.carModel!.isDiesel = cubit.isDiesel;
                              widget.carModel!.isManual = cubit.isManual;
                              cubit.updateProductInFirebase(
                                  context: context,
                                  imageFiles: cubit.selectedImages,
                                  carModel: widget.carModel!);
                            },
                            text: "Update"),
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
