import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/backupAndRestore/viewModel/backup_and_restore_viewmodel.dart';

class QrImportView extends StatefulWidget {
  const QrImportView({super.key});

  @override
  State<QrImportView> createState() => _QrImportViewState();
}

class _QrImportViewState extends State<QrImportView> {
  final BackupAndRestoreViewModel _viewModel =
      instance<BackupAndRestoreViewModel>();
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleQrCode(BarcodeCapture capture) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final String? code = capture.barcodes.first.rawValue;

      if (code != null && code.isNotEmpty) {
        await _viewModel.restoreDataFromQr(code);
        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      } else {
        throw Exception('Invalid QR code data');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _toggleTorch() {
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
    _scannerController.toggleTorch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          t.qrSettings.scan,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _isTorchOn
                  ? Colors.yellow.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                _isTorchOn ? Icons.flash_on : Icons.flash_off,
                color: _isTorchOn ? Colors.yellow : Colors.white,
              ),
              onPressed: _toggleTorch,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleQrCode,
          ),

          _buildScanningOverlay(),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return Container(
      decoration: ShapeDecoration(
        shape: QrScannerOverlayShape(
          borderColor: Theme.of(context).colorScheme.primary,
          borderRadius: 16,
          borderLength: 40,
          borderWidth: 4,
          cutOutSize: MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  const QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.borderRadius = 12,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top + borderRadius)
        ..quadraticBezierTo(
          rect.left,
          rect.top,
          rect.left + borderRadius,
          rect.top,
        )
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final cutOutWidth = cutOutSize;
    final cutOutHeight = cutOutSize;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final backgroundPath = Path()
      ..addRect(rect)
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: rect.center,
            width: cutOutWidth,
            height: cutOutHeight,
          ),
          Radius.circular(borderRadius),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final borderPath = Path();

    // Top-left corner
    borderPath.moveTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2 + borderRadius,
    );
    borderPath.quadraticBezierTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2,
      rect.center.dx - cutOutWidth / 2 + borderRadius,
      rect.center.dy - cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx - cutOutWidth / 2 + borderLength,
      rect.center.dy - cutOutHeight / 2,
    );

    borderPath.moveTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2 + borderLength,
    );
    borderPath.lineTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2 + borderRadius,
    );

    // Top-right corner
    borderPath.moveTo(
      rect.center.dx + cutOutWidth / 2 - borderLength,
      rect.center.dy - cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx + cutOutWidth / 2 - borderRadius,
      rect.center.dy - cutOutHeight / 2,
    );
    borderPath.quadraticBezierTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2,
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2 + borderRadius,
    );
    borderPath.lineTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy - cutOutHeight / 2 + borderLength,
    );

    // Bottom-right corner
    borderPath.moveTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2 - borderLength,
    );
    borderPath.lineTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2 - borderRadius,
    );
    borderPath.quadraticBezierTo(
      rect.center.dx + cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2,
      rect.center.dx + cutOutWidth / 2 - borderRadius,
      rect.center.dy + cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx + cutOutWidth / 2 - borderLength,
      rect.center.dy + cutOutHeight / 2,
    );

    // Bottom-left corner
    borderPath.moveTo(
      rect.center.dx - cutOutWidth / 2 + borderLength,
      rect.center.dy + cutOutHeight / 2,
    );
    borderPath.lineTo(
      rect.center.dx - cutOutWidth / 2 + borderRadius,
      rect.center.dy + cutOutHeight / 2,
    );
    borderPath.quadraticBezierTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2,
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2 - borderRadius,
    );
    borderPath.lineTo(
      rect.center.dx - cutOutWidth / 2,
      rect.center.dy + cutOutHeight / 2 - borderLength,
    );

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
