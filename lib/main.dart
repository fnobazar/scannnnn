import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const ScannnnnApp());
}

class ScannnnnApp extends StatelessWidget {
  const ScannnnnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'scannnnn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ScannerScreen(),
    );
  }
}

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String result = "Scan a QR or Barcode";
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('scannnnn - Scanner'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.flash_on), onPressed: () => controller.toggleTorch()),
          IconButton(icon: const Icon(Icons.cameraswitch), onPressed: () => controller.switchCamera()),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                for (final barcode in capture.barcodes) {
                  if (barcode.rawValue != null) {
                    setState(() => result = barcode.rawValue!);
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.black87,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Result:', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  SelectableText(result, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
