// lib/features/ai_coach/screens/ai_chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/vapi_ai_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
imp          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),/../../shared/presentation/widgets/neon_button.dart';

class AiChatbotScreen extends StatefulWidget {
  const AiChatbotScreen({super.key});

  @override
  State<AiChatbotScreen> createState() => _AiChatbotScreenState();
}

class _AiChatbotScreenState extends State<AiChatbotScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final VapiAiService _vapiService = VapiAiService.instance;
  
  bool _isLoading = false;
  bool _isVoiceCallActive = false;
  String? _activeCallId;
  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    // Welcome message
    setState(() {
      _messages.add(ChatMessage(
        message: "🏃‍♂️ Hey there, athlete! I'm your AI Sports Coach. I'm here to help you with:\n\n• Workout advice and form tips\n• Nutrition guidance\n• Interpreting your test results\n• Motivation and goal setting\n• Injury prevention\n\nWhat would you like to know about your fitness journey?",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        message: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Get current user ID
      final user = AuthService.instance.currentUser;
      final userId = user?.uid ?? 'anonymous';

      // Send to VAPI AI
      final response = await _vapiService.sendMessage(
        message: message,
        userId: userId,
        conversationHistory: _messages.where((m) => !m.isUser).take(5).toList(),
      );

      setState(() {
        _messages.add(ChatMessage(
          message: response.message,
          isUser: false,
          timestamp: response.timestamp,
          metadata: response.metadata,
        ));
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          message: "I apologize, but I'm having trouble processing your request right now. Please try again.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  // Voice call feature removed - use text chat instead
  // For voice features, use the AI Chat screen with in-app voice mode

  Future<String?> _showPhoneNumberDialog() async {
    final TextEditingController phoneController = TextEditingController();
    
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.phone, color: AppColors.neonGreen),
            SizedBox(width: 8),
            Text('Voice Coaching', style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your phone number to receive a call from Riley, your AI sports coach.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                hintText: '+1234567890',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.phone_android, color: AppColors.electricBlue),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.neonGreen, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '💡 Tip: Include country code (e.g., +1 for US)',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final phone = phoneController.text.trim();
              Navigator.pop(context, phone);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Call Me', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showVoiceCallDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Row(
          children: [
            Icon(Icons.mic, color: AppColors.neonGreen),
            SizedBox(width: 8),
            Text('Voice Coaching Session', style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.graphic_eq, size: 64, color: AppColors.electricBlue),
            const SizedBox(height: 16),
            const Text(
              'Speaking with AI Coach...\nTap "End Call" when finished.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            NeonButton(
              text: 'End Call',
              onPressed: _endVoiceCall,
              // No color parameter needed for NeonButton
            ),
          ],
        ),
      ),
    );
  }

  void _endVoiceCall() {
    Navigator.of(context).pop(); // Close dialog
    setState(() {
      _isVoiceCallActive = false;
      _activeCallId = null;
      _messages.add(ChatMessage(
        message: "🎙️ Voice coaching session ended. You can continue chatting here or start another voice session anytime!",
        isUser: false,
        timestamp: DateTime.now(),
      ));
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.brightRed,
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: AppColors.electricBlue,
              radius: 16,
              child: const Icon(Icons.smart_toy, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? AppColors.electricBlue : AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: message.isUser ? AppColors.electricBlue : AppColors.border,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : AppColors.foreground,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: message.isUser ? Colors.white70 : AppColors.mutedForeground,
                          fontSize: 10,
                        ),
                      ),
                      if (message.metadata?['source'] == 'fallback')
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.offline_bolt, size: 12, color: AppColors.accent),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.accent,
              radius: 16,
              child: const Icon(Icons.person, size: 20, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.electricBlue,
            radius: 16,
            child: const Icon(Icons.smart_toy, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.electricBlue.withOpacity(
                              ((_typingAnimationController.value + index * 0.3) % 1.0),
                            ),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Coach is typing...',
                  style: TextStyle(
                    color: AppColors.mutedForeground,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedPrompts() {
    final prompts = _vapiService.getSuggestedPrompts();
    
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: prompts.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                prompts[index],
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
              ),
              backgroundColor: AppColors.cardBackground,
              side: const BorderSide(color: AppColors.borderColor),
              onPressed: () => _sendMessage(prompts[index]),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: AppColors.neonBlue),
            SizedBox(width: 8),
            Text(
              'AI Sports Coach',
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isVoiceCallActive ? Icons.call_end : Icons.mic,
              color: _isVoiceCallActive ? AppColors.neonRed : AppColors.neonGreen,
            ),
            onPressed: _isVoiceCallActive ? _endVoiceCall : _startVoiceCall,
            tooltip: _isVoiceCallActive ? 'End Voice Call' : 'Start Voice Call',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.accent),
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              _initializeChat();
            },
            tooltip: 'New Conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          // Suggested prompts
          if (_messages.length <= 1) ...[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Quick Questions:',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildSuggestedPrompts(),
            const SizedBox(height: 16),
          ],
          
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              border: Border(top: BorderSide(color: AppColors.borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me about fitness, nutrition, or your test results...',
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.neonBlue),
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: const TextStyle(color: AppColors.textPrimary),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.neonBlue, AppColors.neonGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading 
                        ? null 
                        : () => _sendMessage(_messageController.text),
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