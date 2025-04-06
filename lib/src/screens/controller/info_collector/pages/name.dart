import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/theme/colors.dart' show MyAppColors;
import 'package:x_obese/src/widgets/text_input_decoration.dart';

class NameCollectPage extends StatefulWidget {
  final PageController pageController;
  const NameCollectPage({super.key, required this.pageController});

  @override
  State<NameCollectPage> createState() => _NameCollectPageState();
}

class _NameCollectPageState extends State<NameCollectPage> {
  final formKey = GlobalKey<FormState>();
  final AllInfoController allInfoController = Get.find();
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
              const SizedBox(height: 50, width: 50),
              const Gap(32),
              LinearProgressIndicator(
                value: 1 / 5,
                borderRadius: BorderRadius.circular(7),
                color: MyAppColors.third,
              ),
              const Gap(32),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'What’s your name?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const Gap(32),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: TextEditingController(
                    text: allInfoController.allInfo.value.fullName,
                  ),
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    allInfoController.allInfo.value.fullName = value;
                  },
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: getTextInputDecoration(
                    context,
                    hintText: 'Enter Your Name',
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      widget.pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: const Text(
                    'Next',
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
