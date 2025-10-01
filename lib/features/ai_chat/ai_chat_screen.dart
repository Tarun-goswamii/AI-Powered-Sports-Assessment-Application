import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/vapi_ai_service.dart';
import '../../core/theme/app_colors.dart';

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
  bool _isLoading = false;
  bool _isVoiceModeActive = false;

  @override
  void initState() {
    super.initState();
    _addMessage(
      'Hello! I\'m your AI Sports Coach. I can help you with workout plans, nutrition advice, and performance tips. How can I assist you today?',
      false,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
      _addMessage(response.message, false);
    } catch (e) {
      _addMessage('Sorry, I\'m having trouble connecting right now. Please try again.', false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleVoiceMode() async {
    if (_isVoiceModeActive) {
      setState(() {
        _isVoiceModeActive = false;
      });
      _addMessage('Voice mode disabled. You can continue typing your questions.', false);
    } else {
      setState(() {
        _isVoiceModeActive = true;
      });
      _addMessage('Voice mode activated! Speak your question and I\'ll respond with voice and text.', false);
      
      try {
        final response = await _vapiService.startVoiceCall(
          userId: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
        );
        if (response.isSuccess) {
          _addMessage('Voice session started successfully!', false);
        } else {
          _addMessage('Voice mode is temporarily unavailable. You can still chat via text!', false);
          setState(() {
            _isVoiceModeActive = false;
          });
        }
      } catch (e) {
        _addMessage('Voice mode setup failed. Continuing with text mode.', false);
        setState(() {
          _isVoiceModeActive = false;
        });
      }
    }
  }

  void _sendSuggestedMessage(String message) {
    _messageController.text = message;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'AI Sports Coach',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
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