// convex/seed_data.ts
import { mutation } from "./_generated/server";
import { v } from "convex/values";

export const seedAllData = mutation({
  args: {},
  handler: async (ctx) => {
    // Check if data already exists
    const existingUsers = await ctx.db.query("users").collect();
    if (existingUsers.length > 0) {
      return { message: "Data already exists" };
    }

    // Create comprehensive user data
    const user1 = await ctx.db.insert("users", {
      name: "Alex Johnson",
      email: "alex.johnson@example.com",
      credits: 1500,
      totalScore: 3850,
      createdAt: Date.now() - 2592000000, // 30 days ago
      updatedAt: Date.now(),
    });

    const user2 = await ctx.db.insert("users", {
      name: "Sarah Martinez",
      email: "sarah.martinez@example.com", 
      credits: 1800,
      totalScore: 3720,
      createdAt: Date.now() - 2419200000, // 28 days ago
      updatedAt: Date.now(),
    });

    const user3 = await ctx.db.insert("users", {
      name: "Mike Chen",
      email: "mike.chen@example.com",
      credits: 1200,
      totalScore: 3680,
      createdAt: Date.now() - 2246400000, // 26 days ago
      updatedAt: Date.now(),
    });

    const user4 = await ctx.db.insert("users", {
      name: "Emma Wilson",
      email: "emma.wilson@example.com",
      credits: 1350,
      totalScore: 3590,
      createdAt: Date.now() - 2073600000, // 24 days ago
      updatedAt: Date.now(),
    });

    const user5 = await ctx.db.insert("users", {
      name: "David Rodriguez",
      email: "david.rodriguez@example.com",
      credits: 1650,
      totalScore: 3450,
      createdAt: Date.now() - 1900800000, // 22 days ago
      updatedAt: Date.now(),
    });

    const user6 = await ctx.db.insert("users", {
      name: "Jessica Kim",
      email: "jessica.kim@example.com",
      credits: 1400,
      totalScore: 3380,
      createdAt: Date.now() - 1728000000, // 20 days ago
      updatedAt: Date.now(),
    });

    const user7 = await ctx.db.insert("users", {
      name: "Ryan Thompson",
      email: "ryan.thompson@example.com",
      credits: 1100,
      totalScore: 3250,
      createdAt: Date.now() - 1555200000, // 18 days ago
      updatedAt: Date.now(),
    });

    const user8 = await ctx.db.insert("users", {
      name: "Maria Garcia",
      email: "maria.garcia@example.com",
      credits: 1750,
      totalScore: 3180,
      createdAt: Date.now() - 1382400000, // 16 days ago
      updatedAt: Date.now(),
    });

    const users = [user1, user2, user3, user4, user5, user6, user7, user8];

    // Create comprehensive test results for all users and exercises
    const exercises = [
      'push_ups', 'squats', 'sit_ups', 'jumping_jacks', 'plank', 
      'burpees', 'lunges', 'mountain_climbers'
    ];

    const testResults = [];
    let testCounter = 1;

    // Generate test results for each user across different exercises
    for (let userIndex = 0; userIndex < users.length; userIndex++) {
      const userId = users[userIndex];
      const baseScore = 800 + (userIndex * 50); // Varying base scores
      
      for (let exerciseIndex = 0; exerciseIndex < exercises.length; exerciseIndex++) {
        const exercise = exercises[exerciseIndex];
        const scoreVariation = Math.random() * 200 - 100; // ±100 points variation
        const finalScore = Math.max(500, baseScore + scoreVariation);
        
        // Different repetition counts based on exercise type
        let reps;
        switch (exercise) {
          case 'push_ups': reps = 15 + Math.floor(Math.random() * 25); break;
          case 'squats': reps = 20 + Math.floor(Math.random() * 30); break;
          case 'sit_ups': reps = 25 + Math.floor(Math.random() * 35); break;
          case 'jumping_jacks': reps = 40 + Math.floor(Math.random() * 50); break;
          case 'plank': reps = 1; break; // Plank is isometric
          case 'burpees': reps = 8 + Math.floor(Math.random() * 15); break;
          case 'lunges': reps = 16 + Math.floor(Math.random() * 24); break;
          case 'mountain_climbers': reps = 50 + Math.floor(Math.random() * 60); break;
          default: reps = 10 + Math.floor(Math.random() * 20);
        }

        const poseAccuracy = 75 + Math.random() * 25; // 75-100%
        const formScore = 70 + Math.random() * 30; // 70-100%
        const confidenceScore = 80 + Math.random() * 20; // 80-100%

        testResults.push({
          userId: userId,
          testId: `${exercise}_test_${testCounter++}`,
          score: Math.round(finalScore),
          completedAt: Date.now() - (Math.random() * 1209600000), // Random within last 14 days
          mlAnalysis: {
            cheatDetected: Math.random() < 0.1, // 10% chance of cheat detection
            poseAccuracy: Math.round(poseAccuracy * 10) / 10,
            repetitions: reps,
            formScore: Math.round(formScore * 10) / 10,
            violations: Math.random() < 0.2 ? ['Poor form detected'] : [],
            keyPoints: { exercise_type: exercise },
            confidenceScore: Math.round(confidenceScore * 10) / 10,
            recommendations: _getRecommendations(exercise, formScore, poseAccuracy)
          }
        });
      }
    }

    // Insert all test results
    for (const result of testResults) {
      await ctx.db.insert("test_results", { ...result, status: 'completed' });
    }

    // Create leaderboard entries for all users
    const leaderboardEntries = users.map((userId, index) => ({
      userId: userId,
      totalScore: 3850 - (index * 70), // Decreasing scores
      rank: index + 1,
    }));

    for (const entry of leaderboardEntries) {
      await ctx.db.insert("leaderboard", entry);
    }

    return { 
      message: "Comprehensive synthetic data seeded successfully",
      usersCreated: users.length,
      testResultsCreated: testResults.length,
      leaderboardEntriesCreated: leaderboardEntries.length,
      exercisesCovered: exercises.length
    };
  },
});

