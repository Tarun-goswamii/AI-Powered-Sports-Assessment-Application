// Additional Convex Functions for Community, Store, ML Integration, and Profile

import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

// ML Enhanced Test Submission
export const submitTestResultWithML = mutation({
  args: {
    userId: v.id("users"),
    testId: v.string(),
    score: v.number(),
    mlAnalysis: v.object({
      cheatDetected: v.boolean(),
      poseAccuracy: v.number(),
      repetitions: v.number(),
      formScore: v.number(),
      violations: v.array(v.string()),
      keyPoints: v.any(),
      confidenceScore: v.number(),
      recommendations: v.array(v.string()),
    }),
    videoUrl: v.string(),
    completedAt: v.number(),
  },
  handler: async (ctx, args) => {
    // Insert test result with ML analysis
    const resultId = await ctx.db.insert("test_results", {
      userId: args.userId,
      testId: args.testId,
      score: args.score,
      status: 'completed',
      mlAnalysis: args.mlAnalysis,
      videoUrl: args.videoUrl,
      completedAt: args.completedAt,
      metadata: {
        cheatDetected: args.mlAnalysis.cheatDetected,
        poseAccuracy: args.mlAnalysis.poseAccuracy,
        repetitions: args.mlAnalysis.repetitions,
        formScore: args.mlAnalysis.formScore,
      }
    });

    // Update user's total score
    const user = await ctx.db.get(args.userId);
    if (user) {
      const newTotalScore = user.totalScore + args.score;
      await ctx.db.patch(args.userId, {
        totalScore: newTotalScore,
        updatedAt: Date.now(),
      });

      // Update leaderboard
      await updateUserLeaderboard(ctx, args.userId, newTotalScore);
    }

    // Check for achievements
    await checkAndUnlockAchievements(ctx, args.userId, args.testId, args.score, args.mlAnalysis);

    return resultId;
  },
});

// Dynamic Leaderboard with Real-time Updates
export const getLeaderboard = query({
  args: { 
    limit: v.optional(v.number()),
    testType: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const limit = args.limit || 50;
    
    if (args.testType) {
      // Get leaderboard for specific test type
      const testResults = await ctx.db
        .query("test_results")
        .withIndex("by_score", (q: any) => q.gt("score", 0))
        .order("desc")
        .take(limit);
      
      return testResults.filter((result: any) => result.testId === args.testType);
    } else {
      // Get overall leaderboard
      return await ctx.db
        .query("leaderboard")
        .withIndex("by_score", (q: any) => q.gt("totalScore", 0))
        .order("desc")
        .take(limit);
    }
  },
});

// Update leaderboard position
async function updateUserLeaderboard(ctx: any, userId: any, totalScore: number) {
  // Check if user already has a leaderboard entry
  const existingEntry = await ctx.db
    .query("leaderboard")
    .withIndex("by_user", (q) => q.eq("userId", userId))
    .first();

  if (existingEntry) {
    // Update existing entry
    await ctx.db.patch(existingEntry._id, {
      totalScore: totalScore,
      rank: await calculateUserRank(ctx, totalScore),
    });
  } else {
    // Create new leaderboard entry
    await ctx.db.insert("leaderboard", {
      userId: userId,
      totalScore: totalScore,
      rank: await calculateUserRank(ctx, totalScore),
    });
  }
}

// Calculate user rank based on score
async function calculateUserRank(ctx: any, totalScore: number): Promise<number> {
  const higherScores = await ctx.db
    .query("leaderboard")
    .withIndex("by_score", (q) => q.gt("totalScore", totalScore))
    .collect();
  
  return higherScores.length + 1;
}

// Achievement system with ML integration
async function checkAndUnlockAchievements(
  ctx: any, 
  userId: any, 
  testId: string, 
  score: number, 
  mlAnalysis: any
) {
  const userResults = await ctx.db
    .query("test_results")
    .withIndex("by_user", (q) => q.eq("userId", userId))
    .collect();

  const achievements = [];

  // First test completion
  if (userResults.length === 1) {
    achievements.push("first_test");
  }

  // High score achievements
  if (score >= 100) achievements.push("century_score");
  if (score >= 200) achievements.push("double_century");

  // Perfect form achievement
  if (mlAnalysis.formScore >= 95 && !mlAnalysis.cheatDetected) {
    achievements.push("perfect_form");
  }

  // Test-specific achievements
  switch (testId.toLowerCase()) {
    case "sit-ups":
      if (mlAnalysis.repetitions >= 50) achievements.push("sit_up_master");
      break;
    case "push-ups":
      if (mlAnalysis.repetitions >= 30) achievements.push("push_up_champion");
      break;
    case "vertical-jump":
      const jumpHeight = mlAnalysis.keyPoints?.jump_height ?? 0;
      if (jumpHeight >= 60) achievements.push("high_jumper");
      break;
  }

  // Unlock achievements
  for (const achievementId of achievements) {
    const existing = await ctx.db
      .query("user_achievements")
      .withIndex("by_user_achievement", (q) => 
        q.eq("userId", userId).eq("achievementId", achievementId))
      .first();

    if (!existing) {
      await ctx.db.insert("user_achievements", {
        userId: userId,
        achievementId: achievementId,
        unlockedAt: Date.now(),
      });
    }
  }
}

// Community Functions
export const getCommunityPosts = query({
  args: { limit: v.optional(v.number()) },
  handler: async (ctx, args) => {
    const limit = args.limit || 20;
    return await ctx.db
      .query("community_posts")
      .withIndex("by_createdAt", (q) => q.gt("createdAt", 0))
      .order("desc")
      .take(limit)
      .collect();
  },
});

export const createCommunityPost = mutation({
  args: {
    userId: v.id("users"),
    content: v.string(),
    type: v.optional(v.string()),
    imageUrl: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const postId = await ctx.db.insert("community_posts", {
      userId: args.userId,
      content: args.content,
      type: args.type || "general",
      imageUrl: args.imageUrl,
      likes: 0,
      comments: 0,
      createdAt: Date.now(),
    });

    return postId;
  },
});

