import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/constants/color_constants.dart';
import '../../resource/model/notification.dart';
import 'component/notification_list.dart';

class ListNotificationScreen extends StatelessWidget {
  const ListNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        centerTitle: true,
        title: const Text('Thông báo',
            style: TextStyle(color: Colors.white, fontSize: 27)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: listNoti.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: NotificationList(
                  title: 'Thông báo từ hệ thống',
                  content: listNoti[index].content,
                  image: 'assets/images/logo/washouse-favicon.png',
                  time: listNoti[index].day,
                  isNotiRead: false,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
