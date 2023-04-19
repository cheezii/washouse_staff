import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/resource/controller/center_controller.dart';
import 'package:washouse_staff/resource/model/center.dart';
import 'package:washouse_staff/screen/home/home_screen.dart';
import 'package:washouse_staff/screen/started/signup.dart';

import '../../components/constants/color_constants.dart';
import '../../components/constants/size.dart';
import '../../resource/controller/account_controller.dart';
import '../../resource/controller/base_controller.dart';
import '../../resource/model/current_user.dart';
import '../../resource/model/customer.dart';
import '../../resource/model/response_model/login_response_model.dart';
import '../reset_password/widgets/forget_password_modal_bottom_sheet.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();
AccountController accountController = AccountController();
CenterController centerController = CenterController();
BaseController baseController = BaseController();

class _LoginState extends State<Login> {
  final typePhoneNum = RegExp(r'(((\+|)84)|0)(3|5|7|8|9)+([0-9]{8})\b');
  final _formPhoneNumberKey = GlobalKey<FormState>();
  final _formPwdKey = GlobalKey<FormState>();
  bool _isHidden = true;
  String _errorMessage = '';
  String? _responseMessage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding,
            horizontal: kDefaultPadding,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/started/phone-verify.png'),
                const SizedBox(height: 16),
                const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formPhoneNumberKey,
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
                    obscureText: _isHidden,
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
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                          ),
                        )),
                    cursorColor: textColor.withOpacity(.8),
                    controller: passwordController,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: size.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      _responseMessage = '';
                      if (_formPhoneNumberKey.currentState!.validate() &&
                          _formPwdKey.currentState!.validate()) {
                        _formPwdKey.currentState!.save();
                        _formPhoneNumberKey.currentState!.save();
                        //call api change pwd

                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        LoginResponseModel? responseModel =
                            await accountController.login(
                                phoneController.text, passwordController.text);
                        if (responseModel != null) {
                          if (responseModel.statusCode == 17) {
                            _responseMessage =
                                "Admin không thể đăng nhập trên mobile";
                          } else if (responseModel.statusCode == 10) {
                            _responseMessage =
                                "Sai số điện thoại hoặc mật khẩu";
                          } else {
                            var currentUserModel = await accountController
                                .getCurrentUser() as CurrentUser;
                            if (currentUserModel != null) {
                              baseController.saveStringtoSharedPreference(
                                  "CURRENT_USER_NAME", currentUserModel.name);
                              baseController.saveStringtoSharedPreference(
                                  "CURRENT_USER_EMAIL", currentUserModel.email);
                              baseController.saveStringtoSharedPreference(
                                  "CURRENT_USER_AVATAR",
                                  currentUserModel.avatar);
                              baseController.saveInttoSharedPreference(
                                  "CURRENT_USER_ID",
                                  currentUserModel.accountId!);
                              baseController.saveStringtoSharedPreference(
                                  "CURRENT_USER_PASSWORD",
                                  passwordController.text);
                            }
                            Customer? currentCustomer =
                                await accountController.getCustomerInfomation(
                                    currentUserModel.accountId!);
                            if (currentCustomer != null) {
                              baseController.saveInttoSharedPreference(
                                  "CURRENT_CUSTOMER_ID",
                                  currentUserModel.accountId!);
                            }
                            LaundryCenter? currentLaundry =
                                await centerController.getCenterInfomation();
                            if (currentLaundry != null) {
                              baseController.saveInttoSharedPreference(
                                  "CENTER_ID", currentLaundry.id!);
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, '/home',
                                  arguments: currentLaundry.id);
                            } else {
                              Navigator.of(context).pop();
                              _responseMessage =
                                  'Bạn chưa đăng kí làm cho trung tâm nào';
                            }
                            // ignore: use_build_context_synchronously
                          }
                        }
                      }
                      if (_responseMessage == null) {
                        _responseMessage = "";
                      }
                      if (_responseMessage != null && _responseMessage != "") {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Align(
                                  alignment: Alignment.center,
                                  child: Text('Lỗi!!')),
                              content: Text('$_responseMessage'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text(
                                    'Đã hiểu',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: kPrimaryColor),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      backgroundColor: kBackgroundColor),
                                  onPressed: () {
                                    // Perform some action
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: kPrimaryColor),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                const SizedBox(height: kDefaultPadding / 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ForgetPasswordScreen.buildShowModalBottomSheet(context);
                    },
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: kDefaultPadding / 4),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
                      child: Text('HOẶC'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding / 2,
                    vertical: kDefaultPadding / 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: kDefaultPadding * 1.5,
                        child: Image.asset('assets/images/google.png'),
                      ),
                      const Text(
                        'Đăng nhập bằng Google',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: const SignUp(),
                        type: PageTransitionType.rightToLeftWithFade,
                      ),
                    );
                  },
                  child: const Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Chưa có tài khoản? ',
                            style: TextStyle(
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: 'Đăng ký',
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
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
