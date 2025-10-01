import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

export const getUsers = query({
  args: {},
  handler: async (ctx) => {
    const users = await ctx.db
      .query("users")
      .collect();
    return { users };
  },
});

export const getUser = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const user = await ctx.db.get(args.userId);
    if (!user) {
      throw new Error("User not found");
    }
    return user;
  },
});

export const getLeaderboard = query({
  args: {},
  handler: async (ctx) => {
    const leaderboard = await ctx.db
      .query("leaderboard")
      .collect();
    return leaderboard;
  },
});

export const saveTestResult = mutation({
  args: {
    userId: v.id("users"),
    testId: v.string(),
    score: v.number(),
  },
  handler: async (ctx, args) => {
    // Save result
    const resultId = await ctx.db.insert("test_results", {
      userId: args.userId,
      testId: args.testId,
      score: args.score,
      completedAt: Date.now(),
    });

    // Update user total score (simplified - in real app, calculate properly)
    const user = await ctx.db.get(args.userId);
    if (user) {
      const newTotalScore = (user.totalScore || 0) + args.score;
      await ctx.db.patch(args.userId, { totalScore: newTotalScore });
      
      // Update leaderboard entry
      const existingLeaderboard = await ctx.db
        .query("leaderboard")
        .withIndex("by_user", (q) => q.eq("userId", args.userId))
        .first();
      
      if (existingLeaderboard) {
        await ctx.db.patch(existingLeaderboard._id, { totalScore: newTotalScore });
      } else {
        await ctx.db.insert("leaderboard", {
          userId: args.userId,
          totalScore: newTotalScore,
          rank: 0, // Calculate rank separately if needed
        });
      }
    }

    return resultId;
  },
});

export const getUserTestResults = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const results = await ctx.db
      .query("test_results")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc")
      .collect();
    return results;
  },
});

export const updateUserCredits = mutation({
  args: {
    userId: v.id("users"),
    amount: v.number(),
    type: v.string(),
  },
  handler: async (ctx, args) => {
    const user = await ctx.db.get(args.userId);
    if (user) {
      const newCredits = user.credits + args.amount;
      await ctx.db.patch(args.userId, { 
        credits: newCredits,
        updatedAt: Date.now()
      });
      return newCredits;
    }
    throw new Error("User not found");
  },
});

export const getUserProfile = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    return await ctx.db.get(args.userId);
  },
});

export const createUser = mutation({
  args: {
    email: v.string(),
    name: v.string(),
  },
  handler: async (ctx, args) => {
    const userId = await ctx.db.insert("users", {
      email: args.email,
      name: args.name,
      credits: 100, // Starting credits
      createdAt: Date.now(),
      updatedAt: Date.now(),
      totalScore: 0,
    });

    // Create initial leaderboard entry
    await ctx.db.insert("leaderboard", {
      userId: userId,
      totalScore: 0,
      rank: 0,
    });

    return userId;
  },
});

// Mentor Functions
export const getMentors = query({
  args: { category: v.optional(v.string()) },
  handler: async (ctx, args) => {
    let mentors = await ctx.db.query("mentors").collect();
    if (args.category) {
      mentors = mentors.filter(mentor => 
        mentor.categories.includes(args.category!)
      );
    }
    return mentors;
  },
});

export const getMentorById = query({
  args: { mentorId: v.id("mentors") },
  handler: async (ctx, args) => {
    return await ctx.db.get(args.mentorId);
  },
});

export const getUserMentorSessions = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const sessions = await ctx.db
      .query("mentor_sessions")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc")
      .collect();

    // Enrich with mentor data
    const enrichedSessions = await Promise.all(
      sessions.map(async (session) => {
        const mentor = await ctx.db.get(session.mentorId);
        return { ...session, mentor };
      })
    );

    return enrichedSessions;
  },
});

export const getUserFavoriteMentors = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const favorites = await ctx.db
      .query("mentor_favorites")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    const mentorIds = favorites.map((f) => f.mentorId);
    const mentors = await Promise.all(
      mentorIds.map((id) => ctx.db.get(id))
    );

    return mentors.filter((m) => m !== null);
  },
});

export const bookMentorSession = mutation({
  args: {
    mentorId: v.id("mentors"),
    userId: v.id("users"),
    topic: v.string(),
    scheduledAt: v.number(),
    type: v.string(),
  },
  handler: async (ctx, args) => {
    const sessionId = await ctx.db.insert("mentor_sessions", {
      mentorId: args.mentorId,
      userId: args.userId,
      topic: args.topic,
      scheduledAt: args.scheduledAt,
      status: "upcoming",
      type: args.type,
      createdAt: Date.now(),
      updatedAt: Date.now(),
    });

    // Update mentor's session count
    const mentor = await ctx.db.get(args.mentorId);
    if (mentor) {
      await ctx.db.patch(args.mentorId, {
        sessionsCount: mentor.sessionsCount + 1,
        updatedAt: Date.now(),
      });
    }

    return sessionId;
  },
});