export const likeCommunityPost = mutation({
  args: {
    postId: v.id("community_posts"),
    userId: v.id("users"),
  },
  handler: async (ctx, args) => {
    const post = await ctx.db.get(args.postId);
    if (post) {
      await ctx.db.patch(args.postId, {
        likes: post.likes + 1,
      });
      return true;
    }
    return false;
  },
});

export const getCommunityChallenges = query({
  args: {},
  handler: async (ctx) => {
    return await ctx.db
      .query("challenges")
      .withIndex("by_active", (q) => q.eq("isActive", true))
      .order("desc")
      .collect();
  },
});

export const getCommunityGroups = query({
  args: {},
  handler: async (ctx) => {
    return await ctx.db
      .query("community_groups")
      .withIndex("by_public", (q) => q.eq("isPublic", true))
      .collect();
  },
});

export const joinCommunityGroup = mutation({
  args: {
    userId: v.id("users"),
    groupId: v.id("community_groups"),
  },
  handler: async (ctx, args) => {
    const existing = await ctx.db
      .query("group_members")
      .withIndex("by_user_group", (q) =>
        q.eq("userId", args.userId).eq("groupId", args.groupId)
      )
      .first();

    if (!existing) {
      await ctx.db.insert("group_members", {
        userId: args.userId,
        groupId: args.groupId,
        joinedAt: Date.now(),
      });

      // Update group member count
      const group = await ctx.db.get(args.groupId);
      if (group) {
        await ctx.db.patch(args.groupId, {
          memberCount: group.memberCount + 1,
        });
      }

      return true; // Joined
    }

    return false; // Already member
  },
});

// Enhanced User Profile with ML Stats
export const getUserProfileWithStats = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const user = await ctx.db.get(args.userId);
    if (!user) return null;

    // Get test results with ML analysis
    const testResults = await ctx.db
      .query("test_results")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    // Calculate ML-based stats
    const mlStats = {
      averageFormScore: 0,
      totalRepetitions: 0,
      cheatDetectionRate: 0,
      averagePoseAccuracy: 0,
      testsByType: {} as Record<string, number>,
    };

    if (testResults.length > 0) {
      let totalFormScore = 0;
      let totalRepetitions = 0;
      let cheatsDetected = 0;
      let totalPoseAccuracy = 0;

      testResults.forEach(result => {
        if (result.mlAnalysis) {
          totalFormScore += result.mlAnalysis.formScore || 0;
          totalRepetitions += result.mlAnalysis.repetitions || 0;
          if (result.mlAnalysis.cheatDetected) cheatsDetected++;
          totalPoseAccuracy += result.mlAnalysis.poseAccuracy || 0;
          
          const testType = result.testId;
          mlStats.testsByType[testType] = (mlStats.testsByType[testType] || 0) + 1;
        }
      });

      mlStats.averageFormScore = totalFormScore / testResults.length;
      mlStats.totalRepetitions = totalRepetitions;
      mlStats.cheatDetectionRate = (cheatsDetected / testResults.length) * 100;
      mlStats.averagePoseAccuracy = totalPoseAccuracy / testResults.length;
    }

    // Get user rank
    const leaderboardEntry = await ctx.db
      .query("leaderboard")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .first();

    // Get achievements
    const userAchievements = await ctx.db
      .query("user_achievements")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    return {
      ...user,
      rank: leaderboardEntry?.rank || 0,
      mlStats,
      testResults: testResults.length,
      achievements: userAchievements.length,
    };
  },
});

// Mentor System with ML-based Matching
export const getMentorsWithMLMatching = query({
  args: { 
    userId: v.optional(v.id("users")),
    specialty: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    let mentors = await ctx.db
      .query("mentors")
      .withIndex("by_rating", (q) => q.gt("rating", 0))
      .order("desc")
      .collect();

    // Filter by specialty if provided
    if (args.specialty) {
      mentors = mentors.filter(mentor => 
        args.specialty && mentor.categories.includes(args.specialty)
      );
    }

    // If user is provided, add ML-based matching score
    if (args.userId) {
      // Get user profile with stats
      const userTestResults = await ctx.db
        .query("test_results")
        .withIndex("by_user", (q: any) => q.eq("userId", args.userId))
        .collect();
      
      mentors = mentors.map(mentor => {
        const matchingScore = calculateMentorMatchingScore(mentor, { testResults: userTestResults });
        return {
          ...mentor,
          matchingScore,
        };
      }).sort((a, b) => (b.matchingScore || 0) - (a.matchingScore || 0));
    }

    return mentors;
  },
});

// Calculate mentor matching score based on user's ML data
function calculateMentorMatchingScore(mentor: any, userProfile: any): number {
  if (!userProfile?.mlStats) return 0;

  let score = 0;
  const mlStats = userProfile.mlStats;

  // Match based on user's weak areas
  if (mlStats.averageFormScore < 70 && mentor.categories.includes("form_correction")) {
    score += 30;
  }
  
  if (mlStats.cheatDetectionRate > 20 && mentor.categories.includes("technique_specialist")) {
    score += 25;
  }
  
  if (mlStats.averagePoseAccuracy < 80 && mentor.categories.includes("posture_expert")) {
    score += 20;
  }

  // Match based on test types user has done
  const userTestTypes = Object.keys(mlStats.testsByType);
  mentor.categories.forEach((category: string) => {
    if (userTestTypes.some(testType => category.includes(testType))) {
      score += 15;
    }
  });

  // Base rating contribution
  score += mentor.rating * 2;

  return Math.min(score, 100); // Cap at 100
}

// ===============================
// MENTOR MANAGEMENT FUNCTIONS
// ===============================

