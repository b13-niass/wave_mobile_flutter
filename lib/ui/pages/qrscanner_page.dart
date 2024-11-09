import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      // Permission granted, proceed with camera
    } else {
      // Show a message to the user about the need for permission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission is required to scan QR codes.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _foundBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: const Text(
                'Placez le QR code dans le cadre',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _foundBarcode(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    if (!_screenOpened) {
      final String code = barcodes.first.rawValue ?? "---";
      debugPrint('Barcode found! $code');
      _screenOpened = true;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            code: code,
            closeScreen: _closeScreen,
          ),
        ),
      );
    }
  }

  void _closeScreen() {
    _screenOpened = false;
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

// Result Screen for Displaying Scanned QR Code
class ResultScreen extends StatelessWidget {
  final String code;
  final Function() closeScreen;

  const ResultScreen({
    Key? key,
    required this.code,
    required this.closeScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            closeScreen();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'QR Code scanné :',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Text(
                code,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
