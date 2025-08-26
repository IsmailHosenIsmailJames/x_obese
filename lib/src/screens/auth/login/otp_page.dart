import "package:dio/dio.dart" as dio;
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:pinput/pinput.dart";
import "package:x_obese/src/common_functions/common_functions.dart";
import "package:x_obese/src/screens/auth/bloc/auth_bloc.dart";
import "package:x_obese/src/screens/auth/bloc/auth_event.dart";
import "package:x_obese/src/screens/auth/bloc/auth_state.dart";
import "package:x_obese/src/screens/auth/login/success_page.dart";
import "package:x_obese/src/screens/info_collector/info_collector.dart";
import "package:x_obese/src/theme/colors.dart";

class OtpPage extends StatefulWidget {
  final bool isSignup;
  final String phone;
  final dio.Response response;

  const OtpPage({
    super.key,
    required this.isSignup,
    required this.phone,
    required this.response,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpController = TextEditingController();

  void _checkOTP(String otp) async {
    if (!(await checkConnectivity())) {
      Fluttertoast.showToast(msg: "Check Internet Connection!");
      return;
    }
    String id = widget.response.data["data"]?["id"] ?? "";
    String type = widget.isSignup ? "signup" : "login";
    context.read<AuthBloc>().add(VerifyOTP(otp: otp, type: type, id: id));
  }

  DateTime otpSentTime = DateTime.now();

  Future<void> _resendOTP() async {
    context.read<AuthBloc>().add(LoginRequested(widget.phone));
    otpSentTime = DateTime.now();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthNavigateToHome) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginSuccessPage()),
              (route) => false,
            );
          } else if (state is AuthNavigateToInfoCollector) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder:
                    (context) => InfoCollector(initialData: state.userData),
              ),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            Fluttertoast.showToast(msg: state.error);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.string(
                          '''<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="0.5" y="0.5" width="39" height="39" rx="19.5" stroke="#F3F3F3"/>
                        <path d="M18 16L14 20M14 20L18 24M14 20L26 20" stroke="#047CEC" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                        ''',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset("assets/img/x_blue.svg"),
                    ),
                  ],
                ),
                const Gap(20),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: SvgPicture.string(
                    '''<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M4.41807 15.3999V22.2522L0.283691 18.8772C0.492312 18.4351 0.807805 18.052 1.20166 17.7624L4.41807 15.3999ZM34.8798 17.7624C35.2736 18.052 35.5891 18.4351 35.7978 18.8772L31.6634 22.2522V15.3999L34.8798 17.7624Z" fill="#D79235"/>
                <path d="M27.2656 25.5679L27.4016 25.7343L22.3172 29.8843L19.9078 31.8522C19.3816 32.2813 18.7235 32.5156 18.0445 32.5156C17.3656 32.5156 16.7074 32.2813 16.1812 31.8522L13.7719 29.8843L8.68359 25.7343L8.81953 25.5679H27.2656Z" fill="#F1F2F4"/>
                <path d="M31.6633 22.2524L27.3977 25.7345L27.2656 25.5681H8.81953L8.68359 25.7345L4.41797 22.2524V6.86182C4.41797 6.08067 4.72828 5.33152 5.28063 4.77917C5.83298 4.22681 6.58214 3.9165 7.36328 3.9165H28.718C29.4991 3.9165 30.2483 4.22681 30.8006 4.77917C31.353 5.33152 31.6633 6.08067 31.6633 6.86182V22.2524Z" fill="#F1F2F4"/>
                <path d="M35.0782 39.2647C34.5411 39.7392 33.8488 40.0005 33.1321 39.9991H2.94541C2.2288 40.0002 1.53658 39.739 0.999316 39.2647L13.7681 29.8843L16.1774 31.8522C16.7036 32.2813 17.3618 32.5156 18.0407 32.5156C18.7197 32.5156 19.3778 32.2813 19.904 31.8522L22.3134 29.8843L35.0782 39.2647ZM4.41807 15.3999V22.2522L0.283691 18.8772C0.492312 18.4351 0.807805 18.052 1.20166 17.7624L4.41807 15.3999ZM34.8798 17.7624C35.2736 18.052 35.5891 18.4351 35.7978 18.8772L31.6634 22.2522V15.3999L34.8798 17.7624Z" fill="#D79235"/>
                <path d="M27.2656 25.5679L27.4016 25.7343L22.3172 29.8843L19.9078 31.8522C19.3816 32.2813 18.7235 32.5156 18.0445 32.5156C17.3656 32.5156 16.7074 32.2813 16.1812 31.8522L13.7719 29.8843L8.68359 25.7343L8.81953 25.5679H27.2656Z" fill="#F1F2F4"/>
                <path d="M31.6633 22.2524L27.3977 25.7345L27.2656 25.5681H8.81953L8.68359 25.7345L4.41797 22.2524V6.86182C4.41797 6.08067 4.72828 5.33152 5.28063 4.77917C5.83298 4.22681 6.58214 3.9165 7.36328 3.9165H28.718C29.4991 3.9165 30.2483 4.22681 30.8006 4.77917C31.353 5.33152 31.6633 6.08067 31.6633 6.86182V22.2524Z" fill="#F1F2F4"/>
                <path d="M35.0779 39.2647C34.5408 39.7392 33.8485 40.0005 33.1318 39.9991H2.94512C2.22851 40.0002 1.53629 39.739 0.999023 39.2647L13.7678 29.8843L16.1771 31.8522C16.7033 32.2813 17.3615 32.5156 18.0404 32.5156C18.7194 32.5156 19.3775 32.2813 19.9037 31.8522L22.3131 29.8843L35.0779 39.2647Z" fill="#F19C02"/>
                <path d="M27.2653 13.1359H8.81919C8.60743 13.1359 8.40435 13.0518 8.25461 12.9021C8.10487 12.7523 8.02075 12.5493 8.02075 12.3375C8.02075 12.1257 8.10487 11.9227 8.25461 11.7729C8.40435 11.6232 8.60743 11.5391 8.81919 11.5391H27.2653C27.477 11.5391 27.6801 11.6232 27.8299 11.7729C27.9796 11.9227 28.0637 12.1257 28.0637 12.3375C28.0637 12.5493 27.9796 12.7523 27.8299 12.9021C27.6801 13.0518 27.477 13.1359 27.2653 13.1359ZM27.2653 17.5461H8.81919C8.60743 17.5461 8.40435 17.462 8.25461 17.3122C8.10487 17.1625 8.02075 16.9594 8.02075 16.7477C8.02075 16.5359 8.10487 16.3328 8.25461 16.1831C8.40435 16.0333 8.60743 15.9492 8.81919 15.9492H27.2653C27.477 15.9492 27.6801 16.0333 27.8299 16.1831C27.9796 16.3328 28.0637 16.5359 28.0637 16.7477C28.0637 16.9594 27.9796 17.1625 27.8299 17.3122C27.6801 17.462 27.477 17.5461 27.2653 17.5461ZM27.2653 21.9531H8.81919C8.60743 21.9531 8.40435 21.869 8.25461 21.7193C8.10487 21.5695 8.02075 21.3664 8.02075 21.1547C8.02075 20.9429 8.10487 20.7398 8.25461 20.5901C8.40435 20.4404 8.60743 20.3562 8.81919 20.3562H27.2653C27.477 20.3562 27.6801 20.4404 27.8299 20.5901C27.9796 20.7398 28.0637 20.9429 28.0637 21.1547C28.0637 21.3664 27.9796 21.5695 27.8299 21.7193C27.6801 21.869 27.477 21.9531 27.2653 21.9531ZM27.2653 26.3664H8.81919C8.61165 26.3599 8.41479 26.2729 8.27028 26.1238C8.12577 25.9747 8.04496 25.7752 8.04496 25.5676C8.04496 25.3599 8.12577 25.1604 8.27028 25.0113C8.41479 24.8622 8.61165 24.7752 8.81919 24.7688H27.2653C27.4728 24.7752 27.6697 24.8622 27.8142 25.0113C27.9587 25.1604 28.0395 25.3599 28.0395 25.5676C28.0395 25.7752 27.9587 25.9747 27.8142 26.1238C27.6697 26.2729 27.4728 26.3599 27.2653 26.3664Z" fill="#666666"/>
                <path d="M13.768 29.8845L1 39.2649C0.685661 38.9889 0.433854 38.649 0.261405 38.2678C0.0889558 37.8867 -0.000164069 37.4731 2.26751e-07 37.0548V20.1368C6.442e-06 19.7012 0.0968753 19.271 0.283594 18.8774L4.41797 22.2524L8.68359 25.7345L13.768 29.8845ZM36.0812 20.1368V37.0548C36.0813 37.4735 35.9918 37.8874 35.8188 38.2687C35.6458 38.6501 35.3932 38.99 35.0781 39.2657L22.3133 29.8845L27.3977 25.7345L31.6633 22.2524L35.7977 18.8774C35.9844 19.271 36.0812 19.7012 36.0812 20.1368Z" fill="#F6BD6E"/>
                <path d="M36.0812 20.1368V37.0548C36.0812 37.4735 35.9918 37.8874 35.8187 38.2687C35.6457 38.6501 35.3932 38.99 35.0781 39.2657L22.3132 29.8845L27.3976 25.7345L31.6632 22.2524L35.7976 18.8774C35.9843 19.271 36.0812 19.7012 36.0812 20.1368Z" fill="#F6BD6E"/>
                <path d="M30.9766 18.0469C35.9601 18.0469 40 14.0069 40 9.02344C40 4.03993 35.9601 0 30.9766 0C25.9931 0 21.9531 4.03993 21.9531 9.02344C21.9531 14.0069 25.9931 18.0469 30.9766 18.0469Z" fill="#047CEC"/>
                <path d="M29.7658 12.4216C29.5899 12.4214 29.4213 12.3514 29.297 12.2271L26.2501 9.1888C26.141 9.06164 26.0839 8.89796 26.0903 8.73052C26.0967 8.56308 26.1661 8.40423 26.2846 8.28574C26.4031 8.16726 26.5619 8.09788 26.7294 8.0915C26.8968 8.08511 27.0605 8.14219 27.1876 8.2513L29.7658 10.8185L34.7658 5.81849C34.8929 5.70938 35.0566 5.6523 35.224 5.65869C35.3915 5.66507 35.5503 5.73445 35.6688 5.85293C35.7873 5.97142 35.8567 6.13027 35.8631 6.29771C35.8694 6.46515 35.8124 6.62883 35.7033 6.75599L30.2345 12.2247C30.1732 12.2868 30.1002 12.3361 30.0197 12.3699C29.9393 12.4037 29.853 12.4212 29.7658 12.4216Z" fill="#E8E8E8"/>
                </svg>
                ''',
                  ),
                ),
                const Gap(10),
                const Text(
                  "Verification Code",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const Text(
                  """We have sent the code Verification to your mobile number """,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
                const Gap(50),
                Pinput(
                  onCompleted: (pin) {
                    _checkOTP(pin);
                  },
                  controller: otpController,
                  length: 6,
                  defaultPinTheme: PinTheme(
                    height: 56,
                    width: 56,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MyAppColors.transparentGray,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Gap(30),
                StreamBuilder<int>(
                  stream: Stream.periodic(const Duration(seconds: 1), (x) {
                    final secondsPassed =
                        DateTime.now().difference(otpSentTime).inSeconds;
                    final secondsLeft = 30 - secondsPassed;
                    return secondsLeft > 0 ? secondsLeft : 0;
                  }),
                  builder: (context, snapshot) {
                    final secondsLeft = snapshot.data ?? 0;
                    return Column(
                      children: [
                        TextButton(
                          onPressed:
                              secondsLeft > 0
                                  ? null
                                  : () {
                                    _resendOTP();
                                  },
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  secondsLeft > 0
                                      ? Colors.grey
                                      : MyAppColors.third,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        if (secondsLeft > 0)
                          Text(
                            "You can resend code in $secondsLeft seconds",
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    );
                  },
                ),
                const Gap(30),
                SizedBox(
                  height: 51,
                  width: double.infinity,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed:
                            state is AuthLoading
                                ? null
                                : () {
                                  if (otpController.text.length == 6) {
                                    _checkOTP(otpController.text);
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "OTP is not valid",
                                      textColor: Colors.white,
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                },
                        child:
                            state is AuthLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                  "Verify Now",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