// Create a new mentor
export const createMentor = mutation({
  args: {
    name: v.string(),
    subtitle: v.string(),
    specialty: v.string(),
    description: v.string(),
    rating: v.number(),
    sessionsCount: v.number(),
    price: v.string(),
    categories: v.array(v.string()),
    isOnline: v.boolean(),
    avatarUrl: v.string(),
  },
  handler: async (ctx, args) => {
    const mentorId = await ctx.db.insert("mentors", {
      ...args,
      createdAt: Date.now(),
      updatedAt: Date.now(),
    });
    return mentorId;
  },
});

// Get all mentors (simple version)
export const getMentors = query({
  args: {},
  handler: async (ctx) => {
    const mentors = await ctx.db
      .query("mentors")
      .withIndex("by_rating", (q) => q.gt("rating", 0))
      .order("desc")
      .collect();
    return mentors;
  },
});

// Get mentors by category
export const getMentorsByCategory = query({
  args: { category: v.string() },
  handler: async (ctx, args) => {
    const mentors = await ctx.db
      .query("mentors")
      .collect();
    
    // Filter mentors that have the specified category
    return mentors.filter(mentor => mentor.categories.includes(args.category));
  },
});

// Get mentor by ID
export const getMentorById = query({
  args: { mentorId: v.id("mentors") },
  handler: async (ctx, args) => {
    const mentor = await ctx.db.get(args.mentorId);
    return mentor;
  },
});

// Initialize demo mentors (run once to seed the database)
export const seedDemoMentors = mutation({
  args: {},
  handler: async (ctx) => {
    // Check if mentors already exist
    const existingMentors = await ctx.db.query("mentors").collect();
    if (existingMentors.length > 0) {
      return { message: "Demo mentors already exist", count: existingMentors.length };
    }

    const demoMentors = [
      {
        name: "Dr. Sarah Johnson",
        subtitle: "Olympic Training Specialist",
        specialty: "Elite Athletic Performance",
        description: "Former Olympic coach with 15+ years of experience in high-performance athletics. Specializes in strength training, endurance optimization, and mental conditioning for competitive athletes.",
        rating: 4.9,
        sessionsCount: 1247,
        price: "₹2,500/session",
        categories: ["strength_training", "endurance", "olympic_training", "mental_conditioning"],
        isOnline: true,
        avatarUrl: "https://images.unsplash.com/photo-1551836022-deb4988cc6c0?w=400&h=400&fit=crop&crop=face",
      },
      {
        name: "Mike Rodriguez",
        subtitle: "CrossFit & Functional Fitness Expert",
        specialty: "Functional Movement & CrossFit",
        description: "Certified CrossFit Level 4 trainer and movement specialist. Expert in functional fitness, mobility, and injury prevention. Helped 500+ athletes improve their performance.",
        rating: 4.8,
        sessionsCount: 892,
        price: "₹1,800/session",
        categories: ["crossfit", "functional_fitness", "mobility", "injury_prevention"],
        isOnline: true,
        avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      },
      {
        name: "Lisa Chen",
        subtitle: "Yoga & Mindfulness Coach",
        specialty: "Yoga, Flexibility & Mental Wellness",
        description: "Certified yoga instructor with expertise in flexibility, balance, and mindfulness. Combines traditional yoga practices with modern sports science for holistic fitness.",
        rating: 4.9,
        sessionsCount: 654,
        price: "₹1,200/session",
        categories: ["yoga", "flexibility", "balance", "mindfulness", "posture_expert"],
        isOnline: true,
        avatarUrl: "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
      },
      {
        name: "Captain Rajesh Sharma",
        subtitle: "Military Fitness & Discipline Expert",
        specialty: "Military-Style Training & Discipline",
        description: "Retired Indian Army officer with 20 years of experience in military fitness training. Specializes in discipline, endurance, and combat-ready fitness programs.",
        rating: 4.7,
        sessionsCount: 423,
        price: "₹2,000/session",
        categories: ["military_training", "discipline", "endurance", "combat_fitness"],
        isOnline: false,
        avatarUrl: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
      },
      {
        name: "Anna Kowalski",
        subtitle: "Nutrition & Weight Management Specialist",
        specialty: "Sports Nutrition & Body Composition",
        description: "Registered dietitian and sports nutritionist. Expert in meal planning, weight management, and performance nutrition for athletes of all levels.",
        rating: 4.8,
        sessionsCount: 789,
        price: "₹1,500/session",
        categories: ["nutrition", "weight_management", "meal_planning", "body_composition"],
        isOnline: true,
        avatarUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face",
      },
      {
        name: "David Thompson",
        subtitle: "Strength & Powerlifting Coach",
        specialty: "Powerlifting & Strength Development",
        description: "Former powerlifting champion and certified strength coach. Specializes in progressive overload, proper form, and building maximum strength safely.",
        rating: 4.9,
        sessionsCount: 567,
        price: "₹2,200/session",
        categories: ["powerlifting", "strength_training", "form_correction", "progressive_overload"],
        isOnline: true,
        avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop&crop=face",
      },
      {
        name: "Priya Patel",
        subtitle: "Rehabilitation & Physiotherapy Expert",
        specialty: "Injury Recovery & Physiotherapy",
        description: "Licensed physiotherapist with expertise in sports injury recovery, posture correction, and movement rehabilitation. Helps athletes return to peak performance.",
        rating: 4.8,
        sessionsCount: 1034,
        price: "₹1,800/session",
        categories: ["physiotherapy", "injury_recovery", "posture_expert", "rehabilitation"],
        isOnline: true,
        avatarUrl: "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face",
      },
      {
        name: "Carlos Martinez",
        subtitle: "Boxing & Combat Sports Coach",
        specialty: "Boxing, MMA & Combat Training",
        description: "Professional boxing coach and former MMA fighter. Expert in combat sports training, technique refinement, and mental toughness development.",
        rating: 4.7,
        sessionsCount: 345,
        price: "₹2,100/session",
        categories: ["boxing", "mma", "combat_sports", "technique_specialist"],
        isOnline: false,
        avatarUrl: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop&crop=face",
      },
      {
        name: "Emma Wilson",
        subtitle: "Running & Endurance Coach",
        specialty: "Marathon Training & Endurance Sports",
        description: "Marathon world record holder and endurance coach. Specializes in long-distance running, pacing strategies, and endurance event preparation.",
        rating: 4.9,
        sessionsCount: 678,
        price: "₹1,900/session",
        categories: ["running", "marathon", "endurance", "pacing_strategies"],
        isOnline: true,
        avatarUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop&crop=face",
      },
      {
        name: "Dr. Amit Kumar",
        subtitle: "Sports Science & Performance Analytics",
        specialty: "Data-Driven Performance Optimization",
        description: "PhD in Sports Science with expertise in performance analytics, biomechanics, and data-driven training optimization. Uses cutting-edge technology for athlete development.",
        rating: 4.8,
        sessionsCount: 234,
        price: "₹2,800/session",
        categories: ["sports_science", "performance_analytics", "biomechanics", "data_analysis"],
        isOnline: true,
        avatarUrl: "https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=400&fit=crop&crop=face",
      },
    ];

    const mentorIds = [];
    for (const mentor of demoMentors) {
      const mentorId = await ctx.db.insert("mentors", {
        ...mentor,
        createdAt: Date.now(),
        updatedAt: Date.now(),
      });
      mentorIds.push(mentorId);
    }

    return {
      message: "Demo mentors seeded successfully",
      count: mentorIds.length,
      mentorIds,
    };
  },
});

