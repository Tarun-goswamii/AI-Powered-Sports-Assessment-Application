// lib/features/mentors/presentation/screens/mentor_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  State<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> mentors = [
    {
      'id': '1',
      'name': 'Coach Rajesh Kumar',
      'specialization': 'Track & Field',
      'experience': '8 years',
      'rating': 4.9,
      'reviews': 127,
      'hourlyRate': 1500,
      'avatar': 'RK',
      'available': true,
      'location': 'Mumbai',
      'certifications': ['Level 3 Athletics Coach', 'Sports Science Degree'],
    },
    {
      'id': '2',
      'name': 'Dr. Priya Sharma',
      'specialization': 'Sports Nutrition',
      'experience': '6 years',
      'rating': 4.8,
      'reviews': 89,
      'hourlyRate': 1200,
      'avatar': 'PS',
      'available': true,
      'location': 'Delhi',
      'certifications': ['Sports Nutritionist', 'PhD in Nutrition'],
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'specialization': 'Strength Training',
      'experience': '10 years',
      'rating': 4.7,
      'reviews': 203,
      'hourlyRate': 1800,
      'avatar': 'MJ',
      'available': false,
      'location': 'Bangalore',
      'certifications': ['CSCS Certified', 'Powerlifting Coach'],
    },
    {
      'id': '4',
      'name': 'Dr. Amit Patel',
      'specialization': 'Sports Medicine',
      'experience': '12 years',
      'rating': 4.9,
      'reviews': 156,
      'hourlyRate': 2000,
      'avatar': 'AP',
      'available': true,
      'location': 'Ahmedabad',
      'certifications': ['Sports Medicine MD', 'Orthopedic Specialist'],
    },
  ];

  final List<String> categories = [
    'All',
    'Track & Field',
    'Strength Training',
    'Sports Nutrition',
    'Sports Medicine',
    'Basketball',
    'Football',
    'Swimming',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMentors = _selectedCategory == 'All'
        ? mentors
        : mentors.where((mentor) => mentor['specialization'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Find a Mentor',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openFilters,
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            // Category Filter
            Container(
              height: 50,
              margin: const EdgeInsets.all(20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == _selectedCategory;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: AppColors.card,
                      selectedColor: AppColors.royalPurple.withOpacity(0.3),
                      checkmarkColor: AppColors.royalPurple,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.royalPurple : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.royalPurple : AppColors.border,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Mentors List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: filteredMentors.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildMentorCard(filteredMentors[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorCard(Map<String, dynamic> mentor) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Avatar and Status
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.royalPurple,
                child: Text(
                  mentor['avatar'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            mentor['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: mentor['available']
                                ? AppColors.neonGreen.withOpacity(0.2)
                                : AppColors.warmOrange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: mentor['available']
                                  ? AppColors.neonGreen
                                  : AppColors.warmOrange,
                            ),
                          ),
                          child: Text(
                            mentor['available'] ? 'Available' : 'Busy',
                            style: TextStyle(
                              fontSize: 10,
                              color: mentor['available']
                                  ? AppColors.neonGreen
                                  : AppColors.warmOrange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mentor['specialization'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mentor['location'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Rating and Experience
          Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Color(0xFFFFC107),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mentor['rating'].toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${mentor['reviews']} reviews)',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(
                    Icons.work,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${mentor['experience']} experience',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Certifications
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: (mentor['certifications'] as List<String>).map((cert) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.electricBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.electricBlue.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  cert,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.electricBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Price and Book Button
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${mentor['hourlyRate']}/hour',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonGreen,
                    ),
                  ),
                  Text(
                    'Starting price',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              NeonButton(
                text: 'Book Session',
                size: NeonButtonSize.small,
                onPressed: () => _bookMentor(mentor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openFilters() {
    // TODO: Open advanced filters
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Advanced filters coming soon!')),
    );
  }

  void _bookMentor(Map<String, dynamic> mentor) {
    // TODO: Navigate to booking screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking ${mentor['name']}')),
    );
  }
}
