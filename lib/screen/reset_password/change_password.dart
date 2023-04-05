import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../components/constants/color_constants.dart';
import '../../components/constants/size.dart';
import '../started/login.dart';

class ChangePwdScreen extends StatefulWidget {
  const ChangePwdScreen({super.key});

  @override
  State<ChangePwdScreen> createState() => _ChangePwdScreenState();
}

TextEditingController passwordController = TextEditingController();
TextEditingController conpwdController = TextEditingController();

class _ChangePwdScreenState extends State<ChangePwdScreen> {
  final _formPwdKey = GlobalKey<FormState>();
  final _formConPwdKey = GlobalKey<FormState>();
  bool _isPassHidden = true;
  bool _isConPassHidden = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding,
              horizontal: kDefaultPadding,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/started/privacy.png'),
                  const SizedBox(height: kDefaultPadding),
                  const Text(
                    'Tạo mật khẩu mới',
                    style:
                        TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  const Text(
                    'Mật khẩu mới của bạn phải khác với mật khẩu đã tạo trước đó.',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kDefaultPadding),
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
                        conpwdController.text = newValue!;
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
                      controller: conpwdController,
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  SizedBox(
                    width: size.width,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formPwdKey.currentState!.validate() &&
                            _formConPwdKey.currentState!.validate()) {
                          _formPwdKey.currentState!.save();
                          _formConPwdKey.currentState!.save();
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: const Login(),
                                  type: PageTransitionType.fade));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: kPrimaryColor),
                      child: const Text(
                        'Tạo mật khẩu',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding / 2),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
