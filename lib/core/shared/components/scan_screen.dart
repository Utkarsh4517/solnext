import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:solnext/core/shared/components/buy_sheet.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/shared/components/send_money.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  CameraController? _cameraController;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isDetecting = false;
  String _scannedCode = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    setState(() {
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
    });

    try {
      await _cameraController!.initialize();
      await _cameraController!.startImageStream(_processCameraImage);
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final imageRotation = InputImageRotation.rotation0deg;
    final inputImageFormat = InputImageFormat.yuv420;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );

    try {
      final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

      for (Barcode barcode in barcodes) {
        setState(() {
          _scannedCode = barcode.rawValue ?? '';
        });
        break; // We only need the first detected QR code
      }
    } catch (e) {
      print("Error processing image: $e");
    }

    _isDetecting = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          _cameraController != null && _cameraController!.value.isInitialized ? CameraPreview(_cameraController!) : Container(color: Colors.black),

          // Overlay
          SafeArea(
            child: Column(
              children: [
                Expanded(child: Container()),
                if (_scannedCode.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PrimaryButton(
                      text: 'Send Crypto',
                      onPressed: _copyToClipboard,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _scannedCode));
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SendMoneySheet(toAddress: _scannedCode),
        );
      },
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _barcodeScanner.close();
    super.dispose();
  }
}