// Delete all mentors (for testing purposes)
// COMPREHENSIVE DEMO DATA SEEDING FUNCTIONS

// Clear all demo data
export const clearAllDemoData = mutation({
  handler: async (ctx) => {
    // Clear in reverse dependency order
    const mentorFavorites = await ctx.db.query("mentor_favorites").collect();
    for (const favorite of mentorFavorites) {
      await ctx.db.delete(favorite._id);
    }

    const mentorSessions = await ctx.db.query("mentor_sessions").collect();
    for (const session of mentorSessions) {
      await ctx.db.delete(session._id);
    }

    const purchases = await ctx.db.query("purchases").collect();
    for (const purchase of purchases) {
      await ctx.db.delete(purchase._id);
    }

    const bodyLogs = await ctx.db.query("body_logs").collect();
    for (const log of bodyLogs) {
      await ctx.db.delete(log._id);
    }

    const achievements = await ctx.db.query("user_achievements").collect();
    for (const achievement of achievements) {
      await ctx.db.delete(achievement._id);
    }

    const groupMembers = await ctx.db.query("group_members").collect();
    for (const member of groupMembers) {
      await ctx.db.delete(member._id);
    }

    const communityPosts = await ctx.db.query("community_posts").collect();
    for (const post of communityPosts) {
      await ctx.db.delete(post._id);
    }

    const testResults = await ctx.db.query("test_results").collect();
    for (const result of testResults) {
      await ctx.db.delete(result._id);
    }

    const leaderboard = await ctx.db.query("leaderboard").collect();
    for (const entry of leaderboard) {
      await ctx.db.delete(entry._id);
    }

    const users = await ctx.db.query("users").collect();
    for (const user of users) {
      await ctx.db.delete(user._id);
    }

    const mentors = await ctx.db.query("mentors").collect();
    for (const mentor of mentors) {
      await ctx.db.delete(mentor._id);
    }

    const groups = await ctx.db.query("community_groups").collect();
    for (const group of groups) {
      await ctx.db.delete(group._id);
    }

    const challenges = await ctx.db.query("challenges").collect();
    for (const challenge of challenges) {
      await ctx.db.delete(challenge._id);
    }

    const products = await ctx.db.query("products").collect();
    for (const product of products) {
      await ctx.db.delete(product._id);
    }

    return { success: true, message: "All demo data cleared successfully" };
  },
});

