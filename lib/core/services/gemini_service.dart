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

  Stream<String> sendRequestStreamToModel(String message) async* {
    final prompt = [Content.text(message)];

    try {
      final streamResponse = model.generateContentStream(prompt);

      await for (final response in streamResponse) {
        if (response.text != null) {
          yield response.text!;
        } else {
          yield 'Error: Stream response is null';
        }
      }
    } catch (e) {
      yield 'Error: $e';
    }
  }
}
