import 'dart:io';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ShareReceipt {
  Future<void> shareTransaction({
    required ScreenshotController screenshotController,
    required String transactionId,
  }) async {
    try {
      // Capture screenshot
      final image = await screenshotController.capture();
      if (image == null) return;

      // Get temp directory
      final directory = await getTemporaryDirectory();

      // Create file
      final file = File(
        '${directory.path}/transaction_$transactionId.png',
      );

      await file.writeAsBytes(image);

      // Share
      // await Share.shareXFiles(
      //   [XFile(file.path)],
      //   text: "Here’s transaction receipt",
      // );

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: "Here’s transaction receipt"
        )
      );
    } catch (e) {
      // Let UI decide how to react
      rethrow;
    }
  }
}
