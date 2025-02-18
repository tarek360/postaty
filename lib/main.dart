import 'dart:convert';

import 'package:flutter/material.dart';

import 'api.dart';
import 'model.dart';
import 'widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _photos = [];
  InstagramPost? _post;
  String _response = "";
  bool _isLoading = false;

  void _generateResponse() async {
    setState(() {
      _isLoading = true;
      _response = "";
    });
    try {
      final response = await getOllamaCompletion(_controller.text);
      final post = InstagramPost.fromJson(jsonDecode(response));
      _photos = await searchUnsplashPhotos(post.unsplashPhotoKeyword);

      setState(() {
        _response = response;
        _post = post;
      });
    } catch (e, s) {
      debugPrint('Error: $e\n$s');
      setState(() {
        _response = 'Error: $e';
        _post = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Postaty')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_post != null)
                            InstagramPostWidget(
                              post: _post!,
                              photos: _photos,
                            ),
                          SelectableText(_response, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 600,
                  child: TextField(
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      _generateResponse();
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write a topic!',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade50),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _generateResponse,
                    child: Text('Generate'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
