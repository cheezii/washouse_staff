import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/components/constants/color_constants.dart';

import '../../category/list_category.dart';
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
  Color boxChooseColor = kPrimaryColor;

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
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/avatar/10.jpg'),
                ),
                title: Text(
                  'Tên nhân viên',
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
                title: 'Đánh giá',
                icon: Icons.star_rounded,
                press: () => selectedItem(context, 3),
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
                press: () => selectedItem(context, 4),
              ),
              MenuItemCard(
                title: 'Đăng xuất',
                icon: Icons.logout_rounded,
                press: () => selectedItem(context, 5),
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
      case 4:
        Navigator.push(
            context,
            PageTransition(
                child: const InfomationScreen(),
                type: PageTransitionType.fade));
        break;
    }
  }
}
