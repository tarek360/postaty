import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String _unsplashAccessKey = 'YOUR_ACCESS_KEY';
const String baseUrl = 'https://api.unsplash.com/search/photos';

Future<List<String>> searchUnsplashPhotos(String query, {int perPage = 6, int page = 1}) async {
  final url = Uri.parse('$baseUrl?query=$query&per_page=$perPage&page=$page&client_id=$_unsplashAccessKey');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List results = data['results'];

      // Extract URLs of images
      return results.map<String>((photo) => photo['urls']['regular']).toList();
    } else {
      throw Exception('Failed to load photos: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<String> getOllamaCompletion(String prompt) async {
  const String apiUrl = 'http://localhost:11434/api/chat';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "model": "llama3.1",
      "options": {
        "temperature": 0.7,
      },
      "messages": [
        {"role": "user", "content": _systemPrompt.replaceAll('{topic}', prompt)},
      ],
      'stream': false,
      'format': jsonScheme,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final content = data['message']['content'];
    // print beautiful JSON
    debugPrint(content);
    return content;
  } else {
    throw Exception('Failed to fetch completion: ${response.body}');
  }
}

// A system prompt to be used for generating JSON to render Instagram image post.
const _systemPrompt = '''
Generate JSON to render Social media image post about the topic: {topic}
## How This Works:
- Title must be Big & Positioned at the top for clear messaging in a light color.
- Content must be relative to the topic, two bullet points useful, educational and deep, in a light color.
- CTA must be At the bottom in a vibrant background color and light text color
- Hashtags must be Listed for discoverability.
- Engagement Element must be Some emojis for extra visual
## Instructions:
 - Feel free to Change the the position of the title, content, and CTA elements based on your design.
 - All colors are in HEX format.
''';

const jsonScheme = {
  "type": "object",
  "properties": {
    "title": {
      "type": "object",
      "properties": {
        "text": {"type": "string"},
        "color": {"type": "string"},
        "position": {
          "type": "object",
          "properties": {
            "x": {"type": "string"},
            "y": {"type": "string"},
            "offsetX": {"type": "integer"},
            "offsetY": {"type": "integer"}
          },
          "required": ["x", "y"]
        }
      },
      "required": ["text", "color", "position"]
    },
    "content": {
      "type": "object",
      "properties": {
        "text": {"type": "string"},
        "color": {"type": "string"},
        "position": {
          "type": "object",
          "properties": {
            "x": {"type": "string"},
            "y": {"type": "string"},
            "offsetX": {"type": "integer"},
            "offsetY": {"type": "integer"}
          },
          "required": ["x", "y"]
        }
      },
      "required": ["text", "color", "position"]
    },
    "cta": {
      "type": "object",
      "properties": {
        "text": {"type": "string"},
        "color": {
          "type": "string",
        },
        "background": {"type": "string"},
        "borderRadius": {"type": "integer"},
        "padding": {
          "type": "object",
          "properties": {
            "x": {"type": "integer"},
            "y": {"type": "integer"}
          },
          "required": ["x", "y"]
        },
        "position": {
          "type": "object",
          "properties": {
            "x": {"type": "string"},
            "y": {"type": "string"},
            "offsetX": {"type": "integer"},
            "offsetY": {"type": "integer"}
          },
          "required": ["x", "y"]
        }
      },
      "required": ["text", "color", "background", "borderRadius", "padding", "position"]
    },
    "hashtags": {
      "type": "array",
      "items": {"type": "string"}
    },
    "engagementEmoji": {"type": "string"},
    "unsplashPhotoKeyword": {
      "type": "string",
    }
  },
  "required": ["title", "content", "hashtags", "engagementEmoji", "unsplashPhotoKeyword"]
};