// Seed comprehensive demo data
export const seedComprehensiveDemoData = mutation({
  handler: async (ctx) => {
    const now = Date.now();

    // 1. Create 4 Demo Users
    const demoUsers = [
      {
        email: "arjun.singh@example.com",
        name: "Arjun Singh",
        credits: 250,
        totalScore: 8750,
        bio: "Passionate athlete focused on strength training and marathon running",
        level: "Advanced"
      },
      {
        email: "priya.sharma@example.com", 
        name: "Priya Sharma",
        credits: 180,
        totalScore: 7450,
        bio: "Yoga enthusiast and fitness coach specializing in flexibility",
        level: "Intermediate"
      },
      {
        email: "rohit.kumar@example.com",
        name: "Rohit Kumar", 
        credits: 320,
        totalScore: 9200,
        bio: "CrossFit athlete and nutrition expert",
        level: "Expert"
      },
      {
        email: "ananya.patel@example.com",
        name: "Ananya Patel",
        credits: 150,
        totalScore: 6800,
        bio: "Beginner enthusiast learning proper form and building strength",
        level: "Beginner"
      }
    ];

    const createdUsers = [];
    for (const userData of demoUsers) {
      const userId = await ctx.db.insert("users", {
        ...userData,
        updatedAt: now,
        createdAt: now - Math.random() * 30 * 24 * 60 * 60 * 1000, // Random date within last 30 days
      });
      createdUsers.push({ id: userId, ...userData });
    }

    // 2. Create Test Results for each user (multiple tests over time)
    const testTypes = ["pushups", "squats", "pullups", "planks", "burpees", "situps"];
    const testResults = [];

    for (const user of createdUsers) {
      // Generate 15-25 test results per user over the last 60 days
      const numTests = 15 + Math.floor(Math.random() * 10);
      
      for (let i = 0; i < numTests; i++) {
        const testType = testTypes[Math.floor(Math.random() * testTypes.length)];
        const daysAgo = Math.floor(Math.random() * 60);
        const completedAt = now - (daysAgo * 24 * 60 * 60 * 1000);
        
        // Generate realistic scores based on user level
        let baseScore = 50;
        if (user.level === "Beginner") baseScore = 30 + Math.random() * 40;
        else if (user.level === "Intermediate") baseScore = 50 + Math.random() * 35;
        else if (user.level === "Advanced") baseScore = 70 + Math.random() * 25;
        else if (user.level === "Expert") baseScore = 80 + Math.random() * 20;

        const score = Math.min(100, Math.max(0, baseScore + (Math.random() - 0.5) * 20));
        
        const resultId = await ctx.db.insert("test_results", {
          userId: user.id,
          testId: testType,
          score: Math.round(score),
          status: 'completed',
          mlAnalysis: {
            cheatDetected: Math.random() < 0.1, // 10% chance of cheat detection
            poseAccuracy: 75 + Math.random() * 20,
            repetitions: Math.floor(15 + Math.random() * 25),
            formScore: 70 + Math.random() * 25,
            violations: Math.random() < 0.2 ? ["improper_form"] : [],
            keyPoints: {},
            confidenceScore: 85 + Math.random() * 10,
            recommendations: [
              "Focus on maintaining proper form throughout the exercise",
              "Keep your core engaged for better stability",
              "Control the tempo - slower is often better"
            ]
          },
          completedAt,
          metadata: {
            cheatDetected: Math.random() < 0.1,
            poseAccuracy: 75 + Math.random() * 20,
            repetitions: Math.floor(15 + Math.random() * 25),
            formScore: 70 + Math.random() * 25,
          }
        });
        testResults.push(resultId);
      }
    }

    // 3. Create Leaderboard entries
    const sortedUsers = [...createdUsers].sort((a, b) => b.totalScore - a.totalScore);
    for (let i = 0; i < sortedUsers.length; i++) {
      await ctx.db.insert("leaderboard", {
        userId: sortedUsers[i].id,
        totalScore: sortedUsers[i].totalScore,
        rank: i + 1,
      });
    }

    // 4. Create Community Groups
    const communityGroups = [
      {
        name: "Mumbai Runners Club",
        description: "Connect with fellow runners in Mumbai for group runs and marathons",
        category: "Running",
        memberCount: 245,
        isPublic: true
      },
      {
        name: "Yoga Masters",
        description: "Advanced yoga practitioners sharing techniques and poses",
        category: "Yoga", 
        memberCount: 156,
        isPublic: true
      },
      {
        name: "CrossFit Warriors",
        description: "High-intensity functional fitness community",
        category: "CrossFit",
        memberCount: 89,
        isPublic: true
      },
      {
        name: "Beginner's Fitness Journey",
        description: "Supportive community for fitness beginners",
        category: "General",
        memberCount: 312,
        isPublic: true
      }
    ];

    const createdGroups = [];
    for (const groupData of communityGroups) {
      const groupId = await ctx.db.insert("community_groups", {
        ...groupData,
        createdAt: now - Math.random() * 90 * 24 * 60 * 60 * 1000,
      });
      createdGroups.push({ id: groupId, ...groupData });
    }

    // 5. Add users to groups
    for (const user of createdUsers) {
      // Each user joins 1-3 random groups
      const numGroups = 1 + Math.floor(Math.random() * 3);
      const shuffledGroups = [...createdGroups].sort(() => Math.random() - 0.5);
      
      for (let i = 0; i < numGroups; i++) {
        await ctx.db.insert("group_members", {
          userId: user.id,
          groupId: shuffledGroups[i].id,
          joinedAt: now - Math.random() * 60 * 24 * 60 * 60 * 1000,
        });
      }
    }

    // 6. Create Community Posts
    const postTemplates = [
      { content: "Just completed my first 5K run! Feeling amazing 💪", type: "achievement" },
      { content: "Looking for a workout buddy in South Delhi area", type: "question" },
      { content: "Here's my post-workout smoothie recipe that keeps me energized", type: "tip" },
      { content: "Broke my personal record on squats today - 50 reps!", type: "achievement" },
      { content: "What's your favorite pre-workout meal?", type: "question" },
      { content: "Remember: consistency beats perfection every time! 🎯", type: "motivation" },
      { content: "Form check please! How's my deadlift technique?", type: "question" },
      { content: "30-day plank challenge complete! Who's joining next month?", type: "challenge" }
    ];

    for (const user of createdUsers) {
      // Each user creates 3-8 posts
      const numPosts = 3 + Math.floor(Math.random() * 6);
      
      for (let i = 0; i < numPosts; i++) {
        const template = postTemplates[Math.floor(Math.random() * postTemplates.length)];
        await ctx.db.insert("community_posts", {
          userId: user.id,
          content: template.content,
          type: template.type,
          imageUrl: Math.random() < 0.3 ? `https://picsum.photos/400/300?random=${Math.random()}` : undefined,
          likes: Math.floor(Math.random() * 50),
          comments: Math.floor(Math.random() * 15),
          createdAt: now - Math.random() * 30 * 24 * 60 * 60 * 1000,
        });
      }
    }

    // 7. Create Active Challenges
    const challenges = [
      {
        title: "30-Day Push-up Challenge",
        description: "Complete 1000 push-ups in 30 days and win exclusive rewards!",
        reward: 500,
        startDate: now - 10 * 24 * 60 * 60 * 1000,
        endDate: now + 20 * 24 * 60 * 60 * 1000,
        isActive: true,
        participants: 128
      },
      {
        title: "Marathon Training Month",
        description: "Run a total of 100km this month to prepare for marathon season",
        reward: 750,
        startDate: now - 5 * 24 * 60 * 60 * 1000,
        endDate: now + 25 * 24 * 60 * 60 * 1000,
        isActive: true,
        participants: 67
      },
      {
        title: "Perfect Form Week",
        description: "Focus on form over quantity - quality workouts only!",
        reward: 300,
        startDate: now + 2 * 24 * 60 * 60 * 1000,
        endDate: now + 9 * 24 * 60 * 60 * 1000,
        isActive: true,
        participants: 89
      }
    ];

    for (const challengeData of challenges) {
      await ctx.db.insert("challenges", {
        ...challengeData,
        createdAt: challengeData.startDate - 24 * 60 * 60 * 1000,
      });
    }

    // 8. Create User Achievements
    const achievementTypes = [
      "first_workout", "week_streak", "month_streak", "perfect_form", 
      "high_score", "challenge_complete", "community_contributor", "mentor_session"
    ];

    for (const user of createdUsers) {
      // Each user has 3-6 achievements
      const numAchievements = 3 + Math.floor(Math.random() * 4);
      const shuffledAchievements = [...achievementTypes].sort(() => Math.random() - 0.5);
      
      for (let i = 0; i < numAchievements; i++) {
        await ctx.db.insert("user_achievements", {
          userId: user.id,
          achievementId: shuffledAchievements[i],
          unlockedAt: now - Math.random() * 45 * 24 * 60 * 60 * 1000,
        });
      }
    }

    // 9. Create Body Logs for users
    for (const user of createdUsers) {
      // Create 10-20 body log entries over the last 90 days
      const numLogs = 10 + Math.floor(Math.random() * 11);
      
      for (let i = 0; i < numLogs; i++) {
        const daysAgo = Math.floor(Math.random() * 90);
        const logDate = now - (daysAgo * 24 * 60 * 60 * 1000);
        
        // Generate realistic body metrics
        const baseWeight = 60 + Math.random() * 30; // 60-90 kg
        const baseHeight = 155 + Math.random() * 25; // 155-180 cm
        
        await ctx.db.insert("body_logs", {
          userId: user.id,
          date: logDate,
          weight: baseWeight + (Math.random() - 0.5) * 5, // ±2.5kg variation
          height: baseHeight,
          bodyFat: 10 + Math.random() * 20, // 10-30%
          muscleMass: 30 + Math.random() * 20, // 30-50%
          notes: Math.random() < 0.3 ? "Feeling great after today's workout!" : undefined,
          createdAt: logDate,
          updatedAt: logDate,
        });
      }
    }

    // 10. Create Products in Store
    const products = [
      {
        name: "Premium Protein Powder",
        description: "High-quality whey protein for muscle recovery and growth",
        price: 2999,
        category: "Supplements",
        imageUrl: "https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=400&h=400&fit=crop",
        isActive: true
      },
      {
        name: "Resistance Band Set",
        description: "Complete set of resistance bands for strength training",
        price: 1499,
        category: "Equipment",
        imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
        isActive: true
      },
      {
        name: "Sports Nutrition Plan",
        description: "Personalized nutrition plan created by certified dietitians",
        price: 4999,
        category: "Plans",
        imageUrl: "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400&h=400&fit=crop",
        isActive: true
      },
      {
        name: "Fitness Tracker Watch",
        description: "Advanced fitness tracking with heart rate monitoring",
        price: 8999,
        category: "Equipment",
        imageUrl: "https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=400&h=400&fit=crop",
        isActive: true
      },
      {
        name: "Yoga Mat Premium",
        description: "High-grip, eco-friendly yoga mat for all practices",
        price: 2499,
        category: "Equipment", 
        imageUrl: "https://images.unsplash.com/photo-1506629905542-b5bd7c7fe59d?w=400&h=400&fit=crop",
        isActive: true
      }
    ];

    const createdProducts = [];
    for (const productData of products) {
      const productId = await ctx.db.insert("products", {
        ...productData,
        createdAt: now - Math.random() * 60 * 24 * 60 * 60 * 1000,
      });
      createdProducts.push({ id: productId, ...productData });
    }

    // 11. Create Purchase History
    for (const user of createdUsers) {
      // Each user has 1-4 purchases
      const numPurchases = 1 + Math.floor(Math.random() * 4);
      const shuffledProducts = [...createdProducts].sort(() => Math.random() - 0.5);
      
      for (let i = 0; i < numPurchases; i++) {
        const product = shuffledProducts[i];
        const quantity = 1 + Math.floor(Math.random() * 3);
        
        await ctx.db.insert("purchases", {
          userId: user.id,
          productId: product.id,
          quantity,
          totalCost: product.price * quantity,
          status: Math.random() < 0.9 ? "completed" : "pending",
          createdAt: now - Math.random() * 60 * 24 * 60 * 60 * 1000,
        });
      }
    }

    // 12. Create Mentor Sessions for demo users  
    const existingMentors = await ctx.db.query("mentors").collect();

    // If no mentors exist, seed some basic ones first
    if (existingMentors.length === 0) {
      const demoMentorData = [
        {
          name: "Dr. Sarah Johnson",
          subtitle: "Olympic Training Specialist", 
          specialty: "High-performance athletic training and olympic preparation",
          rating: 4.9,
          sessionsCount: 156,
          price: "750",
          categories: ["Olympic Training", "Performance"],
          isOnline: true,
          avatarUrl: "https://images.unsplash.com/photo-1494790108755-2616b612b550?w=400&h=400&fit=crop&crop=face",
        },
        {
          name: "Mike Rodriguez", 
          subtitle: "CrossFit Expert",
          specialty: "Functional fitness and strength conditioning specialist",
          rating: 4.8,
          sessionsCount: 203,
          price: "600", 
          categories: ["CrossFit", "Strength Training"],
          isOnline: true,
          avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
        },
        {
          name: "Lisa Chen",
          subtitle: "Yoga & Flexibility Coach",
          specialty: "Yoga instruction and flexibility enhancement programs", 
          rating: 4.9,
          sessionsCount: 189,
          price: "450",
          categories: ["Yoga", "Flexibility", "Mindfulness"],
          isOnline: true,
          avatarUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face",
        }
      ];

      for (const mentorData of demoMentorData) {
        await ctx.db.insert("mentors", {
          ...mentorData,
          description: `Professional ${mentorData.specialty.toLowerCase()} with ${mentorData.sessionsCount} completed sessions.`,
          createdAt: now - Math.random() * 90 * 24 * 60 * 60 * 1000,
          updatedAt: now,
        });
      }
    }

    // Get all mentors after seeding
    const allMentors = await ctx.db.query("mentors").collect();

    // Create mentor sessions for each user
    for (const user of createdUsers) {
      // Each user has 2-5 mentor sessions (mix of upcoming and completed)
      const numSessions = 2 + Math.floor(Math.random() * 4);
      
      for (let i = 0; i < numSessions; i++) {
        const mentor = allMentors[Math.floor(Math.random() * allMentors.length)];
        const isCompleted = Math.random() < 0.4; // 40% chance of being completed
        
        const topics = [
          "Technique Analysis and Improvement",
          "Performance Goal Setting", 
          "Injury Prevention Strategies",
          "Nutrition and Training Plan",
          "Mental Strength and Focus",
          "Competition Preparation"
        ];
        
        const topic = topics[Math.floor(Math.random() * topics.length)];
        const sessionType = Math.random() < 0.7 ? "video_call" : "chat_session";
        
        let scheduledAt: number;
        let completedAt: number | undefined;
        let status: string;
        let rating: number | undefined;
        
        if (isCompleted) {
          // Completed session in the past
          scheduledAt = now - Math.random() * 30 * 24 * 60 * 60 * 1000;
          completedAt = scheduledAt + (30 + Math.random() * 60) * 60 * 1000; // 30-90 mins later
          status = "completed";
          rating = 3.5 + Math.random() * 1.5; // 3.5-5.0 rating
        } else {
          // Upcoming session
          scheduledAt = now + Math.random() * 14 * 24 * 60 * 60 * 1000; // Next 14 days
          status = "upcoming";
        }

        await ctx.db.insert("mentor_sessions", {
          mentorId: mentor._id,
          userId: user.id,
          topic,
          scheduledAt,
          status,
          type: sessionType,
          rating,
          review: rating ? `Great session! Very helpful guidance on ${topic.toLowerCase()}.` : undefined,
          completedAt,
          createdAt: now - Math.random() * 60 * 24 * 60 * 60 * 1000,
          updatedAt: now,
        });
      }
    }

    // 13. Create mentor favorites for some users
    for (const user of createdUsers) {
      // Each user favorites 1-3 mentors
      const numFavorites = 1 + Math.floor(Math.random() * 3);
      const shuffledMentors = [...allMentors].sort(() => Math.random() - 0.5);
      
      for (let i = 0; i < numFavorites; i++) {
        await ctx.db.insert("mentor_favorites", {
          userId: user.id,
          mentorId: shuffledMentors[i]._id,
          createdAt: now - Math.random() * 30 * 24 * 60 * 60 * 1000,
        });
      }
    }

    return {
      success: true,
      message: "Comprehensive demo data created successfully!",
      data: {
        users: createdUsers.length,
        testResults: testResults.length,
        groups: createdGroups.length,
        products: createdProducts.length,
        challenges: challenges.length,
        mentors: allMentors.length,
        mentorSessions: "2-5 per user",
        mentorFavorites: "1-3 per user"
      }
    };
  },
});

