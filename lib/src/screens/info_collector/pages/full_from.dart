import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:image_picker/image_picker.dart";
import "package:intl/intl.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";
import "package:x_obese/src/widgets/text_input_decoration.dart";
import "package:dio/dio.dart" as dio;

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
  late final TextEditingController emailController = TextEditingController(
    text: controller.allInfo.value.email,
  );

  Future<void> updateInfo() async {
    Map<String, dynamic> userData = {
      "email": emailController.text.trim(),
      "fullName": controller.allInfo.value.fullName,
      "gender": controller.allInfo.value.gender,
      "birth": DateFormat("yyyy-MM-dd").format(controller.allInfo.value.birth!),
      "weight": controller.allInfo.value.weight,
      "heightFt": controller.allInfo.value.heightFt,
      "heightIn": controller.allInfo.value.heightIn,
      "address": controller.allInfo.value.address,
    };

    dio.FormData formData = dio.FormData.fromMap(userData);

    final response = await controller.updateUserInfo(formData);
    try {
      if (profileImage != null) {
        userData.clear();
        userData.addAll({
          "image": await dio.MultipartFile.fromFile(profileImage!.path),
        });
        await controller.updateUserInfo(dio.FormData.fromMap(userData));
      }
    } on dio.DioException catch (e) {
      log(e.message ?? "");
      if (e.response != null) {
        printResponse(e.response!);
        Fluttertoast.showToast(msg: "Unable to save profile image");
      }
    }
    if (response != null) {
      await Hive.box("user").put("info", jsonEncode(response.data["data"]));
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => true);
      Fluttertoast.showToast(msg: "Account information saved successful");
    }
  }

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
                  getBackButton(context, () {
                    widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }),
                  const Text(
                    "Profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset("assets/img/x_blue.svg"),
                  ),
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
                              getProfilePictureSection(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: MyAppColors.primary,
                                  ),
                                  onPressed: () async {
                                    final pickedFile = await imagePicker
                                        .pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 50,
                                        );

                                    setState(() {
                                      if (pickedFile != null) {
                                        profileImage = File(pickedFile.path);
                                      } else {
                                        log("No image selected.");
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
                            controller.allInfo.value.fullName ?? "",
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
                            "Email",
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
                            hintText: "type your email here...",
                          ),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Name",
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
                            text: controller.allInfo.value.fullName,
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Gender",
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
                            "Birth Of Date",
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
                              "yyyy-MM-dd",
                            ).format(controller.allInfo.value.birth!),
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Weight",
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
                            text: "${controller.allInfo.value.weight} Kg",
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Height",
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
                                "${controller.allInfo.value.heightFt!.toInt()} Feet ${controller.allInfo.value.heightIn!.toInt()} inch",
                          ),
                          enabled: false,
                        ),
                        const Gap(12),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Address",
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
                      updateInfo();
                    }
                  },
                  child: const Text(
                    "Save to Continue",
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

  Center getProfilePictureSection() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(color: MyAppColors.transparentGray),
          child:
              profileImage == null
                  ? controller.allInfo.value.image == null
                      ? Center(
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: MyAppColors.mutedGray,
                        ),
                      )
                      : CachedNetworkImage(
                        imageUrl: controller.allInfo.value.image!,
                        fit: BoxFit.cover,
                      )
                  : Image.file(profileImage!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
