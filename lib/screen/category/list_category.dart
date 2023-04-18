import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/resource/model/service.dart';

import '../../components/constants/color_constants.dart';
import '../../resource/controller/base_controller.dart';
import '../../resource/controller/center_controller.dart';
import '../../resource/model/center.dart';
import '../notification/list_notification_screen.dart';

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

BaseController baseController = BaseController();
CenterController centerController = CenterController();

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  TextEditingController searchController = TextEditingController();
  List<CenterServices> catetList = [];
  int? _centerId;
  bool _categoryTileExpanded = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    final centerId = await baseController.getInttoSharedPreference("CENTER_ID");
    setState(() {
      _centerId = (centerId != 0 ? centerId : 0)!;
      getCenterDetail(_centerId!);
    });
  }

  void getCenterDetail(int id) async {
    centerController.getCenterById(id).then(
      (result) {
        setState(() {
          catetList = result.centerServices!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 24,
          ),
        ),
        centerTitle: true,
        title: const Text('Danh sách dịch vụ',
            style: TextStyle(color: textColor, fontSize: 25)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: const ListNotificationScreen(),
                      type: PageTransitionType.rightToLeftWithFade));
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
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                hintStyle: TextStyle(
                    color: Colors.grey.shade500, height: 1, fontSize: 15),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              style: TextStyle(
                  color: Colors.grey.shade700, height: 1, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: catetList.length,
                  itemBuilder: (context, cateIndex) {
                    return ExpansionTile(
                      leading: Icon(Icons.category_rounded),
                      title:
                          Text('${catetList[cateIndex].serviceCategoryName}'),
                      trailing: Icon(Icons.keyboard_arrow_down_rounded),
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: catetList[cateIndex].services?.length,
                            itemBuilder: (context, serviceIndex) {
                              var serviceList = catetList[cateIndex].services
                                  as List<ServiceCenter>;
                              return Padding(
                                padding: const EdgeInsets.only(left: 55),
                                child: ListTile(
                                  title: Text(
                                    '${serviceList[serviceIndex].serviceName}',
                                    maxLines: 2,
                                  ),
                                ),
                              );
                            }),
                      ],
                      // onExpansionChanged: (bool expanded) {
                      //   setState(() => _categoryTileExpanded = expanded);
                      // },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
