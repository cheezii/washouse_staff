// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../components/constants/color_constants.dart';

class InformationWidget extends StatelessWidget {
  final bool canChange;
  final String title;
  final String subTitle;
  final GestureTapCallback press;
  const InformationWidget({
    Key? key,
    required this.canChange,
    required this.title,
    required this.subTitle,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 200),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subTitle,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const Spacer(),
            canChange
                ? IconButton(
                    onPressed: press,
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Colors.grey.shade600,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(Icons.edit_off_rounded,
                        color: Colors.grey.shade500),
                  ),
          ],
        ),
      ),
    );
  }
}
