import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/qr_provider.dart';

import 'package:screen_protector/screen_protector.dart';

class QrEntryModalContent extends ConsumerStatefulWidget {
  const QrEntryModalContent({super.key});

  @override
  ConsumerState<QrEntryModalContent> createState() => _QrEntryModalContentState();
}

class _QrEntryModalContentState extends ConsumerState<QrEntryModalContent> {
  @override
  void initState() {
    super.initState();
    _secureScreen();
  }

  @override
  void dispose() {
    _unsecureScreen();
    super.dispose();
  }

  Future<void> _secureScreen() async {
    await ScreenProtector.preventScreenshotOn();
  }

  Future<void> _unsecureScreen() async {
    await ScreenProtector.preventScreenshotOff();
  }

  @override
  Widget build(BuildContext context) {
    final qrCodeAsync = ref.watch(qrEntryCodeProvider);

    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Twój kod wejścia',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildQrFrame(qrCodeAsync),
          const SizedBox(height: 24),

          qrCodeAsync.when(
            data: (_) {
              final double targetProgress = 1 - (DateTime.now().millisecondsSinceEpoch % 15000) / 15000;

              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: targetProgress, end: targetProgress),
                duration: const Duration(milliseconds: 50),
                builder: (context, value, child) {
                  return Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            minHeight: 6,
                            value: value,
                            backgroundColor: Colors.white10,
                            color: value < 0.3 ? AppColors.error : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kod wygaśnie za: ${(value * 15).toStringAsFixed(0)}s',
                        style: const TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  );
                },
              );
            },
            loading: () => const SizedBox(height: 30),
            error: (_, _) => const SizedBox.shrink(),
          ),


          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQrFrame(AsyncValue<String> qrCodeAsync) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: qrCodeAsync.when(
        data: (code) => QrImageView(
          data: code,
          size: 200,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: Colors.black,
          ),
          version: QrVersions.auto,
        ),
        loading: () => const SizedBox(
          width: 200, height: 200,
          child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ),
        error: (_, _) => const SizedBox(
          width: 200, height: 200,
          child: Center(child: Icon(Icons.error_outline, color: AppColors.error, size: 50)),
        ),
      ),
    );
  }
}