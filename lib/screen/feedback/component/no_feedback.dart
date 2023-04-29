// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../components/constants/color_constants.dart';

class NoFeedbackScreen extends StatelessWidget {
  final String type;
  const NoFeedbackScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 150),
        Icon(
          Icons.star_rounded,
          color: kPrimaryColor,
          size: 60,
        ),
        const SizedBox(height: 15),
        Text(
          'Bạn chưa đánh giá $type nào',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ],
    );
  }
}
