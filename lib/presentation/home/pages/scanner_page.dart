import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../l10n/app_localizations.dart';
import '../bloc/product/product_bloc.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  MobileScannerController cameraController = MobileScannerController(
    autoStart: false,
    torchEnabled: false,
  );

  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return Text(
        AppLocalizations.of(context)!.scanSomething,
        overflow: TextOverflow.fade,
        style: const TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? AppLocalizations.of(context)!.noDisplayValue,
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      // setState(() {
      _barcode = barcodes.barcodes.firstOrNull;
      // setState(() {});
      if (_barcode != null) {
        cameraController.stop();
        context
            .read<ProductBloc>()
            .add(ProductEvent.searchProduct(_barcode!.displayValue ?? ''));
        //back
        context.pop(context);
      }
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = cameraController.barcodes.listen(_handleBarcode);

    unawaited(cameraController.start());
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await cameraController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!cameraController.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = cameraController.barcodes.listen(_handleBarcode);

        unawaited(cameraController.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(cameraController.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            cameraController.dispose();
            Navigator.pop(context);
          },
        ),
        title: Text(AppLocalizations.of(context)!.scanning),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.auto:
                    return IconButton(
                      color: Colors.white,
                      iconSize: 32.0,
                      icon: const Icon(Icons.flash_auto),
                      onPressed: () async {
                        await cameraController.toggleTorch();
                      },
                    );
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.unavailable:
                    return const Icon(
                      Icons.no_flash,
                      color: Colors.grey,
                    );
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController,
              builder: (context, state, child) {
                if (!state.isInitialized || !state.isRunning) {
                  return const SizedBox.shrink();
                }

                final int? availableCameras = state.availableCameras;

                if (availableCameras != null && availableCameras < 2) {
                  return const SizedBox.shrink();
                }

                final Widget icon;

                switch (state.cameraDirection) {
                  case CameraFacing.front:
                    icon = const Icon(Icons.camera_front);
                    break;
                  case CameraFacing.back:
                    icon = const Icon(Icons.camera_rear);
                    break;
                  case CameraFacing.external:
                    icon = const Icon(Icons.videocam);
                    break;
                  case CameraFacing.unknown:
                  default:
                    icon = const Icon(Icons.camera_alt);
                    break;
                }

                return IconButton(
                  iconSize: 32.0,
                  icon: icon,
                  onPressed: () async {
                    await cameraController.switchCamera();
                  },
                );
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.black.withValues(alpha: 0.5),
              child: _buildBarcode(_barcode),
            ),
          ),
        ],
      ),
    );
  }
}
