import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/app_config.dart';
import '../models/mentor_model.dart';

class MentorService {
  static const String baseUrl = AppConfig.convexUrl;

  Future<List<MentorModel>> getAllMentors() async {
    if (!AppConfig.enableConvexBackend) {
      return _getMockMentors();
    }

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getAllMentors',
          'args': {},
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> mentorsJson = data['value'] ?? [];
        return mentorsJson.map((json) => MentorModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch mentors: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getAllMentors failed: $e');
      return _getMockMentors();
    }
  }

  Future<MentorModel?> getMentorById(String mentorId) async {
    if (!AppConfig.enableConvexBackend) {
      return _getMockMentors().where((m) => m.id == mentorId).firstOrNull;
    }

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getMentorById',
          'args': {'mentorId': mentorId},
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['value'] != null ? MentorModel.fromJson(data['value']) : null;
      } else {
        throw Exception('Failed to fetch mentor: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getMentorById failed: $e');
      return _getMockMentors().where((m) => m.id == mentorId).firstOrNull;
    }
  }

  Future<List<MentorModel>> getMentorsBySpecialty(String specialty) async {
    final allMentors = await getAllMentors();
    return allMentors.where((mentor) =>
        mentor.specialty.toLowerCase().contains(specialty.toLowerCase()) ||
        mentor.expertise.any((exp) => exp.toLowerCase().contains(specialty.toLowerCase()))
    ).toList();
  }

  Future<List<MentorModel>> getAvailableMentors() async {
    final allMentors = await getAllMentors();
    return allMentors.where((mentor) => mentor.isAvailable).toList();
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppConfig.convexToken}',
    };
  }

  List<MentorModel> _getMockMentors() {
    return [
      MentorModel(
        id: '1',
        name: 'Coach Johnson',
        title: 'Elite Sprint Coach',
        specialty: '100m & 200m Sprints',
        bio: 'Former Olympic sprinter with 15+ years of coaching experience. Specializes in speed development and technique refinement.',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        rating: 4.9,
        sessionsCount: 250,
        experienceYears: 15,
        expertise: ['Sprint Technique', 'Speed Training', 'Race Strategy'],
        isAvailable: true,
        hourlyRate: 150.0,
        location: 'New York, NY',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      ),
      MentorModel(
        id: '2',
        name: 'Dr. Sarah Chen',
        title: 'Sports Nutritionist',
        specialty: 'Athletic Nutrition',
        bio: 'PhD in Sports Nutrition. Helps athletes optimize their diet for peak performance and recovery.',
        imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400',
        rating: 4.8,
        sessionsCount: 180,
        experienceYears: 12,
        expertise: ['Meal Planning', 'Supplementation', 'Weight Management'],
        isAvailable: true,
        hourlyRate: 120.0,
        location: 'Los Angeles, CA',
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now(),
      ),
      MentorModel(
        id: '3',
        name: 'Mike Rodriguez',
        title: 'Strength & Conditioning Coach',
        specialty: 'Power Development',
        bio: 'Certified strength coach specializing in explosive power training for sprinters and athletes.',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        rating: 4.7,
        sessionsCount: 320,
        experienceYears: 18,
        expertise: ['Weight Training', 'Plyometrics', 'Injury Prevention'],
        isAvailable: false,
        hourlyRate: 130.0,
        location: 'Chicago, IL',
        createdAt: DateTime.now().subtract(const Duration(days: 400)),
        updatedAt: DateTime.now(),
      ),
      MentorModel(
        id: '4',
        name: 'Emma Thompson',
        title: 'Mental Performance Coach',
        specialty: 'Sports Psychology',
        bio: 'Helps athletes develop mental toughness, focus, and competitive mindset for optimal performance.',
        imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400',
        rating: 4.9,
        sessionsCount: 95,
        experienceYears: 10,
        expertise: ['Mental Training', 'Visualization', 'Stress Management'],
        isAvailable: true,
        hourlyRate: 140.0,
        location: 'Austin, TX',
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
      ),
      MentorModel(
        id: '5',
        name: 'David Kim',
        title: 'Recovery Specialist',
        specialty: 'Sports Recovery',
        bio: 'Expert in recovery techniques, massage therapy, and rehabilitation for athletic injuries.',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        rating: 4.6,
        sessionsCount: 150,
        experienceYears: 14,
        expertise: ['Massage Therapy', 'Cryotherapy', 'Rehabilitation'],
        isAvailable: true,
        hourlyRate: 110.0,
        location: 'Seattle, WA',
        createdAt: DateTime.now().subtract(const Duration(days: 250)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
