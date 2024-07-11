import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  String qrCode = 'Scan a QR code';
  final MobileScannerController controller = MobileScannerController(
    autoStart: true,
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Scan QR'),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                color: Colors.black12,
                child: MobileScanner(
                  onDetect: (barcode) {
                    if (barcode.barcodes.isEmpty) return;
                    final String code = barcode.barcodes.first.rawValue ?? '';
                    setState(() {
                      qrCode = code;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            qrCode,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
