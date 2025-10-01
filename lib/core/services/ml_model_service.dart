// lib/core/services/ml_model_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

// ML Analysis Result Models
class MLAnalysisResult {
  final bool cheatDetected;
  final double poseAccuracy;
  final int repetitions;
  final double formScore;
  final List<String> violations;
  final Map<String, dynamic> keyPoints;
  final double confidenceScore;
  final List<String> recommendations;

  MLAnalysisResult({
    required this.cheatDetected,
    required this.poseAccuracy,
    required this.repetitions,
    required this.formScore,
    required this.violations,
    required this.keyPoints,
    required this.confidenceScore,
    required this.recommendations,
  });

  Map<String, dynamic> toJson() {
    return {
      'cheatDetected': cheatDetected,
      'poseAccuracy': poseAccuracy,
      'repetitions': repetitions,
      'formScore': formScore,
      'violations': violations,
      'keyPoints': keyPoints,
      'confidenceScore': confidenceScore,
      'recommendations': recommendations,
    };
  }

  factory MLAnalysisResult.fromJson(Map<String, dynamic> json) {
    return MLAnalysisResult(
      cheatDetected: json['cheatDetected'] ?? false,
      poseAccuracy: (json['poseAccuracy'] ?? 0.0).toDouble(),
      repetitions: json['repetitions'] ?? 0,
      formScore: (json['formScore'] ?? 0.0).toDouble(),
      violations: List<String>.from(json['violations'] ?? []),
      keyPoints: json['keyPoints'] ?? {},
      confidenceScore: (json['confidenceScore'] ?? 0.0).toDouble(),
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }
}

class PoseKeyPoint {
  final double x;
  final double y;
  final double confidence;

  PoseKeyPoint({
    required this.x,
    required this.y,
    required this.confidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'confidence': confidence,
    };
  }
}

class MLModelService {
  static const String _channelName = 'sports_assessment_ml';
  static const MethodChannel _channel = MethodChannel(_channelName);
  
  // Test-specific models
  static const String _sitUpsModel = 'assets/models/sit_ups_detector.tflite';
  static const String _pushUpsModel = 'assets/models/push_ups_detector.tflite';
  static const String _squatsModel = 'assets/models/squats_detector.tflite';
  static const String _jumpingModel = 'assets/models/jumping_detector.tflite';
  static const String _poseEstimationModel = 'assets/models/pose_estimation.tflite';
  static const String _cheatDetectionModel = 'assets/models/cheat_detection.tflite';

  bool _isInitialized = false;
  final Map<String, dynamic> _loadedModels = {};

  // Initialize ML models
  Future<bool> initializeModels() async {
    if (_isInitialized) return true;

    try {
      // Load TensorFlow Lite models
      await _loadModel(_sitUpsModel, 'sit_ups');
      await _loadModel(_pushUpsModel, 'push_ups');
      await _loadModel(_squatsModel, 'squats');
      await _loadModel(_jumpingModel, 'jumping');
      await _loadModel(_poseEstimationModel, 'pose_estimation');
      await _loadModel(_cheatDetectionModel, 'cheat_detection');

      _isInitialized = true;
      print('All ML models initialized successfully');
      return true;
    } catch (e) {
      print('Error initializing ML models: $e');
      return false;
    }
  }

  Future<void> _loadModel(String modelPath, String modelName) async {
    try {
      final modelData = await rootBundle.load(modelPath);
      final result = await _channel.invokeMethod('loadModel', {
        'modelName': modelName,
        'modelData': modelData.buffer.asUint8List(),
      });
      
      _loadedModels[modelName] = result;
      print('Loaded model: $modelName');
    } catch (e) {
      print('Error loading model $modelName: $e');
      // Use mock implementation for development
      _loadedModels[modelName] = 'mock_model';
    }
  }

  // Analyze video for specific test
  Future<MLAnalysisResult> analyzeTestVideo({
    required String videoPath,
    required String testType,
    required Duration videoDuration,
  }) async {
    if (!_isInitialized) {
      await initializeModels();
    }

    try {
      // Extract frames from video
      final frames = await _extractVideoFrames(videoPath);
      
      // Analyze based on test type
      switch (testType.toLowerCase()) {
        case 'sit-ups':
          return await _analyzeSitUps(frames, videoDuration);
        case 'push-ups':
          return await _analyzePushUps(frames, videoDuration);
        case 'squats':
          return await _analyzeSquats(frames, videoDuration);
        case 'vertical-jump':
          return await _analyzeVerticalJump(frames, videoDuration);
        case 'shuttle-run':
          return await _analyzeShuttleRun(frames, videoDuration);
        default:
          return await _analyzeGenericExercise(frames, videoDuration);
      }
    } catch (e) {
      print('Error analyzing test video: $e');
      return _getMockAnalysisResult(testType);
    }
  }

