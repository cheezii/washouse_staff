import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../reset_with_email.dart';
import '../reset_with_phone.dart';
import 'forget_password_btn.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn phương thức',
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Chọn một trong hai cách dưới đây để đặt lại mật khẩu.',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 30.0),
            ForgetPasswordBtn(
              icon: Icons.mail_outline_rounded,
              title: 'Email',
              subtitle: 'Đặt lại mật khẩu qua email',
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const ResetWithEmail(),
                        type: PageTransitionType.fade));
              },
            ),
            const SizedBox(height: 30.0),
            ForgetPasswordBtn(
              icon: Icons.mobile_friendly_rounded,
              title: 'Điện thoại',
              subtitle: 'Đặt lại mật khẩu qua điện thoại',
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const ResetWithPhone(),
                        type: PageTransitionType.fade));
              },
            ),
          ],
        ),
      ),
    );
  }
}
