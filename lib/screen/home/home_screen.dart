import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/screen/home/scan_qr_code.dart';
import 'package:washouse_staff/screen/home/side_menu/side_menu.dart';
import 'package:washouse_staff/screen/order/create_order_screen.dart';
import 'package:washouse_staff/utils/price_util.dart';

import '../../components/constants/color_constants.dart';
import '../../resource/controller/center_controller.dart';
import '../../resource/model/center.dart';
import '../notification/list_notification_screen.dart';
import '../order/add_item_to_cart.dart';

class HomeScreen extends StatefulWidget {
  final centerId;
  const HomeScreen({super.key, this.centerId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  CenterController centerController = CenterController();
  LaundryCenter centerDetails = LaundryCenter();
  bool isLoadingDetail = true;

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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1), () {
      getCenterDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Trang chủ', style: TextStyle(color: textColor, fontSize: 24)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, PageTransition(child: const ListNotificationScreen(), type: PageTransitionType.rightToLeftWithFade));
            },
            icon: const Icon(
              Icons.notifications,
              color: textColor,
              size: 30.0,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Text(
              'Quản lý đơn hàng',
              style: TextStyle(fontSize: 20, color: textBoldColor, fontWeight: FontWeight.w600),
            ),
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
            onTap: () {},
          ),
          SpeedDialChild(
            child: const ImageIcon(
              AssetImage('assets/icon/qr-code-scan.png'),
              color: Colors.white,
            ),
            label: 'Quét mã qr',
            backgroundColor: kPrimaryColor,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanQRCodeScreen()));
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
                    return AddToCartScreen(categoryData: centerDetails.centerServices);
                  });
            },
          )
        ],
      ),
    );
  }
}
