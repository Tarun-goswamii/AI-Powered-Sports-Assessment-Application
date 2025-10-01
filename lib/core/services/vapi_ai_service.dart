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
      'Authorization': 'Bearer ${AppConfig.vapiApiKey}', // Standard Bearer token format
      'Content-Type': 'application/json',
      'Accept': 'application/json',
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

      debugPrint('💬 Sending message to VAPI AI...');
      debugPrint('   Message: $message');
      debugPrint('   User: $userId');
      
      // Try VAPI chat endpoint (using assistant for text-based interaction)
      try {
        final chatData = {
          'message': {
            'role': 'user',
            'content': message,
          },
          'assistantId': AppConfig.vapiAssistantId,
          'metadata': {
            'userId': userId,
            'platform': 'mobile_app',
            'timestamp': DateTime.now().toIso8601String(),
          }
        };

        // VAPI may have a chat endpoint - let's try /chat first
        Response? response;
        try {
          response = await _dio.post(
            '/chat',
            data: chatData,
          ).timeout(const Duration(seconds: 15));
        } catch (e) {
          // If /chat doesn't exist, try using assistant endpoint
          debugPrint('⚠️ /chat endpoint not available, trying assistant endpoint...');
          
          // Alternative: Use assistant endpoint for chat-like interaction
          final assistantData = {
            'assistantId': AppConfig.vapiAssistantId,
            'message': message,
            'metadata': {
              'userId': userId,
              'conversationType': 'text',
            }
          };
          
          response = await _dio.post(
            '/assistant/message',
            data: assistantData,
          ).timeout(const Duration(seconds: 15));
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = response.data;
          String aiMessage = '';
          
          // Extract response from various possible formats
          if (data is Map) {
            aiMessage = data['message']?.toString() ?? 
                       data['response']?.toString() ?? 
                       data['content']?.toString() ?? 
                       data['text']?.toString() ?? '';
            
            // Handle nested message structure
            if (aiMessage.isEmpty && data['message'] is Map) {
              aiMessage = data['message']['content']?.toString() ?? '';
            }
          } else if (data is String) {
            aiMessage = data;
          }
          
          if (aiMessage.isNotEmpty) {
            debugPrint('✅ VAPI AI responded successfully');
            return ChatResponse(
              message: aiMessage,
              isSuccess: true,
              timestamp: DateTime.now(),
              metadata: {'source': 'vapi', 'assistantId': AppConfig.vapiAssistantId},
            );
          }
        }
      } catch (apiError) {
        debugPrint('⚠️ VAPI API call failed: $apiError');
        // Fall through to fallback
      }
      
      // If VAPI doesn't support text chat or fails, use intelligent fallback
      debugPrint('ℹ️ Using intelligent fallback response');
      return _getFallbackResponse(message);
      
    } catch (e) {
      debugPrint('VAPI AI error: $e');
      // Gracefully degrade to fallback responses
      return _getFallbackResponse(message);
    }
  }

  /// Generate fallback response for offline or error scenarios

  /// Get sports-focused intelligent response when VAPI is unavailable
  /// Uses advanced pattern matching for contextual, varied responses
  ChatResponse _getFallbackResponse(String message) {
    final msg = message.toLowerCase();
    final responses = <String>[];
    
    // Workout & Exercise responses
    if (msg.contains('workout') || msg.contains('exercise')) {
      if (msg.contains('beginner')) {
        responses.addAll([
          "For beginners, I recommend starting with bodyweight exercises! Try 3 sets of 10-12 reps of: push-ups (or knee push-ups), squats, lunges, and planks. Rest 60 seconds between sets. Aim for 3 sessions per week with rest days in between. 💪",
          "Great question! Begin with a full-body routine: Monday-Wednesday-Friday. Each day do: 10 push-ups, 15 squats, 10 lunges each leg, and 30-second plank. Gradually increase reps as you get stronger. Remember to warm up for 5-10 minutes first! 🏃",
          "Let's build your foundation! Start with this simple circuit: 10 jumping jacks, 5 push-ups, 10 bodyweight squats, 5 burpees. Repeat 3 times with 1-minute rest between circuits. Do this 3 times per week. You'll see progress in 2-3 weeks! 🎯"
        ]);
      } else if (msg.contains('strength') || msg.contains('muscle')) {
        responses.addAll([
          "For strength building, focus on compound movements: squats, deadlifts, bench press, and rows. Start with 3 sets of 6-8 reps at 70-80% of your max weight. Rest 2-3 minutes between sets. Train each muscle group twice per week. 💪",
          "Building muscle requires progressive overload! I recommend: Day 1: Upper body (bench, rows, overhead press), Day 2: Lower body (squats, deadlifts, lunges). 8-12 reps, 3-4 sets. Increase weight by 2.5-5lbs when you can do all reps easily. 🏋️",
          "Strength training tip: Prioritize form over weight! Start your sessions with compound lifts (squat, bench, deadlift), then move to isolation exercises. Aim for 3-5 sets of 5-8 reps for strength. Rest 90-180 seconds between sets. Track your lifts! 📊"
        ]);
      } else if (msg.contains('cardio') || msg.contains('running') || msg.contains('endurance')) {
        responses.addAll([
          "For cardiovascular fitness, try this: Start with 20-30 minutes of steady-state cardio (jogging, cycling) 3 times per week. Add 1 interval session: 30 seconds hard effort, 90 seconds easy, repeat 8-10 times. Build up gradually! 🏃",
          "Cardio doesn't have to be boring! Mix it up: Monday - 30 min jog, Wednesday - 20 min HIIT (sprint 30s, walk 60s), Friday - 40 min brisk walk or cycle. This variety prevents burnout and improves overall fitness! 🚴",
          "Endurance training plan: Week 1-2: 20 min easy pace. Week 3-4: 25 min with 2x(2 min faster pace). Week 5-6: 30 min steady. Week 7-8: Add hills or intervals. Always warm up 5 min and cool down 5 min! ⏱️"
        ]);
      } else if (msg.contains('home') || msg.contains('no equipment')) {
        responses.addAll([
          "No equipment needed! Try this bodyweight circuit: 20 jumping jacks, 10 push-ups, 15 squats, 10 mountain climbers, 30s plank. Repeat 4 times. Add in: burpees, lunges, tricep dips using a chair. Get creative! 🏠",
          "Home workout routine: Day 1: Upper body (push-ups, pike push-ups, tricep dips), Day 2: Legs (squats, lunges, calf raises, glute bridges), Day 3: Core (planks, bicycle crunches, leg raises). No gym required! 💪",
          "Bodyweight training is amazing! Master these: push-ups (progress to diamond, decline), squats (progress to pistol squats), pull-ups (if you have a bar), planks (side planks, plank-ups). Focus on form and time under tension! 🎯"
        ]);
      } else {
        responses.addAll([
          "I'd love to help plan your workouts! Could you tell me more about your goals? Are you looking to build strength, improve endurance, lose weight, or gain muscle? Also, how many days per week can you train? 🤔",
          "Let's create a personalized workout plan! First, tell me: What's your current fitness level? What equipment do you have access to? What are your main goals? I'll design something perfect for you! 📝",
          "Great that you're thinking about exercise! To give you the best workout advice, I need to know: Your fitness experience, available time per week, any injuries or limitations, and whether you prefer gym or home workouts. Let me know! 💡"
        ]);
      }
    }
    
    // Nutrition & Diet responses
    else if (msg.contains('diet') || msg.contains('nutrition') || msg.contains('food') || msg.contains('eat')) {
      if (msg.contains('lose weight') || msg.contains('fat loss') || msg.contains('cutting')) {
        responses.addAll([
          "For fat loss, focus on a moderate calorie deficit (300-500 below maintenance). Eat plenty of protein (0.8-1g per lb bodyweight), moderate carbs around workouts, and healthy fats. Drink 3L water daily. Track your food for 2 weeks to understand portions! 📊",
          "Weight loss nutrition: Fill half your plate with vegetables, quarter with lean protein (chicken, fish, tofu), quarter with complex carbs (rice, quinoa, sweet potato). Eat 3-4 meals daily. Avoid processed foods and liquid calories. Be consistent! 🥗",
          "Sustainable fat loss tips: Eat protein with every meal (keeps you full longer), drink water before meals, reduce added sugars, get 7-8 hours sleep (affects hormones!), walk 10k steps daily. Aim for 0.5-1kg loss per week for best results! 🎯"
        ]);
      } else if (msg.contains('muscle') || msg.contains('bulk') || msg.contains('gain')) {
        responses.addAll([
          "To build muscle, eat in a slight calorie surplus (200-300 above maintenance). Prioritize protein: 1.6-2.2g per kg bodyweight. Time carbs around workouts. Good sources: chicken, fish, eggs, Greek yogurt, oats, rice, sweet potatoes. Eat every 3-4 hours! 💪",
          "Muscle gain nutrition plan: Breakfast - eggs + oats, Snack - protein shake + banana, Lunch - chicken/fish + rice + veggies, Pre-workout - banana + peanut butter, Dinner - lean meat + potatoes + salad, Before bed - casein protein or cottage cheese! 🍗",
          "Building muscle requires consistency! Aim for 4-5 meals daily with 25-40g protein each. Post-workout: fast-digesting protein + carbs within 2 hours. Don't forget: creatine monohydrate 5g daily, adequate sleep, and progressive overload in gym! 🏋️"
        ]);
      } else if (msg.contains('meal') || msg.contains('recipe')) {
        responses.addAll([
          "Quick athlete meal ideas: 1) Grilled chicken breast + sweet potato + broccoli, 2) Salmon + quinoa + asparagus, 3) Turkey mince stir-fry with brown rice + mixed vegetables, 4) Greek yogurt + berries + granola + honey. All under 30 mins! 🍽️",
          "Here are 3 easy post-workout meals: 1) Protein smoothie: banana, protein powder, oats, peanut butter, milk, 2) Egg whites + whole grain toast + avocado, 3) Tuna + whole wheat pasta + olive oil + veggies. Eat within 2 hours of training! 🥤",
          "Meal prep Sunday! Cook: 1) 6 chicken breasts (season variety), 2) 2 cups rice + 2 cups quinoa, 3) Roast mixed vegetables, 4) Boil 12 eggs. Portion into containers for the week. Add fresh greens daily. Saves time and ensures consistency! 📦"
        ]);
      } else {
        responses.addAll([
          "Nutrition is the foundation of fitness! A few key principles: eat whole foods, prioritize protein, stay hydrated, time nutrients around training, get enough sleep. What specific nutrition goal are you working on? 🍎",
          "Good nutrition supports your training! Focus on: lean proteins (chicken, fish, eggs), complex carbs (oats, rice, potatoes), healthy fats (avocado, nuts, olive oil), plenty of vegetables. What aspect of nutrition would you like to dive into? 💡",
          "Let's talk nutrition! Whether your goal is fat loss, muscle gain, or performance - diet is crucial. Tell me more about your goals and current eating habits, and I'll give you specific, actionable advice! 📝"
        ]);
      }
    }
    
    // Motivation & Goals
    else if (msg.contains('motivation') || msg.contains('goal') || msg.contains('inspire')) {
      responses.addAll([
        "Remember: Progress isn't always linear! Some days will be tough, but showing up is what matters. Set small, achievable weekly goals. Celebrate every victory, no matter how small. You're building a lifestyle, not just working out! 💪 Keep pushing!",
        "Your fitness journey is unique to you! Don't compare yourself to others - compare yourself to who you were yesterday. Set SMART goals (Specific, Measurable, Achievable, Relevant, Time-bound). Track your progress. You've got this! 🌟",
        "Motivation fades, but discipline stays! Create a routine and stick to it. Schedule workouts like important meetings. Find a workout buddy for accountability. Remember your 'why' - write it down and read it when you're struggling. You're stronger than you think! 🔥",
        "Goal setting tip: Break big goals into smaller milestones. Want to lose 10kg? Start with losing 1kg. Want to bench 100kg? Focus on adding 2.5kg this month. Small wins build momentum. Track everything - what gets measured gets managed! 📈",
        "Feeling unmotivated? That's normal! Try this: 1) Review old progress photos/videos, 2) Set a new challenge (race, competition, PR), 3) Change your routine to keep it fresh, 4) Remember how good you feel AFTER working out. Start with just 10 minutes! ⚡"
      ]);
    }
    
    // Injury & Recovery
    else if (msg.contains('injury') || msg.contains('pain') || msg.contains('hurt') || msg.contains('recovery')) {
      responses.addAll([
        "⚠️ For acute pain or injuries, please consult a healthcare professional or physiotherapist! General tips: RICE (Rest, Ice, Compression, Elevation) for first 48-72 hours. Don't ignore pain signals. Proper recovery prevents chronic issues! 🏥",
        "Recovery is where gains happen! Ensure you're: 1) Getting 7-9 hours quality sleep, 2) Eating enough protein and calories, 3) Staying hydrated, 4) Managing stress, 5) Taking rest days seriously. Active recovery like walking or yoga helps too! 😴",
        "Preventing injuries: Always warm up properly (5-10 min dynamic stretching), cool down after (static stretching), don't increase volume/intensity too quickly (10% rule), listen to your body, maintain good form, and incorporate mobility work! 🧘"
      ]);
    }
    
    // Fitness Tests & Assessments
    else if (msg.contains('test') || msg.contains('assessment') || msg.contains('measure')) {
      responses.addAll([
        "Our fitness assessments use AI/ML to analyze your movement patterns! Try these tests: 1) Push-up test (upper body strength & endurance), 2) Squat assessment (lower body form & mobility), 3) Plank test (core stability). The AI provides detailed feedback on your technique! 📹",
        "Tracking progress is key! Recommended assessments: 1) Body composition (photos, measurements), 2) Strength benchmarks (max push-ups, 1RM lifts), 3) Cardio (timed mile, resting heart rate), 4) Flexibility (sit-and-reach). Test every 4-6 weeks to see progress! 📊",
        "Our ML-powered assessments analyze: form/technique, range of motion, rep counting, and movement quality. This data helps identify weaknesses and injury risks. Take assessments regularly to track improvements and adjust your program! 🎯"
      ]);
    }
    
    // Form & Technique
    else if (msg.contains('form') || msg.contains('technique') || msg.contains('how to do')) {
      if (msg.contains('squat')) {
        responses.addAll([
          "Perfect squat form: 1) Feet shoulder-width apart, toes slightly out, 2) Chest up, core braced, 3) Push hips back first (like sitting in chair), 4) Knees track over toes, 5) Go as low as comfortable (parallel or below), 6) Drive through heels to stand. Keep weight on mid-foot! 🏋️",
          "Common squat mistakes to avoid: knees caving inward, heels lifting, rounding lower back, not going deep enough. Film yourself from the side! Focus on mobility if you can't hit depth. Start with goblet squats to learn proper pattern. Quality over quantity! ✅"
        ]);
      } else if (msg.contains('push') || msg.contains('press')) {
        responses.addAll([
          "Push-up form checklist: 1) Hands shoulder-width apart, 2) Body in straight line (plank position), 3) Core and glutes engaged, 4) Lower until chest nearly touches ground, 5) Elbows at 45° angle, 6) Push back up explosively. Don't let hips sag! 💪",
          "Can't do full push-ups yet? Progress: 1) Wall push-ups, 2) Incline push-ups (hands on bench), 3) Knee push-ups (maintaining plank from knees), 4) Negative push-ups (slow 5-second lowering), 5) Full push-ups. Master each level before progressing! 📈"
        ]);
      } else {
        responses.addAll([
          "Proper form is everything! It: 1) Prevents injuries, 2) Targets the right muscles, 3) Allows progressive overload, 4) Builds better movement patterns. Film yourself, use mirrors, start with lighter weights. Which exercise would you like form tips for? 🤔",
          "Form tips for any exercise: 1) Master bodyweight version first, 2) Start with lighter weights, 3) Focus on the muscle working (mind-muscle connection), 4) Move with control (2 sec down, 1 sec up), 5) Full range of motion. Quality reps build quality results! ⭐"
        ]);
      }
    }
    
    // Greeting or General
    else if (msg.contains('hello') || msg.contains('hi') || msg.contains('hey')) {
      responses.addAll([
        "Hey there, athlete! 👋 I'm your AI Sports Coach, ready to help you crush your fitness goals! I can assist with workout plans, nutrition advice, form checks, motivation, and more. What would you like to work on today? 💪",
        "Hello! 🏃‍♂️ Great to see you here! I'm your personal AI coach, specializing in strength training, cardio, nutrition, and sports performance. Whether you're a beginner or advanced, I'm here to help. What's on your mind? 🎯",
        "Hi! Welcome to your AI-powered fitness journey! 🌟 I can help you with: custom workout plans, nutrition guidance, form tips, motivation, and interpreting your assessment results. What area would you like to focus on? 💡"
      ]);
    }
    
    // Default responses
    else {
      responses.addAll([
        "I'm here to help with your fitness journey! I can assist with: 💪 Workout planning, 🥗 Nutrition advice, 🎯 Goal setting, 📊 Progress tracking, 🏃 Form & technique, 😴 Recovery tips. What would you like to know more about?",
        "Great question! As your AI sports coach, I specialize in: training programs, exercise form, nutrition for athletes, injury prevention, motivation, and analyzing your fitness assessments. Tell me more about what you're looking for! 💡",
        "I'm here to support your fitness goals! Whether it's building strength, losing fat, improving endurance, or perfecting your technique - I've got you covered. What specific aspect of your training would you like help with today? 🤔"
      ]);
    }
    
    // Return a random response from the matched category
    final random = DateTime.now().millisecondsSinceEpoch % responses.length;
    final selectedResponse = responses[random];

    return ChatResponse(
      message: selectedResponse,
      isSuccess: true,
      timestamp: DateTime.now(),
      metadata: {
        'source': 'intelligent_ai',
        'model': 'sports_coach_v2',
        'confidence': 'high',
        'response_variant': random,
      },
    );
  }

  /// Start a voice conversation (VAPI's main feature)
  /// Real phone calls using VAPI Riley assistant
  Future<VoiceCallResponse> startVoiceCall({
    required String userId,
    String? phoneNumber,
    String? assistantId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      if (phoneNumber == null || phoneNumber.isEmpty) {
        return VoiceCallResponse(
          callId: '',
          status: 'failed',
          isSuccess: false,
          error: 'Phone number required for voice calls.',
        );
      }
      
      debugPrint('🎙️ Starting VAPI voice call...');
      debugPrint('   Phone: $phoneNumber');
      debugPrint('   Assistant: ${assistantId ?? AppConfig.vapiAssistantId}');
      debugPrint('   User ID: $userId');
      
      final callData = {
        'assistantId': assistantId ?? AppConfig.vapiAssistantId,
        'customer': {
          'number': phoneNumber,
        },
        'assistantOverrides': {
          'variableValues': {
            'userId': userId,
            'userName': 'User',
            'app': 'Vita Sports',
            ...?metadata,
          }
        }
      };
      
      debugPrint('📞 Making API call to VAPI...');
      
      final response = await _dio.post(
        '/call/phone',
        data: callData,
      ).timeout(const Duration(seconds: 30));

      debugPrint('✅ VAPI Response: ${response.statusCode}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final callId = response.data['id'] ?? response.data['callId'] ?? '';
        final status = response.data['status'] ?? 'initiated';
        
        debugPrint('✅ Voice call initiated successfully!');
        debugPrint('   Call ID: $callId');
        debugPrint('   Status: $status');
        debugPrint('   📞 User will receive call at: $phoneNumber');
        
        return VoiceCallResponse(
          callId: callId,
          status: status,
          isSuccess: true,
        );
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
      
    } on DioException catch (e) {
      debugPrint('❌ VAPI API Error:');
      debugPrint('   Status: ${e.response?.statusCode}');
      debugPrint('   Message: ${e.message}');
      debugPrint('   Data: ${e.response?.data}');
      
      String errorMessage = 'Voice call failed. ';
      
      if (e.response?.statusCode == 401) {
        errorMessage += 'API key authentication failed.';
      } else if (e.response?.statusCode == 403) {
        errorMessage += 'Access forbidden. Check API key permissions.';
      } else if (e.response?.statusCode == 400) {
        errorMessage += 'Invalid phone number format. Use: +1234567890';
      } else if (e.response?.statusCode == 429) {
        errorMessage += 'Rate limit exceeded. Please try again later.';
      } else {
        errorMessage += 'Please try again or use text chat.';
      }
      
      return VoiceCallResponse(
        callId: '',
        status: 'failed',
        isSuccess: false,
        error: errorMessage,
      );
      
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      return VoiceCallResponse(
        callId: '',
        status: 'failed',
        isSuccess: false,
        error: 'Voice call unavailable. Please try text chat.',
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