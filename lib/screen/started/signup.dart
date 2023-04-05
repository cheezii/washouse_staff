import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import '../../components/constants/color_constants.dart';
import '../../components/constants/size.dart';
import '../../resource/controller/account_controller.dart';
import '../../resource/controller/google_controller.dart';
import '../home/base_screen.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? _errorMessage;
  bool _isPassHidden = true;
  bool _isConPassHidden = true;
  AccountController accountController = AccountController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conpasswordController = TextEditingController();
  GlobalKey<FormState> _formPwdKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formConPwdKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formPhoneNumKey = GlobalKey<FormState>();
  final typePhoneNum = RegExp(r'(((\+|)84)|0)(3|5|7|8|9)+([0-9]{8})\b');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/started/phone-security.png'),
                  const SizedBox(height: kDefaultPadding),
                  const Text(
                    'Đăng ký',
                    style:
                        TextStyle(fontSize: 40.0, fontWeight: FontWeight.w700),
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
                  Form(
                    key: _formPwdKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Mật khẩu không được để trống';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        passwordController.text = newValue!;
                      },
                      obscureText: _isPassHidden,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.password_rounded,
                            color: textColor.withOpacity(.5),
                          ),
                          labelText: 'Mật khẩu',
                          suffix: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                              _isPassHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          )),
                      cursorColor: textColor.withOpacity(.8),
                      controller: passwordController,
                    ),
                  ),
                  Form(
                    key: _formConPwdKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Xác nhận mật khẩu không được để trống';
                        }
                        if (value.compareTo(passwordController.text) != 0) {
                          return 'Xác nhận mật khẩu không khớp!';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        conpasswordController.text = newValue!;
                      },
                      obscureText: _isConPassHidden,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.password_rounded,
                            color: textColor.withOpacity(.5),
                          ),
                          labelText: 'Xác nhận mật khẩu',
                          suffix: InkWell(
                            onTap: _toggleConPasswordView,
                            child: Icon(
                              _isConPassHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          )),
                      cursorColor: textColor.withOpacity(.8),
                      controller: conpasswordController,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: size.width,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formPhoneNumKey.currentState!.validate() &&
                            _formPwdKey.currentState!.validate() &&
                            _formConPwdKey.currentState!.validate()) {
                          _formPhoneNumKey.currentState!.save();
                          _formPwdKey.currentState!.save();
                          _formConPwdKey.currentState!.save();

                          accountController.register(
                              //emailController.text,
                              phoneController.text,
                              passwordController.text,
                              conpasswordController.text);
                          if (_errorMessage?.compareTo("success") == 0) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: const Login(),
                                    type: PageTransitionType.fade));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: kPrimaryColor),
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding / 2),
                        child: Text('HOẶC'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton.icon(
                  //   onPressed: signUp,
                  //   style: ElevatedButton.styleFrom(
                  //     minimumSize: Size(size.width, 50),
                  //   ),
                  //   icon: Image.asset('assets/images/google.png'),
                  //   label: const Text(
                  //     'Đăng ký bằng Google',
                  //     style: TextStyle(
                  //       color: textColor,
                  //       fontSize: 18.0,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: signUp,
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: kDefaultPadding * 1.5,
                            child: Image.asset('assets/images/google.png'),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Đăng ký bằng Google',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const Login(),
                          type: PageTransitionType.leftToRightWithFade,
                        ),
                      );
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Đã có tài khoản? ',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Đăng nhập',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final user = await GoogleControler.login();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xffc72c41),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Oops',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    "Đăng ký không thành công",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  )
                ],
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      //}
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (Context) => BaseScreen()));
    }
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
        ),
      );

  void _togglePasswordView() {
    setState(() {
      _isPassHidden = !_isPassHidden;
    });
  }

  void _toggleConPasswordView() {
    setState(() {
      _isConPassHidden = !_isConPassHidden;
    });
  }
}
