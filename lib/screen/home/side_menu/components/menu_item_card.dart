// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:washouse_staff/components/constants/color_constants.dart';

class MenuItemCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback press;
  const MenuItemCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 34,
        height: 34,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      hoverColor: kPrimaryColor.withOpacity(.3),
      onTap: press,
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
