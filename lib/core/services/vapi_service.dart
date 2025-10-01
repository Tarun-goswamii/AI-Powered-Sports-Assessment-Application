import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class VapiService {
  static const String _baseUrl = AppConfig.vapiBaseUrl;
  static const String _apiKey = AppConfig.vapiApiKey;
  static const String _assistantId = AppConfig.vapiAssistantId;

  static VapiService? _instance;
  static VapiService get instance {
    _instance ??= VapiService._();
    return _instance!;
  }

  VapiService._();

  /// Initialize VAPI AI service
  static Future<void> initialize() async {
    print('✅ VAPI AI service initialized');
  }

  /// Send message to VAPI AI assistant
  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'assistant_id': _assistantId,
          'message': message,
          'session_id': 'sports_app_session_${DateTime.now().millisecondsSinceEpoch}',
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'Sorry, I couldn\'t process that request.';
      } else {
        throw Exception('VAPI API error: ${response.statusCode}');
      }
    } catch (e) {
      print('VAPI API error: $e');
      // Return fallback response for demo purposes
      return _getFallbackResponse(message);
    }
  }

  /// Start voice conversation
  Future<String> startVoiceChat() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/voice/start'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'assistant_id': _assistantId,
          'voice_settings': {
            'language': 'en-US',
            'voice_id': 'sports_coach_voice',
          },
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['session_id'] ?? '';
      } else {
        throw Exception('Voice chat start failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Voice chat error: $e');
      return '';
    }
  }

  /// Get fallback response for demo purposes
  String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('workout') || lowerMessage.contains('exercise')) {
      return 'Great question about workouts! I recommend starting with basic exercises like push-ups, squats, and planks. Would you like me to create a personalized workout plan for you?';
    } else if (lowerMessage.contains('nutrition') || lowerMessage.contains('diet')) {
      return 'Nutrition is crucial for athletic performance! Focus on lean proteins, complex carbs, and plenty of vegetables. Stay hydrated and time your meals around your workouts.';
    } else if (lowerMessage.contains('test') || lowerMessage.contains('assessment')) {
      return 'Our sports assessments help you track your progress! Start with the basic tests like vertical jump or shuttle run to establish your baseline fitness level.';
    } else if (lowerMessage.contains('injury') || lowerMessage.contains('pain')) {
      return 'If you\'re experiencing pain or injury, please consult with a healthcare professional. I can help with general fitness advice and injury prevention tips.';
    } else if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return 'Hello! I\'m your AI Sports Coach. I\'m here to help you with workout plans, nutrition advice, and sports performance tips. How can I assist you today?';
    } else {
      return 'That\'s an interesting question! As your AI Sports Coach, I\'m here to help with fitness, nutrition, and performance optimization. Could you tell me more about your specific goals?';
    }
  }

  /// Get conversation suggestions
  List<String> getConversationStarters() {
    return [
      'Create a workout plan for me',
      'What should I eat before a workout?',
      'How can I improve my running speed?',
      'Tips for building muscle mass',
      'How to prevent sports injuries?',
      'Best recovery techniques',
    ];
  }

  /// Check service health
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('VAPI health check failed: $e');
      return false; // Fallback mode is always available
    }
  }
}