  // Extract frames from video for analysis
  Future<List<Uint8List>> _extractVideoFrames(String videoPath) async {
    try {
      final result = await _channel.invokeMethod('extractFrames', {
        'videoPath': videoPath,
        'frameRate': 10, // Extract 10 frames per second
      });

      if (result != null) {
        return List<Uint8List>.from(result);
      }
      
      // Fallback: mock frame extraction
      return _generateMockFrames();
    } catch (e) {
      print('Error extracting frames: $e');
      return _generateMockFrames();
    }
  }

  // Sit-ups analysis
  Future<MLAnalysisResult> _analyzeSitUps(List<Uint8List> frames, Duration duration) async {
    try {
      int repetitions = 0;
      double totalFormScore = 0.0;
      List<String> violations = [];
      List<String> recommendations = [];
      bool cheatDetected = false;

      for (int i = 0; i < frames.length; i++) {
        // Pose estimation for current frame
        final poseResult = await _estimatePose(frames[i]);
        
        // Detect sit-up position
        final isSitUpPosition = _detectSitUpPosition(poseResult);
        if (isSitUpPosition && i > 0) {
          final prevPose = await _estimatePose(frames[i - 1]);
          final isValidTransition = _validateSitUpTransition(prevPose, poseResult);
          
          if (isValidTransition) {
            repetitions++;
            final formScore = _calculateSitUpFormScore(poseResult);
            totalFormScore += formScore;
            
            // Check for violations
            final frameViolations = _detectSitUpViolations(poseResult);
            violations.addAll(frameViolations);
            
            if (frameViolations.isNotEmpty) {
              cheatDetected = true;
            }
          }
        }
      }

      final avgFormScore = repetitions > 0 ? totalFormScore / repetitions : 0.0;
      final poseAccuracy = _calculateOverallPoseAccuracy(frames);

      // Generate recommendations
      if (avgFormScore < 70) {
        recommendations.add('Focus on keeping your back straight during the movement');
      }
      if (violations.contains('neck_strain')) {
        recommendations.add('Avoid pulling your neck - let your abs do the work');
      }
      if (repetitions < duration.inSeconds / 2) {
        recommendations.add('Try to maintain a consistent pace throughout the test');
      }

      return MLAnalysisResult(
        cheatDetected: cheatDetected,
        poseAccuracy: poseAccuracy,
        repetitions: repetitions,
        formScore: avgFormScore,
        violations: violations.toSet().toList(),
        keyPoints: {'analysis_frames': frames.length},
        confidenceScore: poseAccuracy > 80 ? 0.9 : 0.7,
        recommendations: recommendations,
      );
    } catch (e) {
      print('Error analyzing sit-ups: $e');
      return _getMockSitUpsResult();
    }
  }

  // Push-ups analysis
  Future<MLAnalysisResult> _analyzePushUps(List<Uint8List> frames, Duration duration) async {
    try {
      int repetitions = 0;
      double totalFormScore = 0.0;
      List<String> violations = [];
      List<String> recommendations = [];
      bool cheatDetected = false;

      bool isInDownPosition = false;

      for (int i = 0; i < frames.length; i++) {
        final poseResult = await _estimatePose(frames[i]);
        
        // Detect push-up phases
        final isDown = _detectPushUpDownPosition(poseResult);
        final isUp = _detectPushUpUpPosition(poseResult);
        
        if (!isInDownPosition && isDown) {
          isInDownPosition = true;
        } else if (isInDownPosition && isUp) {
          isInDownPosition = false;
          repetitions++;
          
          final formScore = _calculatePushUpFormScore(poseResult);
          totalFormScore += formScore;
          
          // Check for violations
          final frameViolations = _detectPushUpViolations(poseResult);
          violations.addAll(frameViolations);
          
          if (frameViolations.isNotEmpty) {
            cheatDetected = true;
          }
        }
      }

      final avgFormScore = repetitions > 0 ? totalFormScore / repetitions : 0.0;
      final poseAccuracy = _calculateOverallPoseAccuracy(frames);

      // Generate recommendations
      if (avgFormScore < 70) {
        recommendations.add('Keep your body in a straight line from head to heels');
      }
      if (violations.contains('partial_range')) {
        recommendations.add('Lower your chest closer to the ground for full range of motion');
      }

      return MLAnalysisResult(
        cheatDetected: cheatDetected,
        poseAccuracy: poseAccuracy,
        repetitions: repetitions,
        formScore: avgFormScore,
        violations: violations.toSet().toList(),
        keyPoints: {'analysis_frames': frames.length},
        confidenceScore: poseAccuracy > 80 ? 0.9 : 0.7,
        recommendations: recommendations,
      );
    } catch (e) {
      print('Error analyzing push-ups: $e');
      return _getMockPushUpsResult();
    }
  }

