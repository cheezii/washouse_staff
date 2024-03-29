import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/src/widgets/basic.dart' as basic;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:washouse_staff/resource/controller/base_controller.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:washouse_staff/resource/model/staff_statistic.dart';
import 'package:washouse_staff/screen/chat/chat_screen.dart';
import 'package:washouse_staff/screen/home/scan_qr_code.dart';
import 'package:washouse_staff/screen/home/side_menu/side_menu.dart';
import 'package:washouse_staff/screen/order/create_order_screen.dart';
import '../../components/constants/color_constants.dart';
import '../../components/constants/text_constants.dart';
import '../../resource/controller/center_controller.dart';
import '../../resource/model/center.dart';
import '../../resource/model/response_model/notification_item_response.dart';
import '../../resource/provider/notify_provider.dart';
import '../notification/list_notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final centerId;
  const HomeScreen({super.key, this.centerId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

NotifyProvider notifyProvider = NotifyProvider();

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final firebaseStore = FirebaseFirestore.instance;
  CenterController centerController = CenterController();
  OrderController orderController = OrderController();
  BaseController baseController = BaseController();
  LaundryCenter centerDetails = LaundryCenter();
  bool isLoadingDetail = true;
  TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  Statistic statistic = Statistic();
  bool isLoading = false;
  int numOfNotifications = 0;

  void getCenterDetail() async {
    int id = widget.centerId;
    centerController.getCenterById(id).then(
      (result) {
        setState(() {
          centerDetails = result;
          isLoadingDetail = false;
        });
      },
    );
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Wait for getOrderInformation to complete
      Statistic result = await orderController.getStatistics();
      NotificationResponse notis = await getNotifications();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        // Update state with loaded data
        statistic = result;
        print('length');
        print(statistic.dailystatistics![1].toJson());
        for (var element in statistic.dailystatistics!) {
          double day = double.parse(element.day!.substring(0, 2));
          //completeData.add(new SalesData(day, element.successfulOrder!.toDouble()));
          //cancelData.add(new SalesData(day, element.cancelledOrder!.toDouble()));
          completeData.add(new SalesData(element.day!.substring(0, 5),
              element.successfulOrder!.toDouble()));
          cancelData.add(new SalesData(element.day!.substring(0, 5),
              element.cancelledOrder!.toDouble()));
        }
        numOfNotifications = notis.numOfUnread!;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1), () {
      getCenterDetail();
    });
    loadData();
    notifyProvider.addListener(() => mounted ? setState(() {}) : null);
    notifyProvider.getNoti();
  }

  @override
  void dispose() {
    notifyProvider.removeListener(() {});
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

  final List<ChartData> data = [
    ChartData('Đang chờ', 6, pendingdColor),
    ChartData('Xác nhận', 14, confirmedColor),
    ChartData('Đã nhận', 22, completeColor),
    ChartData('Xử lý', 28, processingColor),
    ChartData('Sẵn sàng', 15, readyColor),
    ChartData('Hoàn tất', 30, completeColor),
    ChartData('Đã hủy', 5, cancelledColor),
  ];

  List<SalesData> completeData = [];
  List<SalesData> cancelData = [];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            child: basic.Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: 100,
                height: 100,
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: kPrimaryColor, size: 50),
              ),
            ),
          )
        ],
      );
    } else {
      OrderOverview overview = statistic.orderOverview!;
      return Scaffold(
        key: scaffoldKey,
        drawer: const SideMenu(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const ImageIcon(
              AssetImage('assets/icon/menu.png'),
              color: textColor,
            ),
          ),
          centerTitle: true,
          title: const Text('Trang chủ',
              style: TextStyle(color: textColor, fontSize: 24)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const ListNotificationScreen(),
                        type: PageTransitionType.rightToLeftWithFade));
              },
              icon: Stack(
                children: [
                  const Icon(
                    Icons.notifications,
                    color: textColor,
                    size: 30.0,
                  ),
                  if (notifyProvider.numOfNotifications > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${notifyProvider.numOfNotifications}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tổng quan đơn hàng (7 ngày)',
                style: TextStyle(
                    fontSize: 20,
                    color: textBoldColor,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 70,
                    width: 125,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor.withOpacity(.7)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          //'0',
                          '${overview.numOfPendingOrder}',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Chờ xác nhận')
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 125,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor.withOpacity(.7)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          //'7',
                          '${overview.numOfProcessingOrder}',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Đang xử lý')
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 70,
                    width: 125,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor.withOpacity(.7)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          //'9',
                          '${overview.numOfReadyOrder}',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Sẵn sàng')
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 125,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor.withOpacity(.7)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          //'9',
                          '${overview.numOfPendingDeliveryOrder}',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Chờ vận chuyển')
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 70,
                    width: 125,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor.withOpacity(.7)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          //'10',
                          '${overview.numOfCompletedOrder}',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Hoàn tất')
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 125,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: textColor.withOpacity(.7)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          //'7',
                          '${overview.numOfCancelledOrder}',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Đã hủy')
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Thống kê đơn hàng theo ngày',
                style: TextStyle(
                    fontSize: 20,
                    color: textBoldColor,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SfCartesianChart(
                legend:
                    Legend(isVisible: true, position: LegendPosition.bottom),
                tooltipBehavior: tooltipBehavior,
                series: <ChartSeries>[
                  LineSeries<SalesData, dynamic>(
                    dataSource: completeData,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    xValueMapper: (SalesData sales, _) => sales.day.toString(),
                    yValueMapper: (SalesData sales, _) => sales.value,
                    enableTooltip: true,
                    name: 'Thành công',
                    color: Colors.purple,
                  ),
                  LineSeries<SalesData, dynamic>(
                    dataSource: cancelData,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    xValueMapper: (SalesData sales, _) => sales.day.toString(),
                    yValueMapper: (SalesData sales, _) => sales.value,
                    enableTooltip: true,
                    name: 'Hủy',
                    color: Colors.green,
                  )
                ],
                // primaryXAxis:
                //     NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                primaryXAxis: CategoryAxis(
                  isVisible: true,
                  labelRotation: 75,
                  arrangeByIndex: true,
                  labelPlacement: LabelPlacement.betweenTicks,
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          backgroundColor: kPrimaryColor,
          children: [
            SpeedDialChild(
              child: const ImageIcon(
                AssetImage('assets/icon/chat.png'),
                color: Colors.white,
              ),
              label: 'Tin nhắn',
              backgroundColor: kPrimaryColor,
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatScreen()));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ChatDetailPage(
                //               arguments: ChatPageArguments(
                //                   peerId: '2',
                //                   peerAvatar: 'abc',
                //                   peerNickname: 'Đoàn Trọng Kim'),
                //             )));

                // String groupChatId = "";
                // if (widget.centerId.toString().compareTo('3') > 0) {
                //   groupChatId = '${widget.centerId}-${3}';
                // } else {
                //   groupChatId = '${3}-${widget.centerId}';
                // }

                // var fromMsg = await firebaseStore
                //     .collection(FirestoreConstants.pathMessageCollection)
                //     .withConverter(
                //         fromFirestore: ((snapshot, _) =>
                //             MessageData.fromDocument(snapshot)),
                //         toFirestore: (MessageData msg, options) => msg.toJson())
                //     .where('idFrom', isEqualTo: widget.centerId.toString())
                //     .where('idTo', isEqualTo: '3')
                //     .get();

                // var toMsg = await firebaseStore
                //     .collection(FirestoreConstants.pathMessageCollection)
                //     .withConverter(
                //         fromFirestore: ((snapshot, _) =>
                //             MessageData.fromDocument(snapshot)),
                //         toFirestore: (MessageData msg, options) => msg.toJson())
                //     .where('idFrom', isEqualTo: '3')
                //     .where('idTo', isEqualTo: widget.centerId.toString())
                //     .get();

                // print('length to: ${toMsg.docs.length}');

                // if (fromMsg.docs.isEmpty && toMsg.docs.isEmpty) {
                //   var msgData = MessageData(
                //       idFrom: widget.centerId.toString(),
                //       nameFrom: centerDetails.title ?? '',
                //       avatarFrom: centerDetails.thumbnail ??
                //           'https://storage.googleapis.com/washousebucket/anonymous-20230330210147.jpg?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=washouse-sa%40washouse-381309.iam.gserviceaccount.com%2F20230330%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20230330T210148Z&X-Goog-Expires=1800&X-Goog-SignedHeaders=host&X-Goog-Signature=7c813f26489c9ba06cdfff27db9faa2ca4d7c046766aeb3874fdf86ec7c91ae904951f7b2617b6e78598d46f8b91d842d2f4c2a10696539bcf09c839d51d9565831f6c503b3e37f899ab8920f69c3aaa30e0ff2d9c598d1a4c523c1e8038520a32fe49a92c4448c49e602b77312444fe3505afa30da1c4bfbdf0f7a5ab9f2783005c1f3624b3417e17c0067f65f4c02fd03bbe9a0eed8390b56aa2b78a34ca88b52bbce7e1d364dc24e6650a68954e36439102f19a3b332fcb1562260d5223db1e09748eee5d7e6b0cba62dc7cfda9e1e00690f334b9e4b85c710ed77dee42759b48f98df0f05e1adf686351f6232a7d157c9f988248af0c69ec64af0cdbe247',
                //       idTo: '3',
                //       nameTo: 'Đoàn Kim Trọng',
                //       avatarTo:
                //           'https://storage.googleapis.com/washousebucket/anonymous-20230330210147.jpg?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=washouse-sa%40washouse-381309.iam.gserviceaccount.com%2F20230330%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20230330T210148Z&X-Goog-Expires=1800&X-Goog-SignedHeaders=host&X-Goog-Signature=7c813f26489c9ba06cdfff27db9faa2ca4d7c046766aeb3874fdf86ec7c91ae904951f7b2617b6e78598d46f8b91d842d2f4c2a10696539bcf09c839d51d9565831f6c503b3e37f899ab8920f69c3aaa30e0ff2d9c598d1a4c523c1e8038520a32fe49a92c4448c49e602b77312444fe3505afa30da1c4bfbdf0f7a5ab9f2783005c1f3624b3417e17c0067f65f4c02fd03bbe9a0eed8390b56aa2b78a34ca88b52bbce7e1d364dc24e6650a68954e36439102f19a3b332fcb1562260d5223db1e09748eee5d7e6b0cba62dc7cfda9e1e00690f334b9e4b85c710ed77dee42759b48f98df0f05e1adf686351f6232a7d157c9f988248af0c69ec64af0cdbe247',
                //       lastTimestamp: '',
                //       lastContent: '',
                //       typeContent: -1);

                //   firebaseStore
                //       .collection(FirestoreConstants.pathMessageCollection)
                //       .doc(groupChatId)
                //       .withConverter(
                //           fromFirestore: ((snapshot, _) =>
                //               MessageData.fromDocument(snapshot)),
                //           toFirestore: (MessageData msg, options) => msg.toJson())
                //       .update(msgData.toJson())
                //       .then((value) {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) {
                //           return const ChatScreen();
                //         },
                //       ),
                //     );
                //   });
                // } else {
                //   if (fromMsg.docs.isNotEmpty) {
                //     // ignore: use_build_context_synchronously
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) {
                //           return ChatDetailPage(
                //             arguments: ChatPageArguments(
                //               docId: fromMsg.docs.first.id,
                //               peerId: '3',
                //               peerAvatar:
                //                   'https://storage.googleapis.com/washousebucket/anonymous-20230330210147.jpg?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=washouse-sa%40washouse-381309.iam.gserviceaccount.com%2F20230330%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20230330T210148Z&X-Goog-Expires=1800&X-Goog-SignedHeaders=host&X-Goog-Signature=7c813f26489c9ba06cdfff27db9faa2ca4d7c046766aeb3874fdf86ec7c91ae904951f7b2617b6e78598d46f8b91d842d2f4c2a10696539bcf09c839d51d9565831f6c503b3e37f899ab8920f69c3aaa30e0ff2d9c598d1a4c523c1e8038520a32fe49a92c4448c49e602b77312444fe3505afa30da1c4bfbdf0f7a5ab9f2783005c1f3624b3417e17c0067f65f4c02fd03bbe9a0eed8390b56aa2b78a34ca88b52bbce7e1d364dc24e6650a68954e36439102f19a3b332fcb1562260d5223db1e09748eee5d7e6b0cba62dc7cfda9e1e00690f334b9e4b85c710ed77dee42759b48f98df0f05e1adf686351f6232a7d157c9f988248af0c69ec64af0cdbe247',
                //               peerNickname: 'Đoàn Kim Trọng',
                //             ),
                //           );
                //         },
                //       ),
                //     );
                //   }
                //   if (toMsg.docs.isNotEmpty) {
                //     // ignore: use_build_context_synchronously
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) {
                //           return ChatDetailPage(
                //             arguments: ChatPageArguments(
                //               docId: toMsg.docs.first.id,
                //               peerId: '3',
                //               peerAvatar:
                //                   'https://storage.googleapis.com/washousebucket/anonymous-20230330210147.jpg?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=washouse-sa%40washouse-381309.iam.gserviceaccount.com%2F20230330%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20230330T210148Z&X-Goog-Expires=1800&X-Goog-SignedHeaders=host&X-Goog-Signature=7c813f26489c9ba06cdfff27db9faa2ca4d7c046766aeb3874fdf86ec7c91ae904951f7b2617b6e78598d46f8b91d842d2f4c2a10696539bcf09c839d51d9565831f6c503b3e37f899ab8920f69c3aaa30e0ff2d9c598d1a4c523c1e8038520a32fe49a92c4448c49e602b77312444fe3505afa30da1c4bfbdf0f7a5ab9f2783005c1f3624b3417e17c0067f65f4c02fd03bbe9a0eed8390b56aa2b78a34ca88b52bbce7e1d364dc24e6650a68954e36439102f19a3b332fcb1562260d5223db1e09748eee5d7e6b0cba62dc7cfda9e1e00690f334b9e4b85c710ed77dee42759b48f98df0f05e1adf686351f6232a7d157c9f988248af0c69ec64af0cdbe247',
                //               peerNickname: 'Đoàn Kim Trọng',
                //             ),
                //           );
                //         },
                //       ),
                //     );
                //   }
                // }
              },
            ),
            SpeedDialChild(
              child: const ImageIcon(
                AssetImage('assets/icon/qr-code-scan.png'),
                color: Colors.white,
              ),
              label: 'Quét mã qr',
              backgroundColor: kPrimaryColor,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScanQRCodeScreen()));
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.assignment_add,
                color: Colors.white,
              ),
              label: 'Tạo đơn mới',
              backgroundColor: kPrimaryColor,
              onTap: () {
                print(centerDetails.centerServices);
                showDialog(
                    context: context,
                    builder: (context) {
                      return CreateOrderScreen(
                          categoryData: centerDetails.centerServices);
                    });
              },
            )
          ],
        ),
      );
    }
  }
}

// class SalesData {
//   final double day;
//   final double value;

//   SalesData(this.day, this.value);
// }

class SalesData {
  final String day;
  final double value;

  SalesData(this.day, this.value);
}

class ChartData {
  final String category;
  final int value;
  final Color colorCode;

  ChartData(this.category, this.value, this.colorCode);
}
