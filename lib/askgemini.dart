import 'package:google_generative_ai/google_generative_ai.dart';

class Askgemini {
  final String prompt;
  Askgemini({required this.prompt});

  Future<String> network() async {
    const apiKey =
        "AIzaSyC8_I-Yf7LUDJRumBlK13EDw-JTQ6Vc16k"; // Replace with your actual API key
    final model = GenerativeModel(model: "gemini-2.0-flash", apiKey: apiKey);

    try {
      print('i am trying to ask gemini');
      final response = await model.generateContent([Content.text(prompt)]);
      print('i asked out that bitch');

      return response.text ?? "No response from Gemini AI";
    } catch (e) {
      return "Error: $e";
    }
  }
}
