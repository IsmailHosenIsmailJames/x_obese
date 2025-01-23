import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:o_xbes/src/theme/colors.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  PinTheme pinTheme = PinTheme(
    height: 56,
    width: 56,
    textStyle: TextStyle(
      color: MyAppColors.primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    margin: const EdgeInsets.only(right: 15),
    decoration: BoxDecoration(
      border: Border.all(
        width: 1,
        color: Color.fromRGBO(219, 219, 219, 1),
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 24,
                  top: 62,
                ),
                height: 40,
                width: 40,
                child: IconButton(
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(
                        color: MyAppColors.primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back,
                    size: 15,
                    color: MyAppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(
              "assets/images/email.png",
            ),
          ),
          Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Verification",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              Text(
                " Code",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: MyAppColors.primaryColor,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 7),
            child: Text(
              "We have sent the code Verification to your mobile number ",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Color.fromRGBO(115, 115, 115, 1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Pinput(
                focusedPinTheme: pinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: MyAppColors.primaryColor.withValues(alpha: 0.2),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                cursor: Container(
                  height: 18,
                  width: 2,
                  color: Colors.black,
                ),
                defaultPinTheme: pinTheme,
                onCompleted: (pin) {},
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Resend it",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(41, 91, 255, 1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Veryfy Now",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
