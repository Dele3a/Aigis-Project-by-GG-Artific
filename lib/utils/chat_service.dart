import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  final String _endpoint = "https://api.openai.com/v1/chat/completions";

  // Add pathologyResult to the function signature to include it in the prompt
  Future<String> sendMessage(String message, String pathologyResult) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "You are an expert in building pathology and Eurocode standards. Your goal is to assist users in diagnosing building defects, suggesting remedies, and providing detailed advice based on Eurocode regulations."
          },
          {
            "role": "user",
            "content": "The user has detected the following pathology: $pathologyResult. They are now asking for advice: '$message'. Please answer based on Eurocode standards and provide detailed guidance."
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch response: ${response.body}');
    }
  }
}