export const toggleMentorFavorite = mutation({
  args: {
    mentorId: v.id("mentors"),
    userId: v.id("users"),
  },
  handler: async (ctx, args) => {
    const existing = await ctx.db
      .query("mentor_favorites")
      .withIndex("by_user_mentor", (q) =>
        q.eq("userId", args.userId).eq("mentorId", args.mentorId)
      )
      .first();

    if (existing) {
      await ctx.db.delete(existing._id);
      return false; // Removed from favorites
    } else {
      await ctx.db.insert("mentor_favorites", {
        userId: args.userId,
        mentorId: args.mentorId,
        createdAt: Date.now(),
      });
      return true; // Added to favorites
    }
  },
});

export const rateMentorSession = mutation({
  args: {
    sessionId: v.id("mentor_sessions"),
    rating: v.number(),
    review: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    await ctx.db.patch(args.sessionId, {
      rating: args.rating,
      review: args.review,
      updatedAt: Date.now(),
    });

    // Update mentor's average rating (simplified)
    const session = await ctx.db.get(args.sessionId);
    if (session) {
      const mentor = await ctx.db.get(session.mentorId);
      if (mentor) {
        // In a real app, you'd calculate average from all ratings
        const newRating = (mentor.rating + args.rating) / 2;
        await ctx.db.patch(session.mentorId, {
          rating: Math.round(newRating * 10) / 10, // Round to 1 decimal
          updatedAt: Date.now(),
        });
      }
    }

    return args.sessionId;
  },
});

// Achievement Functions
export const getUserAchievements = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("user_achievements")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();
  },
});

export const unlockAchievement = mutation({
  args: {
    userId: v.id("users"),
    achievementId: v.string(),
  },
  handler: async (ctx, args) => {
    const existing = await ctx.db
      .query("user_achievements")
      .withIndex("by_user_achievement", (q) =>
        q.eq("userId", args.userId).eq("achievementId", args.achievementId)
      )
      .first();

    if (!existing) {
      const achievementId = await ctx.db.insert("user_achievements", {
        userId: args.userId,
        achievementId: args.achievementId,
        unlockedAt: Date.now(),
      });

      // Send notification via Resend (if configured)
      // This would integrate with Resend for email notifications

      return achievementId;
    }

    return null; // Already unlocked
  },
});

export const getAllAchievements = query({
  args: {},
  handler: async (ctx) => {
    // Return hardcoded achievements for now since no achievements table exists
    return [
      { id: "first_test", name: "First Test", description: "Complete your first fitness test", icon: "🎯" },
      { id: "score_100", name: "Century Club", description: "Score 100 points in a single test", icon: "💯" },
      { id: "week_streak", name: "Weekly Warrior", description: "Complete tests for 7 consecutive days", icon: "🔥" },
      { id: "perfect_form", name: "Perfect Form", description: "Achieve 100% form accuracy", icon: "⭐" },
    ];
  },
});

// Body Logs Functions
export const saveBodyLog = mutation({
  args: {
    userId: v.id("users"),
    weight: v.optional(v.number()),
    height: v.optional(v.number()),
    bodyFat: v.optional(v.number()),
    muscleMass: v.optional(v.number()),
    notes: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const logId = await ctx.db.insert("body_logs", {
      userId: args.userId,
      date: Date.now(),
      weight: args.weight,
      height: args.height,
      bodyFat: args.bodyFat,
      muscleMass: args.muscleMass,
      notes: args.notes,
      createdAt: Date.now(),
      updatedAt: Date.now(),
    });

    return logId;
  },
});

export const getUserBodyLogs = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    return await ctx.db
      .query("body_logs")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc")
      .collect();
  },
});

// Enhanced User Stats
export const getUserStats = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const testResults = await ctx.db
      .query("test_results")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    const achievements = await ctx.db
      .query("user_achievements")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    const user = await ctx.db.get(args.userId);
    const totalScore = user?.totalScore || 0;

    // Calculate ranking (simplified)
    const allUsers = await ctx.db.query("users").collect();
    const sortedUsers = allUsers
      .filter((u) => u.totalScore > 0)
      .sort((a, b) => (b.totalScore || 0) - (a.totalScore || 0));

    const userRank = sortedUsers.findIndex((u) => u._id === args.userId) + 1;
    const totalUsers = sortedUsers.length;
    const percentile = totalUsers > 0 ? ((totalUsers - userRank + 1) / totalUsers * 100).toFixed(0) : "0";

    return {
      totalTests: testResults.length,
      averageScore: testResults.length > 0
        ? testResults.reduce((sum, r) => sum + r.score, 0) / testResults.length
        : 0,
      totalScore,
      ranking: `Top ${percentile}%`,
      badges: achievements.length,
      completedTests: testResults.filter(r => r.score >= 70).length, // Assuming 70+ is pass
      totalAvailableTests: 6, // This should come from tests collection
    };
  },
});
