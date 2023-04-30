import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timelines/timelines.dart';

import '../../components/constants/color_constants.dart';
import '../../utils/order_util.dart';
import '../order/components/details_widget/service_details.dart';

class DelivertOrderDetails extends StatefulWidget {
  const DelivertOrderDetails({super.key});

  @override
  State<DelivertOrderDetails> createState() => _DelivertOrderDetailsState();
}

class _DelivertOrderDetailsState extends State<DelivertOrderDetails> {
  late int _processIndex;

  Color getColor(int index) {
    if (index == _processIndex) {
      return kPrimaryColor;
    } else if (index < _processIndex) {
      return kPrimaryColor;
    } else {
      return Colors.grey.shade400;
    }
  }

  @override
  void initState() {
    super.initState();
    // if (widget.status == 'Đang chờ') {
    //   _processIndex = 0;
    // } else if (widget.status == 'Xác nhận') {
    //   _processIndex = 1;
    // } else if (widget.status == 'Xử lý') {
    //   _processIndex = 2;
    // } else if (widget.status == 'Sẵn sàng') {
    //   _processIndex = 3;
    // } else if (widget.status == 'Hoàn tất') {
    //   _processIndex = 4;
    // }
    _processIndex = 1;
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
        title: const Text('Chi tiết vận chuyển',
            style: TextStyle(color: textColor, fontSize: 25)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin vận chuyển',
                style: TextStyle(
                    color: textColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: textColor, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Chiều đi',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          'trạng thái',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'Nhân viên',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Align(
                                  alignment: Alignment.center,
                                  child: Text('Vận chuyển đơn'),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      style: const TextStyle(
                                        color: textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Tên nhân viên vận chuyển',
                                        labelStyle: const TextStyle(
                                          color: textColor,
                                          fontSize: 18,
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade500,
                                        ),
                                        // enabledBorder: OutlineInputBorder(
                                        //     borderSide: BorderSide(
                                        //         width: 1,
                                        //         color: Colors.grey.shade400)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5),
                                        hintText: 'Nhập họ và tên nhân viên',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      cursorColor: textColor.withOpacity(.8),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      style: const TextStyle(
                                        color: textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'SĐT nhân viên vận chuyển',
                                        labelStyle: const TextStyle(
                                          color: textColor,
                                          fontSize: 18,
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade500,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5),
                                        hintText: 'Nhập SĐT nhân viên',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      cursorColor: textColor.withOpacity(.8),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsetsDirectional
                                                .symmetric(
                                            horizontal: 19, vertical: 10),
                                        foregroundColor:
                                            kPrimaryColor.withOpacity(.7),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                              color:
                                                  kPrimaryColor.withOpacity(.5),
                                              width: 1),
                                        ),
                                        backgroundColor: kPrimaryColor),
                                    child: const Text(
                                      'Cập nhật',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 19, vertical: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: kPrimaryColor.withOpacity(.5),
                                  width: 1),
                            ),
                            backgroundColor: kPrimaryColor,
                          ),
                          child: const Text(
                            'Chọn NV',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Họ và tên: họ và tên',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Số điện thoại: số điện thoại',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Địa chỉ lấy đơn',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'địa chỉ',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 19, vertical: 10),
                              foregroundColor: kPrimaryColor.withOpacity(.7),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    color: kPrimaryColor.withOpacity(.5),
                                    width: 1),
                              ),
                              backgroundColor: kPrimaryColor),
                          child: const Text(
                            'Cập nhật vận chuyển',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: textColor, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Chiều về',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          'trạng thái',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'Nhân viên',
                          style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Align(
                                  alignment: Alignment.center,
                                  child: Text('Vận chuyển đơn'),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      style: const TextStyle(
                                        color: textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Tên nhân viên vận chuyển',
                                        labelStyle: const TextStyle(
                                          color: textColor,
                                          fontSize: 18,
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade500,
                                        ),
                                        // enabledBorder: OutlineInputBorder(
                                        //     borderSide: BorderSide(
                                        //         width: 1,
                                        //         color: Colors.grey.shade400)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5),
                                        hintText: 'Nhập họ và tên nhân viên',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      cursorColor: textColor.withOpacity(.8),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      style: const TextStyle(
                                        color: textColor,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'SĐT nhân viên vận chuyển',
                                        labelStyle: const TextStyle(
                                          color: textColor,
                                          fontSize: 18,
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade500,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5),
                                        hintText: 'Nhập SĐT nhân viên',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      cursorColor: textColor.withOpacity(.8),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsetsDirectional
                                                .symmetric(
                                            horizontal: 19, vertical: 10),
                                        foregroundColor:
                                            kPrimaryColor.withOpacity(.7),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                              color:
                                                  kPrimaryColor.withOpacity(.5),
                                              width: 1),
                                        ),
                                        backgroundColor: kPrimaryColor),
                                    child: const Text(
                                      'Cập nhật',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 19, vertical: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: kPrimaryColor.withOpacity(.5),
                                  width: 1),
                            ),
                            backgroundColor: kPrimaryColor,
                          ),
                          child: const Text(
                            'Chọn NV',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Họ và tên: họ và tên',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Số điện thoại: số điện thoại',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Địa chỉ lấy đơn',
                      style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'địa chỉ',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 19, vertical: 10),
                              foregroundColor: kPrimaryColor.withOpacity(.7),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    color: kPrimaryColor.withOpacity(.5),
                                    width: 1),
                              ),
                              backgroundColor: kPrimaryColor),
                          child: const Text(
                            'Cập nhật vận chuyển',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Trạng thái đơn hàng',
                style: TextStyle(
                    color: textColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: double.infinity,
                height: 90,
                child: Timeline.tileBuilder(
                  theme: TimelineThemeData(
                    direction: Axis.horizontal,
                    connectorTheme: const ConnectorThemeData(
                      space: 30.0,
                      thickness: 5.0,
                    ),
                  ),
                  builder: TimelineTileBuilder.connected(
                    connectionDirection: ConnectionDirection.before,
                    itemExtentBuilder: (_, __) =>
                        MediaQuery.of(context).size.width / _processes.length,
                    contentsBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          _processes[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getColor(index),
                          ),
                        ),
                      );
                    },
                    indicatorBuilder: (_, index) {
                      var color;
                      var child;
                      if (index == _processIndex) {
                        color = kPrimaryColor;
                        child = const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        );
                      } else if (index < _processIndex) {
                        color = kPrimaryColor;
                        child = const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15.0,
                        );
                      } else {
                        color = Colors.grey.shade400;
                      }
                      if (_processIndex == 5) {
                        color = kPrimaryColor;
                        child = const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15.0,
                        );
                      }
                      if (index <= _processIndex) {
                        return Stack(
                          children: [
                            CustomPaint(
                              size: Size(30.0, 30.0),
                              painter: _BezierPainter(
                                color: color,
                                drawStart: index > 0,
                                drawEnd: index < _processIndex,
                              ),
                            ),
                            DotIndicator(
                              size: 30.0,
                              color: color,
                              child: child,
                            ),
                          ],
                        );
                      } else {
                        return Stack(
                          children: [
                            CustomPaint(
                              size: Size(15.0, 15.0),
                              painter: _BezierPainter(
                                color: color,
                                drawEnd: index < _processes.length - 1,
                              ),
                            ),
                            OutlinedDotIndicator(
                              borderWidth: 4.0,
                              color: color,
                            ),
                          ],
                        );
                      }
                    },
                    connectorBuilder: (_, index, type) {
                      if (index > 0) {
                        if (index == _processIndex) {
                          final prevColor = getColor(index - 1);
                          final color = getColor(index);
                          List<Color> gradientColors;
                          if (type == ConnectorType.start) {
                            gradientColors = [
                              Color.lerp(prevColor, color, 0.5)!,
                              color
                            ];
                          } else {
                            gradientColors = [
                              prevColor,
                              Color.lerp(prevColor, color, 0.5)!
                            ];
                          }
                          return DecoratedLineConnector(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                              ),
                            ),
                          );
                        } else {
                          return SolidLineConnector(
                            color: getColor(index),
                          );
                        }
                      } else {
                        return null;
                      }
                    },
                    itemCount: _processes.length,
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Text(
                'Chi tiết đơn hàng',
                style: TextStyle(
                    color: textColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Chi tiết trong comment bên dưới',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                ),
              ),
              //DetailService(status: OrderUtils().mapVietnameseOrderStatus(status), order_infomation: order_infomation),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin thanh toán',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 21,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng đơn hàng:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'tiền đ',
                            style: const TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Phí vận chuyển:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'tiền đ',
                            //'${order_infomation.deliveryPrice!.toDouble().round()} đ',
                            style: const TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Phí nền tảng:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '0 đ',
                            style: TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Chiết khấu:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '- tiền đ',
                            style: const TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Divider(
                        height: 40,
                        color: Colors.grey.shade300,
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng thanh toán:',
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            'tiền đ',
                            style: const TextStyle(
                                fontSize: 17,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xffdadada).withOpacity(0.15),
            ),
          ],
        ),
        child: SizedBox(
          width: 190,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: kPrimaryColor),
            onPressed: () {},
            child: const Text(
              'Hoàn tất thanh toán',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }

  Column separateLine() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Divider(thickness: 5, color: Colors.grey.shade200),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = [
  'Đang chờ',
  'Xác nhận',
  'Đã nhận',
  'Xử lý',
  'Sẵn sàng',
  'Hoàn tất',
];
