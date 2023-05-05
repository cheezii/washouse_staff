import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:skeletons/skeletons.dart';
import 'package:washouse_staff/resource/model/service.dart';
import 'package:washouse_staff/utils/price_util.dart';

import '../../components/constants/color_constants.dart';
import '../../resource/controller/base_controller.dart';
import '../../resource/controller/center_controller.dart';
import '../../resource/model/center.dart';
import '../../resource/provider/notify_provider.dart';
import '../notification/list_notification_screen.dart';
import 'components/list_categories_skeleton.dart';

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

BaseController baseController = BaseController();
CenterController centerController = CenterController();
NotifyProvider notifyProvider = NotifyProvider();

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  TextEditingController searchController = TextEditingController();
  List<CenterServices> catetList = [];
  int? _centerId;
  bool _categoryTileExpanded = false;
  bool isLoading = true;

  @override
  void initState() {
    _loadData();
    super.initState();
    notifyProvider.addListener(() => mounted ? setState(() {}) : null);
    notifyProvider.getNoti();
  }

  @override
  void dispose() {
    notifyProvider.removeListener(() {});
    super.dispose();
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
          isLoading = false;
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
      body: SingleChildScrollView(
        child: Padding(
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
              Skeleton(
                isLoading: isLoading,
                skeleton: const ListCategoriesSkeleton(),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: catetList.length,
                    itemBuilder: (context, cateIndex) {
                      return ExpansionTile(
                        leading: const Icon(Icons.category_rounded),
                        title:
                            Text('${catetList[cateIndex].serviceCategoryName}'),
                        trailing: const Icon(Icons.keyboard_arrow_down_rounded),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: catetList[cateIndex].services?.length,
                              itemBuilder: (context, serviceIndex) {
                                var serviceList = catetList[cateIndex].services
                                    as List<ServiceCenter>;
                                var priceList = serviceList[serviceIndex].prices
                                    as List<Prices>;
                                return Padding(
                                  padding: const EdgeInsets.only(left: 55),
                                  child: ListTile(
                                    title: Text(
                                      '${serviceList[serviceIndex].serviceName}',
                                      maxLines: 2,
                                    ),
                                    trailing: priceList.isEmpty
                                        ? Text(
                                            '${PriceUtils().convertFormatPrice(serviceList[serviceIndex].price!.round())} đ/${serviceList[serviceIndex].unit!.toLowerCase()}',
                                            style: const TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w500),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    title: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Bảng giá'),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'Giá dịch vụ tối thiểu: ',
                                                              style: TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                            Text(
                                                              '${PriceUtils().convertFormatPrice(serviceList[serviceIndex].minPrice!.round())} đ',
                                                              style: const TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        DataTable(
                                                          columns: const <
                                                              DataColumn>[
                                                            DataColumn(
                                                              label: Text(
                                                                'Tối đa',
                                                                style: TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                'Giá thành',
                                                                style: TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                              ),
                                                            ),
                                                          ],
                                                          rows: priceList
                                                              .map<DataRow>(
                                                                  (e) =>
                                                                      DataRow(
                                                                          cells: [
                                                                            DataCell(Text(e.maxValue.toString() +
                                                                                ' ${serviceList[serviceIndex].unit!.toLowerCase()}')),
                                                                            DataCell(Text('${PriceUtils().convertFormatPrice(e.price?.round() as num)} đ/${serviceList[serviceIndex].unit!.toLowerCase()}')),
                                                                          ]))
                                                              .toList(),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.info_outline_rounded,
                                              color: kPrimaryColor,
                                            )),
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
      ),
    );
  }
}
