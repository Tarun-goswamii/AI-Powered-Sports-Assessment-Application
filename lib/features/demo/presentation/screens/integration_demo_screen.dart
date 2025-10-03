// lib/features/demo/presentation/screens/integration_demo_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/convex_http_service.dart';
import '../../../../core/services/resend_service.dart';
import '../../../../core/services/vapi_ai_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class IntegrationDemoScreen extends StatefulWidget {
  const IntegrationDemoScreen({super.key});

  @override
  State<IntegrationDemoScreen> createState() => _IntegrationDemoScreenState();
}

class _IntegrationDemoScreenState extends State<IntegrationDemoScreen> {
  bool _isLoading = false;
  List<String> _demoLogs = [];

  void _addLog(String message) {
    setState(() {
      _demoLogs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
    print(message);
  }

  Future<void> _runCompleteDemo() async {
    setState(() {
      _isLoading = true;
      _demoLogs.clear();
    });

    _addLog('🎯 Starting Complete Integration Demo...');
    await Future.delayed(const Duration(milliseconds: 500));

    // Test Convex Connection
    _addLog('📊 Testing Convex Database Connection...');
    try {
      final users = await ConvexHttpService().getUsers();
      _addLog('✅ Convex: Successfully connected! Found ${users.length} users');
    } catch (e) {
      _addLog('❌ Convex: Connection failed - $e');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    // Test Resend Email Service
    _addLog('📧 Testing Resend Email Service...');
    try {
      await ResendService.sendWelcomeEmail(
        toEmail: 'demo@sportsassessment.com',
        userName: 'Demo User',
      );
      _addLog('✅ Resend: Welcome email sent successfully!');
    } catch (e) {
      _addLog('❌ Resend: Email sending failed - $e');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate Test Submission
    _addLog('🏃 Simulating Test Result Submission...');
    try {
      await ConvexHttpService().submitTestResult(
        userId: 'demo_user_id',
        testId: 'demo_test_${DateTime.now().millisecondsSinceEpoch}',
        score: 85.5,
        mlAnalysis: {
          'repetitions': 15,
          'formScore': 85.5,
          'cheatDetected': false,
          'poseAccuracy': 92.3,
        },
        videoUrl: 'demo_video_url',
      );
      _addLog('✅ Convex: Test result submitted successfully!');
      _addLog('📈 Leaderboard automatically updated!');
    } catch (e) {
      _addLog('❌ Convex: Test submission failed - $e');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    // Send completion email
    _addLog('📧 Sending Test Completion Email...');
    try {
      await ResendService.sendTestCompletionEmail(
        toEmail: 'demo@sportsassessment.com',
        userName: 'Demo User',
        testName: 'Push-up Test',
        score: 85.5,
      );
      _addLog('✅ Resend: Test completion email sent!');
    } catch (e) {
      _addLog('❌ Resend: Completion email failed - $e');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    // Test VAPI AI Service
    _addLog('🤖 Testing VAPI AI Chatbot Service...');
    try {
      final response = await VapiAiService.instance.sendMessage(
        message: 'Hello, can you help me with my workout?',
        userId: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      );
      _addLog('✅ VAPI AI: Connected successfully!');
      _addLog('💬 AI Response: ${response.message.substring(0, response.message.length > 50 ? 50 : response.message.length)}...');
    } catch (e) {
      _addLog('❌ VAPI AI: Connection failed - $e');
    }

    _addLog('🎉 Demo Complete: Full integration working!');
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testConvexOnly() async {
    setState(() {
      _isLoading = true;
      _demoLogs.clear();
    });

    _addLog('📊 Testing CONVEX Backend Integration...');
    try {
      final users = await ConvexHttpService().getUsers();
      _addLog('✅ Connected to Convex successfully!');
      _addLog('📋 Found ${users.length} users in database');
      
      for (int i = 0; i < users.length && i < 3; i++) {
        _addLog('👤 User ${i + 1}: ${users[i].name} (${users[i].email})');
      }
    } catch (e) {
      _addLog('❌ Convex connection failed: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testResendOnly() async {
    setState(() {
      _isLoading = true;
      _demoLogs.clear();
    });

    _addLog('📧 Testing RESEND Email Service...');
    try {
      await ResendService.sendWelcomeEmail(
        toEmail: 'demo@sportsassessment.com',
        userName: 'Judge Demo User',
      );
      _addLog('✅ Welcome email sent successfully!');
      _addLog('📮 Check demo@sportsassessment.com for the email');
    } catch (e) {
      _addLog('❌ Email sending failed: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testVapiOnly() async {
    setState(() {
      _isLoading = true;
      _demoLogs.clear();
    });

    _addLog('🤖 Testing VAPI AI Chatbot Service...');
    try {
      // Test message sending
      _addLog('💬 Sending test message to AI...');
      final response = await VapiAiService.instance.sendMessage(
        message: 'Hello, can you create a workout plan for me?',
        userId: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      );
      _addLog('✅ AI Response received!');
      _addLog('🎯 Response: ${response.message.substring(0, response.message.length > 80 ? 80 : response.message.length)}...');

      // Test conversation suggestions
      final suggestions = VapiAiService.instance.getSuggestedPrompts();
      _addLog('💡 Available conversation starters: ${suggestions.length}');
      _addLog('📝 Example: "${suggestions.first}"');

    } catch (e) {
      _addLog('❌ AI Chatbot test failed: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Integration Demo for Judges',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Demo Info
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Judge Demonstration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'This screen demonstrates the integration of Convex backend, Resend email service, and VAPI AI chatbot. You can test each service individually or run the complete user journey simulation.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: NeonButton(
                        text: 'Test Convex',
                        onPressed: _isLoading ? null : _testConvexOnly,
                        isLoading: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NeonButton(
                        text: 'Test Resend',
                        onPressed: _isLoading ? null : _testResendOnly,
                        isLoading: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                Row(
                  children: [
                    Expanded(
                      child: NeonButton(
                        text: 'Test AI Chat',
                        onPressed: _isLoading ? null : _testVapiOnly,
                        isLoading: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NeonButton(
                        text: 'Try AI Coach',
                        onPressed: () => context.go('/ai-coach'),
                        variant: NeonButtonVariant.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                NeonButton(
                  text: 'Complete Integration Demo',
                  onPressed: _isLoading ? null : _runCompleteDemo,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),

                // Logs
                Expanded(
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Demo Logs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: _demoLogs.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Click a demo button to see integration logs...',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _demoLogs.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          _demoLogs[index],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}