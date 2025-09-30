import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

export const getLeaderboard = query({
  args: {},
  handler: async (ctx) => {
    const leaderboard = await ctx.db
      .query("leaderboard")
      .order("desc", "totalScore")
      .take(10)
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
      .order("desc", "completedAt")
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
