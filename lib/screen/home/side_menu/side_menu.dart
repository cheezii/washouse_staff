import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/components/constants/color_constants.dart';
import 'package:washouse_staff/resource/controller/base_controller.dart';
import 'package:washouse_staff/screen/started/login.dart';

import '../../category/list_category.dart';
import '../../delivery/delivery_list.dart';
import '../../feedback/feedback_screen.dart';
import '../../order/order_list_screen.dart';
import '../../profile/information_screen.dart';
import '../home_screen.dart';
import 'components/menu_item_card.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  BaseController baseController = BaseController();
  Color boxChooseColor = kPrimaryColor;
  String? _CustomerName;
  String? _CustomerAvatar;

  void _loadData() async {
    String? name =
        await baseController.getStringtoSharedPreference("CURRENT_USER_NAME");
    String? avatar =
        await baseController.getStringtoSharedPreference("CURRENT_USER_AVATAR");
    setState(() {
      _CustomerName = name;
      _CustomerAvatar = avatar;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 288,
        height: double.infinity,
        color: kPrimaryColor,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: _CustomerAvatar == null
                    ? const CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:
                            AssetImage('assets/images/avatar/10.jpg'),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(_CustomerAvatar!),
                      ),
                title: Text(
                  '$_CustomerName',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40, bottom: 15, top: 15),
                child: Text(
                  'TRUNG TÂM',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
              MenuItemCard(
                title: 'Trang chủ',
                icon: Icons.home_rounded,
                press: () => selectedItem(context, 0),
              ),
              MenuItemCard(
                title: 'Danh sách dịch vụ',
                icon: Icons.category_rounded,
                press: () => selectedItem(context, 1),
              ),
              MenuItemCard(
                title: 'Đơn hàng',
                icon: Icons.assignment_rounded,
                press: () => selectedItem(context, 2),
              ),
              MenuItemCard(
                title: 'Vận chuyển',
                icon: Icons.motorcycle_rounded,
                press: () => selectedItem(context, 3),
              ),
              MenuItemCard(
                title: 'Đánh giá',
                icon: Icons.star_rounded,
                press: () => selectedItem(context, 4),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40, bottom: 15, top: 15),
                child: Text(
                  'CÁ NHÂN',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
              MenuItemCard(
                title: 'Hồ sơ',
                icon: Icons.person,
                press: () => selectedItem(context, 5),
              ),
              MenuItemCard(
                title: 'Đăng xuất',
                icon: Icons.logout_rounded,
                press: () => selectedItem(context, 6),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget sMenuButton(String tilte, GestureTapCallback press) {
    return Padding(
      padding: const EdgeInsets.only(left: 55),
      child: ListTile(
        title: Text(
          tilte,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        onTap: press,
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListCategoryScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const OrderListScreen()));
        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ListDeliveryScreen()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FeedbackScreen()));
        break;
      case 5:
        Navigator.push(
            context,
            PageTransition(
                child: const InfomationScreen(),
                type: PageTransitionType.fade));
        break;
      case 6:
        Navigator.push(
            context,
            PageTransition(
                child: const Login(), type: PageTransitionType.fade));
        break;
    }
  }
}