function _getRecommendations(exercise: string, formScore: number, poseAccuracy: number): string[] {
  const recommendations = [];
  
  if (formScore < 80) {
    recommendations.push("Focus on maintaining proper form throughout the exercise");
  }
  
  if (poseAccuracy < 85) {
    recommendations.push("Ensure you're positioned correctly in front of the camera");
  }
  
  switch (exercise) {
    case 'push_ups':
      recommendations.push("Keep your body in a straight line", "Control the movement speed");
      break;
    case 'squats':
      recommendations.push("Keep your knees aligned with your toes", "Go deeper for better results");
      break;
    case 'sit_ups':
      recommendations.push("Engage your core muscles", "Avoid pulling on your neck");
      break;
    case 'plank':
      recommendations.push("Keep your core tight", "Maintain straight body alignment");
      break;
    case 'burpees':
      recommendations.push("Land softly", "Maintain steady breathing");
      break;
    case 'lunges':
      recommendations.push("Keep your front knee over your ankle", "Step out wider for stability");
      break;
    case 'jumping_jacks':
      recommendations.push("Land on the balls of your feet", "Keep your arms extended");
      break;
    case 'mountain_climbers':
      recommendations.push("Keep your hips level", "Maintain plank position");
      break;
  }
  
  return recommendations.slice(0, 3); // Limit to 3 recommendations
}

export const clearAllData = mutation({
  args: {},
  handler: async (ctx) => {
    // Clear all tables
    const users = await ctx.db.query("users").collect();
    const testResults = await ctx.db.query("test_results").collect(); 
    const leaderboard = await ctx.db.query("leaderboard").collect();

    for (const user of users) {
      await ctx.db.delete(user._id);
    }
    
    for (const result of testResults) {
      await ctx.db.delete(result._id);
    }
    
    for (const entry of leaderboard) {
      await ctx.db.delete(entry._id);
    }

    return { message: "All data cleared successfully" };
  },
});

export const seedLeaderboardData = mutation({
  args: {},
  handler: async (ctx) => {
    // Just call the main seeding function directly
    const existingUsers = await ctx.db.query("users").collect();
    if (existingUsers.length > 0) {
      return { message: "Data already exists" };
    }
    
    // This will be handled by the seedAllData function
    return { message: "Use seedAllData instead" };
  },
});