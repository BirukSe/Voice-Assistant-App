import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class AiVOOVService {
  final String apiKey = '75efd106-b296-433e-a799-192ca753bd93';

  Future<void> speak(String text) async {
    var url = Uri.parse('https://aivoov.com/api/v1/transcribe');

    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'X-API-KEY': apiKey,
      })
      ..fields['voice_id'] = 'Ameha'
      ..fields['transcribe_text[]'] = text
      ..fields['engine'] = 'neural';

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decodedData = jsonDecode(responseData);

        if (decodedData['result'] == false) {
          print("Error: ${decodedData['message']}");
        } else if (decodedData['transcribe_data'] != null) {
          String audioBase64 = decodedData['transcribe_data'];
          Uint8List audioBytes = base64Decode(audioBase64);
          print("Audio data received.");
        } else {
          print("Error: transcribe_data not found in response.");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