// Quick seed function for development
export const quickSeedDemo = mutation({
  handler: async (ctx) => {
    const now = Date.now();

    // Clear existing users and related data first
    const users = await ctx.db.query("users").collect();
    for (const user of users) {
      await ctx.db.delete(user._id);
    }

    // Clear leaderboard
    const leaderboard = await ctx.db.query("leaderboard").collect();
    for (const entry of leaderboard) {
      await ctx.db.delete(entry._id);
    }

    // Clear test results
    const testResults = await ctx.db.query("test_results").collect();
    for (const result of testResults) {
      await ctx.db.delete(result._id);
    }

    // Now create demo data
    const demoUsers = [
      {
        email: "arjun.singh@example.com",
        name: "Arjun Singh",
        credits: 250,
        totalScore: 8750,
      },
      {
        email: "priya.sharma@example.com", 
        name: "Priya Sharma",
        credits: 180,
        totalScore: 7450,
      },
      {
        email: "rohit.kumar@example.com",
        name: "Rohit Kumar", 
        credits: 320,
        totalScore: 9200,
      },
      {
        email: "ananya.patel@example.com",
        name: "Ananya Patel",
        credits: 150,
        totalScore: 6800,
      }
    ];

    const createdUsers = [];
    for (const userData of demoUsers) {
      const userId = await ctx.db.insert("users", {
        ...userData,
        updatedAt: now,
        createdAt: now - Math.random() * 30 * 24 * 60 * 60 * 1000,
      });
      createdUsers.push({ id: userId, ...userData });
    }

    // Create leaderboard
    const sortedUsers = [...createdUsers].sort((a, b) => b.totalScore - a.totalScore);
    for (let i = 0; i < sortedUsers.length; i++) {
      await ctx.db.insert("leaderboard", {
        userId: sortedUsers[i].id,
        totalScore: sortedUsers[i].totalScore,
        rank: i + 1,
      });
    }

    // Create test results
    const testTypes = ["pushups", "squats", "pullups", "planks", "burpees"];
    for (const user of createdUsers) {
      for (let i = 0; i < 10; i++) {
        const testType = testTypes[Math.floor(Math.random() * testTypes.length)];
        const score = 50 + Math.random() * 45;
        
        await ctx.db.insert("test_results", {
          userId: user.id,
          testId: testType,
          score: Math.round(score),
          status: 'completed',
          mlAnalysis: {
            cheatDetected: false,
            poseAccuracy: 80 + Math.random() * 15,
            repetitions: Math.floor(15 + Math.random() * 20),
            formScore: 75 + Math.random() * 20,
            violations: [],
            keyPoints: {},
            confidenceScore: 85 + Math.random() * 10,
            recommendations: ["Great form!", "Keep it up!"]
          },
          completedAt: now - Math.random() * 30 * 24 * 60 * 60 * 1000,
        });
      }
    }

    return {
      success: true,
      message: "Quick demo data created successfully!",
      users: createdUsers.length
    };
  },
});

