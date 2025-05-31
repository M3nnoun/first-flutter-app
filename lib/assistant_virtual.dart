import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mon_app/drawer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Add this import

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isProcessing;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isProcessing = false,
  });
}

class AssistantVirtual extends StatefulWidget {
  const AssistantVirtual({super.key});

  @override
  State<AssistantVirtual> createState() => _AssistantVirtualState();
}

class _AssistantVirtualState extends State<AssistantVirtual> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final GenerativeModel _model;
  bool _isGeminiInitialized = false;
  bool _isSending = false;

  // Replace with your actual Gemini API key
  static const String _apiKey = 'AIzaSyCHYpwO';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initGemini();
    _addWelcomeMessage();
  }

  void _initGemini() {
    try {
      _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.9,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
        ],
      );
      setState(() => _isGeminiInitialized = true);
    } catch (e) {
      print('Gemini initialization error: $e');
      _showSnackBar('Failed to initialize AI assistant');
    }
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: 'Hello! I\'m your AI assistant. How can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _speechToText.stop();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'notListening' && _isListening) {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        _showSnackBar('Speech error: ${error.errorMsg}');
        setState(() => _isListening = false);
      },
    );
    setState(() {});
  }

  void _startListening() async {
    if (!_speechEnabled) {
      _showSnackBar('Speech recognition not available');
      return;
    }

    setState(() {
      _isListening = true;
      _messages.add(ChatMessage(
        text: 'Listening...',
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _scrollToBottom();
    });

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      localeId: 'fr_FR',
      partialResults: true,
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
    
    // Remove "Listening..." placeholder if no speech was detected
    if (_messages.isNotEmpty && _messages.last.text == 'Listening...') {
      setState(() => _messages.removeLast());
    } else if (_messages.isNotEmpty && _messages.last.isUser) {
      // Process the last user message
      _processMessage(_messages.last.text);
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    final String text = result.recognizedWords;
    if (text.isNotEmpty) {
      setState(() {
        if (_messages.isNotEmpty && _messages.last.isUser) {
          _messages.last = ChatMessage(
            text: text,
            isUser: true,
            timestamp: DateTime.now(),
          );
        } else {
          _messages.add(ChatMessage(
            text: text,
            isUser: true,
            timestamp: DateTime.now(),
          ));
        }
        _scrollToBottom();
      });
    }
  }

  void _handleTextSubmit() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ));
        _textController.clear();
        _scrollToBottom();
      });
      _processMessage(text);
    }
  }

  Future<void> _processMessage(String message) async {
    if (!_isGeminiInitialized) {
      _showSnackBar('AI assistant is not ready yet');
      return;
    }

    if (_isSending) {
      _showSnackBar('Please wait for the current response');
      return;
    }

    setState(() {
      _isSending = true;
      _messages.add(ChatMessage(
        text: 'Thinking...',
        isUser: false,
        timestamp: DateTime.now(),
        isProcessing: true,
      ));
      _scrollToBottom();
    });

    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);
      final text = response.text ?? "Sorry, I couldn't generate a response.";

      setState(() {
        _isSending = false;
        _messages.removeLast(); // Remove "Thinking..." message
        _messages.add(ChatMessage(
          text: text,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _scrollToBottom();
      });
    } catch (e) {
      print('Gemini API error: $e');
      setState(() {
        _isSending = false;
        _messages.removeLast(); // Remove "Thinking..." message
        _messages.add(ChatMessage(
          text: 'Error: ${e.toString()}',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _scrollToBottom();
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Assistant"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('AI Assistant'),
                content: const Text('This assistant uses Google Gemini AI to answer your questions. '
                    'You can type or speak your questions. Responses are formatted with markdown.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: const Menu(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isProcessing)
              const Row(
                children: [
                  SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 8),
                  Text('Thinking...', style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              )
            else if (isUser)
              Text(
                message.text,
                style: TextStyle(
                  color: Colors.blue[900],
                ),
              )
            else
              // Render markdown for assistant responses
              MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 16, color: Colors.black87),
                  strong: const TextStyle(fontWeight: FontWeight.bold),
                  em: const TextStyle(fontStyle: FontStyle.italic),
                  h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  h3: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  h4: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  blockquote: TextStyle(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                    backgroundColor: Colors.grey[100],
                  ),
                  code: TextStyle(
                    backgroundColor: Colors.grey[200],
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                  listBullet: const TextStyle(fontSize: 16),
                ),
                onTapLink: (text, href, title) {
                  if (href != null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Open Link?'),
                        content: Text('Do you want to open $href?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Implement link opening logic here
                            },
                            child: const Text('Open'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.blue[700] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic_off : Icons.mic,
              color: _isListening ? Colors.red : Colors.blue,
            ),
            onPressed: () {
              if (_isListening) {
                _stopListening();
              } else {
                _startListening();
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _handleTextSubmit(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: _isSending ? Colors.grey : Colors.blue),
            onPressed: _isSending ? null : _handleTextSubmit,
          ),
        ],
      ),
    );
  }
}