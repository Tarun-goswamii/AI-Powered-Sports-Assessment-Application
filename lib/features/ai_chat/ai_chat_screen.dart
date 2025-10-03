import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/services/vapi_ai_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_utils.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final VapiAiService _vapiService = VapiAiService.instance;
  late stt.SpeechToText _speechToText;
  late FlutterTts _flutterTts;
  
  bool _isLoading = false;
  bool _isVoiceModeActive = false;
  bool _isListening = false;
  bool _speechAvailable = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initSpeech();
    _initTts();
    _addMessage(
      'Hello! I\'m your AI Sports Coach. I can help you with workout plans, nutrition advice, and performance tips. How can I assist you today?',
      false,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speechToText.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          print('Speech recognition error: $error');
          setState(() => _isListening = false);
        },
      );
      setState(() {});
    } catch (e) {
      print('Failed to initialize speech recognition: $e');
      _speechAvailable = false;
    }
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5); // Moderate speed
      await _flutterTts.setVolume(1.0); // Max volume
      await _flutterTts.setPitch(1.0); // Normal pitch
      
      // Set completion handler
      _flutterTts.setCompletionHandler(() {
        if (mounted) {
          setState(() => _isSpeaking = false);
        }
      });
      
      // Set error handler
      _flutterTts.setErrorHandler((msg) {
        print('TTS Error: $msg');
        if (mounted) {
          setState(() => _isSpeaking = false);
        }
      });
      
      print('✅ Text-to-Speech initialized successfully');
    } catch (e) {
      print('Failed to initialize TTS: $e');
    }
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      if (_speechAvailable) {
        setState(() => _isListening = true);
        await _speechToText.listen(
          onResult: (result) {
            setState(() {
              _messageController.text = result.recognizedWords;
            });
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          cancelOnError: true,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Speech recognition is not available'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    _addMessage(message, true);

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _vapiService.sendMessage(
        message: message,
        userId: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      final responseText = response.message;
      _addMessage(responseText, false);
      
      // If voice mode is active, speak the response
      if (_isVoiceModeActive && responseText.isNotEmpty) {
        _speakResponse(responseText);
      }
    } catch (e) {
      _addMessage('Sorry, I\'m having trouble connecting right now. Please try again.', false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _speakResponse(String text) async {
    try {
      // Stop any ongoing speech
      if (_isSpeaking) {
        await _flutterTts.stop();
      }
      
      setState(() => _isSpeaking = true);
      
      // Clean up text for better speech (remove emojis)
      final cleanText = text.replaceAll(RegExp(r'[🎤💡📝🏃⚽🏀🎾🏋️🧘🏊🚴🤸💪🔥⭐🎯📊]'), '');
      
      print('🔊 Speaking: $cleanText');
      
      // Speak the text
      await _flutterTts.speak(cleanText);
      
      // Show visual indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.volume_up, color: AppColors.neonGreen),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '🔊 Voice response playing...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.cardBackground,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error speaking response: $e');
      setState(() => _isSpeaking = false);
    }
  }

  Future<void> _toggleVoiceMode() async {
    if (_isVoiceModeActive) {
      setState(() {
        _isVoiceModeActive = false;
      });
      _addMessage('🎤 Voice mode disabled. You can continue typing your questions.', false);
    } else {
      setState(() {
        _isVoiceModeActive = true;
      });
      
      _addMessage('🎤 Voice mode activated! I can hear you - just tap the microphone at the bottom and speak your question. I\'ll respond with voice!', false);
      
      // Show a helpful tip
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isVoiceModeActive) {
          _addMessage('� Tip: The microphone button at the bottom (with the gradient) will listen to your voice. Speak naturally and I\'ll understand!', false);
        }
      });
    }
  }

  // Voice mode using speech recognition
  // The device listens via _toggleListening() and speaks responses

  void _sendSuggestedMessage(String message) {
    _messageController.text = message;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'AI Sports Coach',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: responsive.sp(20),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: AppColors.glassmorphismDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              enableNeonGlow: true,
              neonGlowColor: AppColors.royalPurple,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: _isVoiceModeActive 
                    ? AppColors.brightRed.withOpacity(0.2) 
                    : AppColors.glassmorphismBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isVoiceModeActive 
                      ? AppColors.brightRed 
                      : AppColors.glassmorphismBorder,
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  _isVoiceModeActive ? Icons.mic : Icons.mic_off,
                  color: _isVoiceModeActive ? AppColors.brightRed : Colors.white,
                ),
                onPressed: _toggleVoiceMode,
                tooltip: _isVoiceModeActive ? 'Disable Voice Mode' : 'Enable Voice Mode',
              ),
            ),
          ],
        ),
        body: Column(
        children: [
          // Connection Status Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.neonGreen.withOpacity(0.1),
                  AppColors.electricBlue.withOpacity(0.1),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.glassmorphismBorder.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.smart_toy, 
                    color: AppColors.neonGreen, 
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Coach is ready to help!',
                  style: TextStyle(
                    color: AppColors.neonGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Messages List
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.glassmorphismBackground.withOpacity(0.05),
                  ],
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
          ),

          // Quick Suggestions
          if (_messages.length <= 2)
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Questions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.mutedForeground,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _vapiService.getSuggestedPrompts()
                          .map((suggestion) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration: AppColors.glassmorphismDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    enableNeonGlow: true,
                                    neonGlowColor: AppColors.electricBlue,
                                  ),
                                  child: ActionChip(
                                    label: Text(
                                      suggestion,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: () => _sendSuggestedMessage(suggestion),
                                    backgroundColor: Colors.transparent,
                                    side: BorderSide.none,
                                    elevation: 0,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

          // Loading Indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.neonGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI Coach is thinking...',
                    style: TextStyle(
                      color: AppColors.mutedForeground,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.glassmorphismBackground.withOpacity(0.1),
                  AppColors.glassmorphismBackground.withOpacity(0.2),
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: AppColors.glassmorphismBorder.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.glassmorphismBackground.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppColors.glassmorphismBorder.withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.royalPurple.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: _isVoiceModeActive 
                            ? 'Voice mode active - tap mic or type here'
                            : 'Ask me about workouts, nutrition, or fitness...',
                        hintStyle: TextStyle(
                          color: AppColors.mutedForeground.withOpacity(0.7),
                          fontSize: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Microphone button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isListening 
                          ? [Colors.red, Colors.redAccent]
                          : [AppColors.warmOrange, AppColors.neonGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening ? Colors.red : AppColors.warmOrange).withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                    ),
                    onPressed: _isLoading ? null : _toggleListening,
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.royalPurple, AppColors.electricBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.royalPurple.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.royalPurple, AppColors.electricBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.royalPurple.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14.0),
              decoration: message.isUser
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.royalPurple, AppColors.electricBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18).copyWith(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.royalPurple.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                  : AppColors.glassmorphismDecoration(
                      borderRadius: BorderRadius.circular(18).copyWith(
                        topLeft: const Radius.circular(4),
                        topRight: const Radius.circular(18),
                      ),
                      enableNeonGlow: true,
                      neonGlowColor: AppColors.electricBlue,
                    ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: message.isUser ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.glassmorphismBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.glassmorphismBorder,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.person,
                color: AppColors.mutedForeground,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}