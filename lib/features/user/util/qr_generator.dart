import 'dart:convert';
import 'dart:math';

class QrGenerator {
  static String generateEntryPayload(int userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final nonce = _generateNonce(6);
    return jsonEncode({
      'uid': userId,
      'ts': timestamp,
      'nc': nonce,
    });
  }

  static String _generateNonce(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ));
  }
}