import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../../../components/constants/color_constants.dart';
import '../../../../resource/model/cart_item_view.dart';
import '../../../../resource/model/center.dart';
import '../../../../resource/model/service.dart';
import '../../../../resource/provider/cart_provider.dart';

class AddToCartDialog extends StatefulWidget {
  final List<CenterServices> cateList;
  const AddToCartDialog({super.key, required this.cateList});

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  final _dropDownServiceKey = GlobalKey<FormBuilderFieldState>();
  CenterServices? cateChoosen;
  ServiceCenter? serviceChoosen;
  double priceOfService = 0;
  double measurementOfService = 0;
  double unitPriceOfService = 0;
  String? noteServiceOfCustomer;

  List<CenterServices> categoryList = [];
  List<ServiceCenter> serviceList = [];
  List<OrderDetailItem> addedItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryList = widget.cateList;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CartProvider>(context);
    return AlertDialog(
      title: const Align(alignment: Alignment.center, child: Text('Thêm dịch vụ')),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Chọn loại dịch vụ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            // ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: lengthAddCate,
            //     itemBuilder: ((context, index) {

            //       return Padding(
            //         padding: const EdgeInsets.only(bottom: 8),
            //         child:
            DropdownButtonFormField(
              items: categoryList.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item.serviceCategoryName!),
                );
              }).toList(),
              value: cateChoosen,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
              ),
              hint: const Text(
                'Chọn loại dịch vụ',
                style: TextStyle(fontSize: 16, color: textNoteColor),
              ),
              style: const TextStyle(fontSize: 16, color: textColor),
              onChanged: (value) {
                int index = categoryList.indexOf(value as CenterServices);
                setState(() {
                  cateChoosen = value;
                  serviceList = categoryList[index].services as List<ServiceCenter>;
                  _dropDownServiceKey.currentState!.reset();
                  _dropDownServiceKey.currentState!.setValue(null);
                });
              },
            ),
            //       );
            //     })),
            // const SizedBox(height: 5),
            // ListTile(
            //   title: Text('Thêm loại dịch vụ'),
            //   leading: Icon(
            //     Icons.add_box_rounded,
            //     color: kPrimaryColor,
            //   ),
            //   onTap: () {
            //     setState(() {
            //       if (lengthAddCate < catetList.length) lengthAddCate++;
            //     });
            //   },
            // ),
            const SizedBox(height: 15),
            const Text(
              'Chọn dịch vụ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            FormBuilderDropdown(
              key: _dropDownServiceKey,
              name: 'Dịch vụ',
              items: serviceList.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item.serviceName!),
                );
              }).toList(),
              //value: serviceChoosen,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
              ),
              hint: const Text(
                'Chọn dịch vụ',
                style: TextStyle(fontSize: 16, color: textNoteColor),
              ),
              onChanged: (value) {
                setState(() {
                  serviceChoosen = value;
                });
              },
            ),
            const SizedBox(height: 15),
            const Text(
              'Số lượng/Khối lượng:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  hintText: 'Nhập số lượng/khối lượng',
                  hintStyle: TextStyle(
                    color: textNoteColor,
                  ),
                ),
                onChanged: (value) {
                  if (serviceChoosen != null) {
                    //Kiểm tra unit Price nằm trong khoảng nào
                    double currentPrice = 0;
                    double totalCurrentPrice = 0;
                    var measurementInput = double.parse(value);

                    print(measurementInput);
                    if (serviceChoosen!.priceType!) {
                      bool check = false;
                      for (var itemPrice in serviceChoosen!.prices!) {
                        if (measurementInput <= itemPrice.maxValue! && !check) {
                          currentPrice = itemPrice.price!.toDouble();
                        }
                        if (currentPrice > 0) {
                          check = true;
                        }
                      }
                      if (serviceChoosen!.minPrice != null && currentPrice * measurementInput < serviceChoosen!.minPrice!) {
                        totalCurrentPrice = serviceChoosen!.minPrice!.toDouble();
                      } else {
                        totalCurrentPrice = currentPrice * measurementInput;
                      }
                    } else {
                      totalCurrentPrice = serviceChoosen!.price! * measurementInput.toDouble();
                      currentPrice = serviceChoosen!.price!.toDouble();
                    }
                    setState(() {
                      measurementOfService = measurementInput;
                      priceOfService = totalCurrentPrice;
                      unitPriceOfService = currentPrice;
                      print(priceOfService);
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Ghi chú:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  hintText: 'Nhập ghi chú',
                  hintStyle: TextStyle(
                    color: textNoteColor,
                  ),
                ),
                style: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
                onChanged: (value) {
                  setState(() {
                    noteServiceOfCustomer = value;
                    print(noteServiceOfCustomer);
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text(
            //       'Tổng giá tiền dịch vụ:',
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            //     ),
            //     Text(
            //       '$priceOfService',
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              measurementOfService = 0;
              priceOfService = 0;
              unitPriceOfService = 0;
              noteServiceOfCustomer = null;
            });
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
            elevation: 0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: cancelledColor, width: 1),
            ),
          ),
          child: Text(
            'Hủy bỏ',
            style: TextStyle(
              color: cancelledColor,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              var orderDetailItem = OrderDetailItem(
                serviceId: serviceChoosen!.serviceId!.toInt(),
                serviceName: serviceChoosen!.serviceName!,
                priceType: serviceChoosen!.priceType!,
                price: priceOfService,
                unitPrice: unitPriceOfService,
                measurement: measurementOfService,
                customerNote: noteServiceOfCustomer,
                weight: serviceChoosen!.rate!.toDouble() * measurementOfService,
                minPrice: serviceChoosen!.minPrice == null ? null : serviceChoosen!.minPrice!.toDouble(),
                prices: serviceChoosen!.prices,
                unit: serviceChoosen!.unit,
                staffNote: null,
              );
              provider.addOrderDetailItemToCart(orderDetailItem); //add to cart
              measurementOfService = 0;
              priceOfService = 0;
              unitPriceOfService = 0;
              noteServiceOfCustomer = null;
            });
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 19, vertical: 10),
              foregroundColor: kPrimaryColor.withOpacity(.7),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: kPrimaryColor.withOpacity(.5), width: 1),
              ),
              backgroundColor: kPrimaryColor),
          child: const Text(
            'Thêm vào đơn hàng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
