import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'http://192.168.42.156:5050';

  /// Sends image to backend and returns PNG bytes without background.
  static Future<Uint8List?> removeBackground(File imageFile) async {
    try {
      final uri = Uri.parse('$baseUrl/remove-bg');

      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      log('Sending image: ${imageFile.path}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        log('Background removed successfully.');
        return response.bodyBytes;
      } else {
        log('Failed: ${response.statusCode} - ${response.body}');
        return Uint8List(0);
      }
    } on SocketException catch (e) {
      log('Network error: $e');
      return Uint8List(0);
    } on http.ClientException catch (e) {
      log('HTTP error: $e');
      return Uint8List(0);
    } catch (e) {
      log('Unexpected error: $e');
      return Uint8List(0);
    }
  }
}