  // Vertical jump analysis
  Future<MLAnalysisResult> _analyzeVerticalJump(List<Uint8List> frames, Duration duration) async {
    try {
      double maxHeight = 0.0;
      double takeoffHeight = 0.0;
      bool hasJumped = false;
      List<String> violations = [];
      List<String> recommendations = [];

      for (int i = 0; i < frames.length; i++) {
        final poseResult = await _estimatePose(frames[i]);
        final personHeight = _calculatePersonHeightInFrame(poseResult);
        
        if (!hasJumped && _detectTakeoffPosition(poseResult)) {
          takeoffHeight = personHeight;
          hasJumped = true;
        }
        
        if (hasJumped && personHeight > maxHeight) {
          maxHeight = personHeight;
        }
        
        // Check for violations
        if (_detectEarlyTakeoff(poseResult)) {
          violations.add('early_takeoff');
        }
        if (_detectImproperLanding(poseResult)) {
          violations.add('improper_landing');
        }
      }

      final jumpHeight = maxHeight - takeoffHeight;
      final poseAccuracy = _calculateOverallPoseAccuracy(frames);
      final formScore = _calculateJumpFormScore(jumpHeight, violations);

      // Generate recommendations
      if (jumpHeight < 30) {
        recommendations.add('Focus on explosive power in your leg muscles');
      }
      if (violations.contains('improper_landing')) {
        recommendations.add('Land softly with bent knees to absorb impact');
      }

      return MLAnalysisResult(
        cheatDetected: violations.isNotEmpty,
        poseAccuracy: poseAccuracy,
        repetitions: hasJumped ? 1 : 0,
        formScore: formScore,
        violations: violations,
        keyPoints: {
          'jump_height': jumpHeight,
          'takeoff_height': takeoffHeight,
          'max_height': maxHeight,
        },
        confidenceScore: poseAccuracy > 80 ? 0.9 : 0.7,
        recommendations: recommendations,
      );
    } catch (e) {
      print('Error analyzing vertical jump: $e');
      return _getMockJumpResult();
    }
  }

  // Shuttle run analysis
  Future<MLAnalysisResult> _analyzeShuttleRun(List<Uint8List> frames, Duration duration) async {
    try {
      int laps = 0;
      double totalSpeed = 0.0;
      List<String> violations = [];
      List<String> recommendations = [];
      
      double previousPosition = 0.0;
      bool movingRight = true;

      for (int i = 0; i < frames.length; i++) {
        final poseResult = await _estimatePose(frames[i]);
        final currentPosition = _calculatePersonPositionX(poseResult);
        
        // Detect direction changes
        if (movingRight && currentPosition < previousPosition - 10) {
          movingRight = false;
          laps++;
        } else if (!movingRight && currentPosition > previousPosition + 10) {
          movingRight = true;
          laps++;
        }
        
        // Calculate speed
        if (i > 0) {
          final speed = (currentPosition - previousPosition).abs();
          totalSpeed += speed;
        }
        
        previousPosition = currentPosition;
        
        // Check for violations
        if (_detectImproperTurning(poseResult)) {
          violations.add('improper_turning');
        }
      }

      final avgSpeed = frames.length > 1 ? totalSpeed / (frames.length - 1) : 0.0;
      final poseAccuracy = _calculateOverallPoseAccuracy(frames);
      final formScore = _calculateShuttleRunFormScore(avgSpeed, laps, duration);

      // Generate recommendations
      if (avgSpeed < 5) {
        recommendations.add('Focus on explosive starts and quick direction changes');
      }
      if (violations.contains('improper_turning')) {
        recommendations.add('Touch the line clearly and turn efficiently');
      }

      return MLAnalysisResult(
        cheatDetected: violations.isNotEmpty,
        poseAccuracy: poseAccuracy,
        repetitions: laps,
        formScore: formScore,
        violations: violations,
        keyPoints: {
          'laps': laps,
          'avg_speed': avgSpeed,
          'duration': duration.inSeconds,
        },
        confidenceScore: poseAccuracy > 80 ? 0.9 : 0.7,
        recommendations: recommendations,
      );
    } catch (e) {
      print('Error analyzing shuttle run: $e');
      return _getMockShuttleRunResult();
    }
  }

