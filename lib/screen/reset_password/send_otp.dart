import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../components/constants/color_constants.dart';
import '../../components/constants/size.dart';
import '../started/login.dart';
import 'change_password.dart';

class OTPScreen extends StatefulWidget {
  final bool isSignUp;
  const OTPScreen({super.key, required this.isSignUp});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  OtpFieldController otpController = OtpFieldController();
  bool isOpenKeyboard = false;

  @override
  void initState() {
    super.initState();
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      isOpenKeyboard = true;
    } else {
      isOpenKeyboard = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 26,
            ),
          ),
        ),
        backgroundColor: kBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding,
              horizontal: kDefaultPadding,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isOpenKeyboard
                      ? SizedBox(height: 0, width: 0)
                      : SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset(
                              'assets/images/started/authenticate.png'),
                        ),
                  const SizedBox(height: 40),
                  const Text(
                    'Nhập mã xác minh',
                    style:
                        TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.isSignUp
                        ? 'Nhập mã OTP được gửi đến số điện thoại của bạn.'
                        : 'Nhập mã OTP được gửi đến email/số điện thoại của bạn.',
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  OTPTextField(
                    controller: otpController,
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 60,
                    style: TextStyle(fontSize: 28),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                      widget.isSignUp
                          ? Navigator.push(
                              context,
                              PageTransition(
                                  child: const Login(),
                                  type: PageTransitionType
                                      .fade)) //register thành công
                          : Navigator.push(
                              context,
                              PageTransition(
                                  child: const ChangePwdScreen(),
                                  type: PageTransitionType.fade));
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chưa nhận được mã xác nhận?',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const Login(),
                                  type: PageTransitionType.fade));
                        },
                        child: const Text(
                          'Gửi lại OTP',
                          style: TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