export const clearAllMentors = mutation({
  args: {},
  handler: async (ctx) => {
    const mentors = await ctx.db.query("mentors").collect();
    for (const mentor of mentors) {
      await ctx.db.delete(mentor._id);
    }
    return { message: "All mentors cleared", count: mentors.length };
  },
});

// Real-time Analytics for Dashboard
export const getRealtimeAnalytics = query({
  args: {},
  handler: async (ctx) => {
    const now = Date.now();
    const oneDayAgo = now - (24 * 60 * 60 * 1000);
    const oneWeekAgo = now - (7 * 24 * 60 * 60 * 1000);

    // Recent test submissions
    const recentTests = await ctx.db
      .query("test_results")
      .withIndex("by_completedAt", (q) => q.gt("completedAt", oneDayAgo))
      .collect();

    // Active users (users who completed tests in last week)
    const weeklyActiveUsers = await ctx.db
      .query("test_results")
      .withIndex("by_completedAt", (q) => q.gt("completedAt", oneWeekAgo))
      .collect();

    const uniqueActiveUsers = new Set(weeklyActiveUsers.map(result => result.userId)).size;

    // Community activity
    const recentPosts = await ctx.db
      .query("community_posts")
      .withIndex("by_createdAt", (q) => q.gt("createdAt", oneDayAgo))
      .collect();

    // ML analysis stats
    const mlStats = {
      averageFormScore: 0,
      cheatDetectionRate: 0,
      mostCommonViolations: [] as string[],
    };

    if (recentTests.length > 0) {
      let totalFormScore = 0;
      let cheatsDetected = 0;
      const violations: string[] = [];

      recentTests.forEach(test => {
        if (test.mlAnalysis) {
          totalFormScore += test.mlAnalysis.formScore || 0;
          if (test.mlAnalysis.cheatDetected) cheatsDetected++;
          violations.push(...(test.mlAnalysis.violations || []));
        }
      });

      mlStats.averageFormScore = totalFormScore / recentTests.length;
      mlStats.cheatDetectionRate = (cheatsDetected / recentTests.length) * 100;
      
      // Count most common violations
      const violationCounts = violations.reduce((acc, violation) => {
        acc[violation] = (acc[violation] || 0) + 1;
        return acc;
      }, {} as Record<string, number>);
      
      mlStats.mostCommonViolations = Object.entries(violationCounts)
        .sort(([,a], [,b]) => b - a)
        .slice(0, 5)
        .map(([violation]) => violation);
    }

    return {
      testsToday: recentTests.length,
      activeUsersWeekly: uniqueActiveUsers,
      communityPostsToday: recentPosts.length,
      mlStats,
      timestamp: now,
    };
  },
});

