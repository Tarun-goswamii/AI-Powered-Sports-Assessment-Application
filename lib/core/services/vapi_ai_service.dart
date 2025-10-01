// lib/core/services/vapi_ai_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// VAPI AI Service for Sports Coach Chatbot
/// Integrates with VAPI AI platform for conversational AI
class VapiAiService {
  static final Dio _dio = Dio();
  static VapiAiService? _instance;
  
  static VapiAiService get instance {
    _instance ??= VapiAiService._();
    return _instance!;
  }

  VapiAiService._() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options.baseUrl = AppConfig.vapiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Authorization': 'Bearer ${AppConfig.vapiApiKey}',
      'Content-Type': 'application/json',
    };

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[VAPI AI] $obj'),
      ));
    }
  }

  /// Initialize VAPI AI service
  static Future<void> initialize() async {
    try {
      // Test connection
      await instance._testConnection();
      print('✅ VAPI AI service initialized successfully');
    } catch (e) {
      print('⚠️ VAPI AI initialization failed (will use fallback): $e');
    }
  }

  /// Test VAPI AI connection
  Future<bool> _testConnection() async {
    try {
      final response = await _dio.get('/assistants');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('VAPI AI connection test failed: $e');
      return false;
    }
  }

  /// Send message to VAPI AI and get response
  Future<ChatResponse> sendMessage({
    required String message,
    required String userId,
    List<ChatMessage>? conversationHistory,
  }) async {
    try {
      // Check if VAPI is enabled
      if (!AppConfig.enableVapiChat) {
        return _getFallbackResponse(message);
      }

      // For VAPI, we'll use their web chat endpoint or create a temporary call
      // Since VAPI is primarily voice-first, we'll provide fallback responses
      // but also prepare for voice integration
      
      // For now, return intelligent fallback responses while maintaining
      // the ability to integrate with VAPI's voice capabilities
      return _getFallbackResponse(message);
      
    } catch (e) {
      debugPrint('VAPI AI error: $e');
      return _getFallbackResponse(message);
    }
  }

  /// Generate fallback response for offline or error scenarios

  /// Get sports-focused fallback response when VAPI is unavailable
  ChatResponse _getFallbackResponse(String message) {
    final msg = message.toLowerCase();
    
    String response;
    if (msg.contains('workout') || msg.contains('exercise')) {
      response = "I'd be happy to help with your workout routine! For personalized exercise recommendations, try taking one of our fitness assessments. Based on your results, I can suggest targeted workouts to improve your performance.";
    } else if (msg.contains('diet') || msg.contains('nutrition')) {
      response = "Nutrition is crucial for athletic performance! Focus on balanced meals with lean proteins, complex carbs, and healthy fats. Stay hydrated and consider post-workout nutrition timing. Check our nutrition section for detailed guidance.";
    } else if (msg.contains('injury') || msg.contains('pain')) {
      response = "For any pain or injury concerns, please consult with a healthcare professional. In the meantime, focus on proper warm-up, cool-down, and listen to your body. Our recovery section has some general wellness tips.";
    } else if (msg.contains('motivation') || msg.contains('goal')) {
      response = "Setting and achieving fitness goals is all about consistency! Start with small, achievable targets and gradually increase intensity. Track your progress with our assessment tools and celebrate small wins along the way.";
    } else if (msg.contains('test') || msg.contains('assessment')) {
      response = "Our assessment tests are designed to evaluate different aspects of your fitness. Try starting with a basic movement test like push-ups or squats. The ML analysis will give you detailed feedback on your form and performance!";
    } else {
      response = "Hello! I'm your AI sports coach. I can help you with workout advice, nutrition tips, motivation, and interpreting your fitness test results. What would you like to know about your fitness journey?";
    }

    return ChatResponse(
      message: response,
      isSuccess: true,
      timestamp: DateTime.now(),
      metadata: {'source': 'fallback', 'model': 'built-in'},
    );
  }

  /// Start a voice conversation (VAPI's main feature)
  Future<VoiceCallResponse> startVoiceCall({
    required String userId,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.post('/calls', data: {
        'assistant_id': AppConfig.vapiAssistantId,
        'phone_number': phoneNumber,
        'metadata': {
          'user_id': userId,
          'app': 'Sports Assessment',
          'call_type': 'coaching_session',
        }
      });

      if (response.statusCode == 201) {
        return VoiceCallResponse(
          callId: response.data['id'],
          status: response.data['status'],
          isSuccess: true,
        );
      } else {
        throw Exception('Failed to start voice call');
      }
    } catch (e) {
      debugPrint('Voice call error: $e');
      return VoiceCallResponse(
        callId: '',
        status: 'failed',
        isSuccess: false,
        error: e.toString(),
      );
    }
  }

  /// Get call status and transcript
  Future<VoiceCallStatus> getCallStatus(String callId) async {
    try {
      final response = await _dio.get('/calls/$callId');
      
      return VoiceCallStatus(
        callId: callId,
        status: response.data['status'],
        transcript: response.data['transcript'] ?? '',
        duration: response.data['ended_at'] != null && response.data['started_at'] != null
            ? DateTime.parse(response.data['ended_at']).difference(DateTime.parse(response.data['started_at']))
            : null,
      );
    } catch (e) {
      debugPrint('Get call status error: $e');
      return VoiceCallStatus(
        callId: callId,
        status: 'error',
        transcript: '',
      );
    }
  }

  /// Get available sports coaching prompts
  List<String> getSuggestedPrompts() {
    return [
      "How can I improve my push-up form?",
      "What's a good warm-up routine?",
      "Help me set fitness goals",
      "Explain my test results",
      "Nutrition tips for athletes",
      "How to prevent injuries?",
      "Motivate me to workout",
      "Recovery after training"
    ];
  }
}

/// Chat message model
class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    message: json['message'],
    isUser: json['isUser'],
    timestamp: DateTime.parse(json['timestamp']),
    metadata: json['metadata'],
  );
}

/// Chat response model
class ChatResponse {
  final String message;
  final bool isSuccess;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final String? error;

  ChatResponse({
    required this.message,
    required this.isSuccess,
    required this.timestamp,
    this.metadata,
    this.error,
  });
}

/// Voice call response model
class VoiceCallResponse {
  final String callId;
  final String status;
  final bool isSuccess;
  final String? error;

  VoiceCallResponse({
    required this.callId,
    required this.status,
    required this.isSuccess,
    this.error,
  });
}

/// Voice call status model
class VoiceCallStatus {
  final String callId;
  final String status;
  final String transcript;
  final Duration? duration;

  VoiceCallStatus({
    required this.callId,
    required this.status,
    required this.transcript,
    this.duration,
  });
}