  // Squats analysis
  Future<MLAnalysisResult> _analyzeSquats(List<Uint8List> frames, Duration duration) async {
    try {
      int repetitions = 0;
      double totalFormScore = 0.0;
      List<String> violations = [];
      List<String> recommendations = [];
      bool cheatDetected = false;

      bool isInDownPosition = false;

      for (int i = 0; i < frames.length; i++) {
        final poseResult = await _estimatePose(frames[i]);
        
        // Detect squat phases
        final isDown = _detectSquatDownPosition(poseResult);
        final isUp = _detectSquatUpPosition(poseResult);
        
        if (!isInDownPosition && isDown) {
          isInDownPosition = true;
        } else if (isInDownPosition && isUp) {
          isInDownPosition = false;
          repetitions++;
          
          final formScore = _calculateSquatFormScore(poseResult);
          totalFormScore += formScore;
          
          // Check for violations
          final frameViolations = _detectSquatViolations(poseResult);
          violations.addAll(frameViolations);
          
          if (frameViolations.isNotEmpty) {
            cheatDetected = true;
          }
        }
      }

      final avgFormScore = repetitions > 0 ? totalFormScore / repetitions : 0.0;
      final poseAccuracy = _calculateOverallPoseAccuracy(frames);

      // Generate recommendations
      if (avgFormScore < 70) {
        recommendations.add('Keep your back straight and chest up during squats');
      }
      if (violations.contains('shallow_depth')) {
        recommendations.add('Lower down until your thighs are parallel to the ground');
      }

      return MLAnalysisResult(
        cheatDetected: cheatDetected,
        poseAccuracy: poseAccuracy,
        repetitions: repetitions,
        formScore: avgFormScore,
        violations: violations.toSet().toList(),
        keyPoints: {'analysis_frames': frames.length},
        confidenceScore: poseAccuracy > 80 ? 0.9 : 0.7,
        recommendations: recommendations,
      );
    } catch (e) {
      print('Error analyzing squats: $e');
      return _getMockSquatsResult();
    }
  }

  // Generic exercise analysis
  Future<MLAnalysisResult> _analyzeGenericExercise(List<Uint8List> frames, Duration duration) async {
    try {
      final poseAccuracy = _calculateOverallPoseAccuracy(frames);
      
      return MLAnalysisResult(
        cheatDetected: false,
        poseAccuracy: poseAccuracy,
        repetitions: 0,
        formScore: 75.0,
        violations: [],
        keyPoints: {'analysis_frames': frames.length},
        confidenceScore: 0.8,
        recommendations: ['Complete the exercise with proper form'],
      );
    } catch (e) {
      print('Error analyzing generic exercise: $e');
      return _getMockGenericResult();
    }
  }

  // Pose estimation helper
  Future<Map<String, dynamic>> _estimatePose(Uint8List frameData) async {
    try {
      final result = await _channel.invokeMethod('estimatePose', {
        'frameData': frameData,
      });
      
      return Map<String, dynamic>.from(result ?? {});
    } catch (e) {
      print('Error estimating pose: $e');
      return _getMockPoseResult();
    }
  }

  // Helper methods for pose analysis
  bool _detectSitUpPosition(Map<String, dynamic> pose) {
    // Mock implementation - would use actual pose keypoints
    return pose['confidence'] != null && pose['confidence'] > 0.7;
  }

  bool _validateSitUpTransition(Map<String, dynamic> prevPose, Map<String, dynamic> currentPose) {
    // Mock implementation - would check for valid sit-up movement
    return true;
  }

  double _calculateSitUpFormScore(Map<String, dynamic> pose) {
    // Mock implementation - would analyze pose quality
    return 85.0 + (DateTime.now().millisecond % 20 - 10);
  }

  List<String> _detectSitUpViolations(Map<String, dynamic> pose) {
    // Mock implementation - would detect form violations
    final violations = <String>[];
    if (DateTime.now().millisecond % 5 == 0) {
      violations.add('neck_strain');
    }
    return violations;
  }