export const getProducts = query({
  args: { category: v.optional(v.string()) },
  handler: async (ctx, args) => {
    let productsQuery = ctx.db.query("products");
    if (args.category) {
      productsQuery = productsQuery.filter((q: any) => q.eq(q.field("category"), args.category));
    }
    return await productsQuery
      .filter((q: any) => q.eq(q.field("isActive"), true))
      .collect();
  },
});

export const getProductById = query({
  args: { productId: v.id("products") },
  handler: async (ctx, args) => {
    return await ctx.db.get(args.productId);
  },
});

export const purchaseProduct = mutation({
  args: {
    userId: v.id("users"),
    productId: v.id("products"),
    quantity: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const product = await ctx.db.get(args.productId);
    const user = await ctx.db.get(args.userId);

    if (!product || !user) {
      throw new Error("Product or user not found");
    }

    const quantity = args.quantity || 1;
    const totalCost = product.price * quantity;

    if (user.credits < totalCost) {
      throw new Error("Insufficient credits");
    }

    // Deduct credits
    await ctx.db.patch(args.userId, {
      credits: user.credits - totalCost,
      updatedAt: Date.now(),
    });

    // Record purchase
    const purchaseId = await ctx.db.insert("purchases", {
      userId: args.userId,
      productId: args.productId,
      quantity: quantity,
      totalCost: totalCost,
      status: "completed",
      createdAt: Date.now(),
    });

    return purchaseId;
  },
});

// Enhanced Profile Functions
export const updateUserProfile = mutation({
  args: {
    userId: v.id("users"),
    name: v.optional(v.string()),
    bio: v.optional(v.string()),
    avatarUrl: v.optional(v.string()),
    preferences: v.optional(v.any()),
  },
  handler: async (ctx, args) => {
    const updates: any = { updatedAt: Date.now() };

    if (args.name !== undefined) updates.name = args.name;
    if (args.bio !== undefined) updates.bio = args.bio;
    if (args.avatarUrl !== undefined) updates.avatarUrl = args.avatarUrl;
    if (args.preferences !== undefined) updates.preferences = args.preferences;

    await ctx.db.patch(args.userId, updates);
    return args.userId;
  },
});

export const getUserDetailedProfile = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const user = await ctx.db.get(args.userId);
    if (!user) return null;

    const testResults = await ctx.db
      .query("test_results")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    const achievements = await ctx.db
      .query("user_achievements")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    const bodyLogs = await ctx.db
      .query("body_logs")
      .withIndex("by_user", (q: any) => q.eq("userId", args.userId))
      .order("desc")
      .take(1);

    const latestBodyLog = bodyLogs.length > 0 ? bodyLogs[0] : null;

    return {
      ...user,
      stats: {
        totalTests: testResults.length,
        completedTests: testResults.filter(r => r.score >= 70).length,
        averageScore: testResults.length > 0
          ? testResults.reduce((sum, r) => sum + r.score, 0) / testResults.length
          : 0,
        achievements: achievements.length,
        level: Math.floor(testResults.length / 10) + 1, // Simple leveling
      },
      latestBodyLog,
    };
  },
});
