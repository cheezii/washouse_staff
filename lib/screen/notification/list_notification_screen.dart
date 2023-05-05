import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../components/constants/color_constants.dart';
import '../../components/constants/text_constants.dart';
import '../../resource/controller/notification_controller.dart';
import '../../resource/model/response_model/notification.dart';
import '../../resource/model/response_model/notification_item_response.dart';
import 'component/notification_list.dart';
import 'package:flutter/material.dart';

class ListNotificationScreen extends StatefulWidget {
  const ListNotificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ListNotificationScreen> createState() => _ListNotificationScreenState();
}

class _ListNotificationScreenState extends State<ListNotificationScreen> {
  NotificationController notificationController = NotificationController();
  List<NotificationItem> notifications = [];
  int countUnread = 0;
  bool isLoading = false;
  String message = "";
  @override
  void initState() {
    super.initState();
    // centerArgs = widget.orderId;
    //getNotifications();
  }

  void onNotificationReceived(NotificationItem notification) {
    setState(() {
      notifications.add(notification);
      if (!notification.isRead!) {
        countUnread = countUnread + 1;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<NotificationResponse> getNotifications() async {
    NotificationResponse notificationResponse = NotificationResponse();
    try {
      String url = '$baseUrl/notifications/me-noti';
      Response response =
          await baseController.makeAuthenticatedRequest(url, {});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["data"];
        notificationResponse = NotificationResponse.fromJson(data);
      } else {
        throw Exception(
            'Error fetching getNotifications: ${response.statusCode}');
      }
    } catch (e) {
      print('error: getNotifications-$e');
    }
    return notificationResponse;
  }

  // void getNotifications() async {
  //   // Show loading indicator
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     // Wait for getOrderInformation to complete
  //     NotificationResponse result = await notificationController.getNotifications();
  //     setState(() {
  //       // Update state with loaded data
  //       if (result.notifications != null) {
  //         notifications = result.notifications!;
  //         countUnread = result.numOfUnread!;
  //       }
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     // Handle error
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print('Error loading data: $e');
  //   }
  // }

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
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.check_circle_outline_outlined,
        //       color: Colors.white,
        //       size: 24,
        //     ),
        //   ),
        //],
      ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: notifications.length,
      //         padding: const EdgeInsets.only(top: 16),
      //         itemBuilder: (context, index) {
      //           return Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 5),
      //             child: NotificationList(
      //               title: notifications[index].title!,
      //               content: notifications[index].content!,
      //               image: 'assets/images/logo/washouse-favicon.png',
      //               time: notifications[index].createdDate!,
      //               isNotiRead: notifications[index].isRead!,
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),

      body: Center(
        child: FutureBuilder<NotificationResponse>(
          future: getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              notifications = snapshot.data!.notifications!;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: NotificationList(
                      id: notifications[index].id!,
                      title: notifications[index].title!,
                      content: notifications[index].content!,
                      image: 'assets/images/logo/washouse-favicon.png',
                      time: notifications[index].createdDate!,
                      isNotiRead: notifications[index].isRead!,
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