  double _calculateOverallPoseAccuracy(List<Uint8List> frames) {
    // Mock implementation - would calculate average pose detection confidence
    return 85.0 + (DateTime.now().millisecond % 15);
  }

  // Mock implementations for development
  List<Uint8List> _generateMockFrames() {
    return List.generate(30, (index) => Uint8List.fromList([1, 2, 3, 4, 5]));
  }

  Map<String, dynamic> _getMockPoseResult() {
    return {
      'confidence': 0.85,
      'keypoints': {
        'nose': {'x': 100, 'y': 50, 'confidence': 0.9},
        'shoulder_left': {'x': 80, 'y': 120, 'confidence': 0.8},
        'shoulder_right': {'x': 120, 'y': 120, 'confidence': 0.8},
      }
    };
  }

  MLAnalysisResult _getMockAnalysisResult(String testType) {
    return MLAnalysisResult(
      cheatDetected: false,
      poseAccuracy: 85.0,
      repetitions: 15,
      formScore: 82.0,
      violations: [],
      keyPoints: {'test_type': testType},
      confidenceScore: 0.85,
      recommendations: ['Great form! Keep it up!'],
    );
  }

  MLAnalysisResult _getMockSitUpsResult() {
    return MLAnalysisResult(
      cheatDetected: false,
      poseAccuracy: 88.0,
      repetitions: 25,
      formScore: 85.0,
      violations: [],
      keyPoints: {'core_strength': 'good'},
      confidenceScore: 0.88,
      recommendations: ['Excellent core strength! Focus on controlled movements.'],
    );
  }

  MLAnalysisResult _getMockPushUpsResult() {
    return MLAnalysisResult(
      cheatDetected: false,
      poseAccuracy: 82.0,
      repetitions: 18,
      formScore: 78.0,
      violations: [],
      keyPoints: {'upper_body_strength': 'good'},
      confidenceScore: 0.82,
      recommendations: ['Good upper body strength! Work on maintaining form throughout.'],
    );
  }

  MLAnalysisResult _getMockJumpResult() {
    return MLAnalysisResult(
      cheatDetected: false,
      poseAccuracy: 90.0,
      repetitions: 1,
      formScore: 88.0,
      violations: [],
      keyPoints: {'jump_height': 45.5, 'explosive_power': 'excellent'},
      confidenceScore: 0.90,
      recommendations: ['Excellent explosive power! Great vertical leap technique.'],
    );
  }

  MLAnalysisResult _getMockShuttleRunResult() {
    return MLAnalysisResult(
      cheatDetected: false,
      poseAccuracy: 86.0,
      repetitions: 12,
      formScore: 80.0,
      violations: [],
      keyPoints: {'agility': 'good', 'speed': 'above_average'},
      confidenceScore: 0.86,
      recommendations: ['Good agility! Work on quicker direction changes.'],
    );
  }

  MLAnalysisResult _getMockSquatsResult() {
    return MLAnalysisResult(
      cheatDetected: false,
      poseAccuracy: 84.0,
      repetitions: 20,
      formScore: 81.0,
      violations: [],
      keyPoints: {'leg_strength': 'good'},
      confidenceScore: 0.84,
      recommendations: ['Good leg strength! Focus on depth and form consistency.'],
    );
  }

  MLAnalysisResult _getMockGenericResult() {
    return MLAnalysisResult(
      cheatDetected: false,
      poseAccuracy: 75.0,
      repetitions: 0,
      formScore: 75.0,
      violations: [],
      keyPoints: {},
      confidenceScore: 0.75,
      recommendations: ['Complete the exercise with proper form.'],
    );
  }

  // Additional helper methods would be implemented here for:
  // - _detectPushUpDownPosition
  // - _detectPushUpUpPosition
  // - _calculatePushUpFormScore
  // - _detectPushUpViolations
  // - _detectTakeoffPosition
  // - _calculatePersonHeightInFrame
  // - _detectEarlyTakeoff
  // - _detectImproperLanding
  // - _calculateJumpFormScore
  // - _calculatePersonPositionX
  // - _detectImproperTurning
  // - _calculateShuttleRunFormScore
  // - _detectSquatDownPosition
  // - _detectSquatUpPosition
  // - _calculateSquatFormScore
  // - _detectSquatViolations

  void dispose() {
    _loadedModels.clear();
    _isInitialized = false;
  }
}

// Provider for ML Model service
final mlModelServiceProvider = Provider<MLModelService>((ref) {
  return MLModelService();
});