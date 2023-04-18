import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:washouse_staff/components/constants/color_constants.dart';
import 'package:washouse_staff/resource/controller/order_controller.dart';
import 'package:washouse_staff/resource/model/order.dart';
import 'package:washouse_staff/resource/model/order_infomation.dart';
import 'package:washouse_staff/screen/home/home_screen.dart';
import 'package:washouse_staff/screen/order/order_detail_screen.dart';

class ScanQRCodeScreen extends StatefulWidget {
  const ScanQRCodeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  OrderController orderController = OrderController();
  Order order = Order();
  QRViewController? controller;
  Barcode? result;
  bool _isScanning = true;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child:
                  Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildQrView(context),
          if (result != null) _buildResultView(context),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: kPrimaryColor,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (_isScanning) {
        setState(() {
          result = scanData;
        });
        _isScanning = false;
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Widget _buildResultView(BuildContext context) {
    // navigate to details page on barcode scan
    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderId: result!.code!),
        ),
      );
    });

    return Container();
  }
}
