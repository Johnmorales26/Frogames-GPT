import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  late final GenerativeModel model;

  GeminiService() {
    model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash');
  }

  Future<String> sendRequestToModel(String message) async {
    try {
      final prompt = [Content.text(message)];

      final response = await model.generateContent(prompt);

      if (response.text != null) {
        return response.text!;
      } else {
        return 'Error: Response to model is null';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
