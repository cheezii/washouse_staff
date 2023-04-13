import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../components/constants/color_constants.dart';
import '../../components/constants/size.dart';
import '../started/login.dart';
import 'reset_with_email.dart';
import 'send_otp.dart';

class ResetWithPhone extends StatefulWidget {
  const ResetWithPhone({super.key});

  @override
  State<ResetWithPhone> createState() => _ResetWithPhoneState();
}

TextEditingController passwordController = TextEditingController();

class _ResetWithPhoneState extends State<ResetWithPhone> {
  final _formPhoneNumKey = GlobalKey<FormState>();
  final typePhoneNum = RegExp(r'(((\+|)84)|0)(3|5|7|8|9)+([0-9]{8})\b');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding,
              horizontal: kDefaultPadding,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/started/forgotpw.png'),
                  const SizedBox(height: kDefaultPadding),
                  const Text(
                    'Đặt lại mật khẩu',
                    style:
                        TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  const Text(
                    'Nhập số điện thoại của bạn, chúng tôi sẽ gửi mã OTP đến để cài lại mật khẩu.',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Form(
                    key: _formPhoneNumKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Số điện thoại không được để trống';
                        }
                        if (!typePhoneNum.hasMatch(value)) {
                          return 'Số điện thoại phải có mười số';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        phoneController.text = newValue!;
                      },
                      obscureText: false,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.phone_android_rounded,
                          color: textColor.withOpacity(.5),
                        ),
                        labelText: 'Số điện thoại',
                      ),
                      keyboardType: TextInputType.number,
                      cursorColor: textColor.withOpacity(.8),
                      controller: phoneController,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.bottom),
                    width: size.width,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formPhoneNumKey.currentState!.validate()) {
                          _formPhoneNumKey.currentState!.save();
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const OTPScreen(isSignUp: false),
                                  type: PageTransitionType.fade));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: kPrimaryColor),
                      child: const Text(
                        'Tiếp tục',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const ResetWithEmail(),
                                  type: PageTransitionType.fade));
                        },
                        child: const Text(
                          'Đặt lại bằng email',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                          'Quay lại trang đăng nhập',
                          style: TextStyle(
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
