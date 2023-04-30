import 'package:flutter/material.dart';

import '../../../components/constants/color_constants.dart';
import '../../../resource/controller/account_controller.dart';
import '../../../resource/controller/base_controller.dart';

class ChangePassWordAlertDialog extends StatefulWidget {
  const ChangePassWordAlertDialog({super.key});

  @override
  State<ChangePassWordAlertDialog> createState() =>
      _ChangePassWordAlertDialogState();
}

BaseController _baseController = BaseController();
AccountController _accountController = AccountController();

class _ChangePassWordAlertDialogState extends State<ChangePassWordAlertDialog> {
  final _formOldPwdKey = GlobalKey<FormState>();
  final _formPwdKey = GlobalKey<FormState>();
  final _formConfirmKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  String _passwordSaved = '';

  late String oldPassword;
  late String newPassword;
  late String confirmNewPassword;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final passwordSaved = await _baseController
        .getStringtoSharedPreference("CURRENT_USER_PASSWORD");
    setState(() {
      _passwordSaved = passwordSaved!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Align(
        alignment: Alignment.center,
        child: Text('Đổi mật khẩu'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formOldPwdKey,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mật khẩu hiện tại không được để trống';
                }
                if (value.compareTo(_passwordSaved) != 0) {
                  return 'Mật khẩu hiện tại không đúng';
                }
                return null;
              },
              obscureText: true,
              style: const TextStyle(
                color: textColor,
              ),
              decoration: InputDecoration(
                labelText: 'Mật khẩu hiện tại',
                labelStyle: const TextStyle(
                    color: textBoldColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                hintText: 'Nhập mật khẩu hiện tại',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              cursorColor: textColor.withOpacity(.8),
              onSaved: (oldValue) {
                oldPassword = oldValue!;
              },
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formPwdKey,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mật khẩu mới không được để trống';
                }
                return null;
              },
              obscureText: true,
              style: const TextStyle(
                color: textColor,
              ),
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                labelStyle: const TextStyle(
                    color: textBoldColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                hintText: 'Nhập mật khẩu mới',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              controller: passwordController,
              cursorColor: textColor.withOpacity(.8),
              onSaved: (newValue) {
                newPassword = newValue!;
              },
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formConfirmKey,
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Xác nhận mật khẩu không được để trống';
                }
                if (value.compareTo(passwordController.text) != 0) {
                  print(passwordController.text);
                  return 'Mật khẩu mới và mật khẩu xác nhận không khớp';
                }
                return null;
              },
              obscureText: true,
              style: const TextStyle(
                color: textColor,
              ),
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu',
                labelStyle: const TextStyle(
                    color: textBoldColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                hintText: 'Xác nhận mật khẩu mới',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              cursorColor: textColor.withOpacity(.8),
              onSaved: (newValue) {
                newPassword = newValue!;
              },
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {
              if (_formOldPwdKey.currentState!.validate() &&
                  _formPwdKey.currentState!.validate() &&
                  _formConfirmKey.currentState!.validate()) {
                //check _formPwdKey = _formConfirmKey

                _formOldPwdKey.currentState!.save();
                _formPwdKey.currentState!.save();
                _formConfirmKey.currentState!.save();
                //call api change pwd
                String message = await _accountController.changePassword(
                    oldPassword, newPassword);
                if (message.compareTo("change password success") == 0) {
                  await _baseController.saveStringtoSharedPreference(
                      "CURRENT_USER_PASSWORD", passwordController.text);
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Thông báo'),
                        content: const Text('Đổi mật khẩu thành công!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Thông báo'),
                        content: const Text('Có lỗi trong quá trình xử lý!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 19, vertical: 10),
                foregroundColor: kPrimaryColor.withOpacity(.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                      color: kPrimaryColor.withOpacity(.5), width: 1),
                ),
                backgroundColor: kPrimaryColor),
            child: const Text(
              'Lưu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
