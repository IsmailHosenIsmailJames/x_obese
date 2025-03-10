import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:o_xbese/src/screens/auth/info_collector/controller/controller.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:o_xbese/src/widgets/back_button.dart';
import 'package:o_xbese/src/widgets/text_input_decoration.dart';

class FullFromInfoCollector extends StatefulWidget {
  final PageController pageController;
  const FullFromInfoCollector({super.key, required this.pageController});

  @override
  State<FullFromInfoCollector> createState() => _FullFromInfoCollectorState();
}

class _FullFromInfoCollectorState extends State<FullFromInfoCollector> {
  final AllInfoController controller = Get.find();
  File? profileImage;
  final ImagePicker imagePicker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getBackbutton(context, () {
                    widget.pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  }),
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 50, width: 50),
                ],
              ),

              const Gap(15),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: Stack(
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: MyAppColors.transparentGray,
                                    ),
                                    child:
                                        profileImage == null
                                            ? Center(
                                              child: Icon(
                                                Icons.person,
                                                size: 40,
                                                color: MyAppColors.mutedGray,
                                              ),
                                            )
                                            : Image.file(
                                              profileImage!,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: MyAppColors.primary,
                                  ),
                                  onPressed: () async {
                                    final pickedFile = await imagePicker
                                        .pickImage(source: ImageSource.camera);

                                    setState(() {
                                      if (pickedFile != null) {
                                        profileImage = File(pickedFile.path);
                                      } else {
                                        log('No image selected.');
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.add_a_photo_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                        Center(
                          child: Text(
                            controller.allInfo.value.name ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Gap(24),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          decoration: getTextInputDecoration(
                            context,
                            hintText: 'Tohid@Gmail.com',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          decoration: getTextInputDecoration(context),
                          controller: TextEditingController(
                            text: controller.allInfo.value.name,
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          decoration: getTextInputDecoration(context),
                          controller: TextEditingController(
                            text: controller.allInfo.value.gender,
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Birth Of Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          decoration: getTextInputDecoration(context),
                          controller: TextEditingController(
                            text: DateFormat(
                              'yyyy-MM-dd',
                            ).format(controller.allInfo.value.dateOfBirth!),
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Weight',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          decoration: getTextInputDecoration(context),
                          controller: TextEditingController(
                            text: '${controller.allInfo.value.weight} Kg',
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Height',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          decoration: getTextInputDecoration(context),
                          controller: TextEditingController(
                            text:
                                '${controller.allInfo.value.height!.toInt()} Feet ${((controller.allInfo.value.height! % controller.allInfo.value.height!.toInt()) * 12).toPrecision(2).toInt()} inch',
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          decoration: getTextInputDecoration(context),
                          controller: TextEditingController(
                            text: controller.allInfo.value.address,
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      final Map previousUserInfo = Map.from(
                        Hive.box('user').get('info', defaultValue: {}),
                      );
                      previousUserInfo.addAll({
                        'name': controller.allInfo.value.name,
                        'gender': controller.allInfo.value.gender,
                        'dateOfBirth': DateFormat(
                          'yyyy-MM-dd',
                        ).format(controller.allInfo.value.dateOfBirth!),
                        'weight': controller.allInfo.value.weight,
                        'height': controller.allInfo.value.height,
                        'address': controller.allInfo.value.address,
                        'profileImage': profileImage?.path,
                      });

                      await Hive.box('user').put('info', previousUserInfo);

                      Get.offAllNamed('/home');
                    }
                  },
                  child: const Text(
                    'Save to Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
