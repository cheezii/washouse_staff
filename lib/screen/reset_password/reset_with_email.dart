import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../started/login.dart';
import 'reset_with_phone.dart';

import '../../components/constants/color_constants.dart';
import '../../components/constants/size.dart';
import 'send_otp.dart';

class ResetWithEmail extends StatefulWidget {
  const ResetWithEmail({super.key});

  @override
  State<ResetWithEmail> createState() => _ResetWithEmailState();
}

TextEditingController emailController = TextEditingController();

class _ResetWithEmailState extends State<ResetWithEmail> {
  final _formEmailKey = GlobalKey<FormState>();
  final typeEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
                  const SizedBox(height: 20),
                  const Text(
                    'Đặt lại mật khẩu',
                    style:
                        TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  const Text(
                    'Nhập email của bạn, chúng tôi sẽ gửi mã OTP đến để cài lại mật khẩu.',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kDefaultPadding),
                  Form(
                    key: _formEmailKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email không được để trống';
                        }
                        if (!typeEmail.hasMatch(value)) {
                          return 'Sai kiểu email';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        emailController.text = newValue!;
                      },
                      obscureText: false,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          color: textColor.withOpacity(.5),
                        ),
                        labelText: 'Email',
                      ),
                      cursorColor: textColor.withOpacity(.8),
                      controller: emailController,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  SizedBox(
                    width: size.width,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formEmailKey.currentState!.validate()) {
                          _formEmailKey.currentState!.save();
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const OTPScreen(),
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
                                  child: const ResetWithPhone(),
                                  type: PageTransitionType.fade));
                        },
                        child: const Text(
                          'Đặt lại bằng điện thoại',
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
