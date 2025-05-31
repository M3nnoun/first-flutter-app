import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  final TextEditingController _textController = TextEditingController();
  Uint8List? _generatedImage;
  bool _isGenerating = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _generateImage() async {
    final prompt = _textController.text.trim();
    if (prompt.isEmpty) {
      setState(() => _errorMessage = 'Please enter a description');
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedImage = null;
      _errorMessage = '';
    });

    try {
      final encodedPrompt = Uri.encodeComponent(prompt);
      final url = Uri.parse(
        'https://image.pollinations.ai/prompt/$encodedPrompt'
        '?width=1024&height=1024&seed=33741&model=flux&nologo=false&private=false&enhance=false&safe=false',
      );

      // final response = await http.get(url, headers: {
      //   'accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
      //   'accept-language': 'en-US,en;q=0.7',
      //   'cache-control': 'no-cache',
      //   'pragma': 'no-cache',
      //   'referer': 'https://www.desktophut.com/',
      //   'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36',
      // });
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() => _generatedImage = response.bodyBytes);
      } else {
        setState(() => _errorMessage = 'Failed to generate image: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input area
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Describe what you want to generate',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isGenerating ? null : _generateImage,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Error message
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),

            // Loading indicator
            if (_isGenerating)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),

            // Generated image
            if (_generatedImage != null)
              Expanded(
                child: InteractiveViewer(
                  child: Image.memory(
                    _generatedImage!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            // Save button (stub)
            if (_generatedImage != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Save Image'),
                onPressed: () {
                  // TODO: Implement image saving
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image saved to gallery')),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
