// Test Results Management Functions for Flutter App Integration
import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

// Get test results by user (testResults:getByUser)
export const getByUser = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    const results = await ctx.db
      .query("test_results")
      .collect();
    
    // Filter by userId (handle both _id reference and userId string)
    const userResults = results.filter(r => 
      r.userId === args.userId || 
      (r.userId as any)?._id === args.userId ||
      (r as any).userId === args.userId
    );

    return {
      results: userResults.sort((a, b) => 
        (b.completedAt || b._creationTime) - (a.completedAt || a._creationTime)
      ),
      totalResults: userResults.length,
    };
  },
});

// Create new test result (testResults:create)
export const create = mutation({
  args: {
    userId: v.string(),
    testId: v.string(),
    status: v.string(),
    rawData: v.any(),
    processedData: v.any(),
    recommendations: v.array(v.string()),
  },
  handler: async (ctx, args) => {
    const resultId = await ctx.db.insert("test_results", {
      userId: args.userId as any,
      testId: args.testId,
      status: args.status,
      rawData: args.rawData || {},
      processedData: args.processedData || {},
      recommendations: args.recommendations || [],
      score: 0,
      completedAt: Date.now(),
    });

    return { resultId, success: true };
  },
});

// Complete test result (testResults:complete)
export const complete = mutation({
  args: {
    resultId: v.string(),
    status: v.string(),
    rawData: v.any(),
    processedData: v.any(),
    score: v.optional(v.number()),
    grade: v.optional(v.string()),
    percentile: v.optional(v.number()),
    feedback: v.optional(v.string()),
    recommendations: v.array(v.string()),
  },
  handler: async (ctx, args) => {
    // Find the test result
    const results = await ctx.db.query("test_results").collect();
    const result = results.find(r => 
      r._id === args.resultId || 
      (r as any).id === args.resultId
    );

    if (!result) {
      throw new Error(`Test result not found with ID: ${args.resultId}`);
    }

    // Update the test result
    await ctx.db.patch(result._id, {
      status: args.status || "completed",
      rawData: args.rawData || (result as any).rawData,
      processedData: args.processedData || (result as any).processedData,
      score: args.score !== undefined ? args.score : result.score,
      grade: args.grade,
      percentile: args.percentile,
      feedback: args.feedback,
      recommendations: args.recommendations || (result as any).recommendations || [],
      completedAt: Date.now(),
    });

    // Update user's total score
    if (args.score !== undefined && result.userId) {
      const userId = typeof result.userId === 'string' ? result.userId : (result.userId as any)._id;
      const users = await ctx.db.query("users").collect();
      const user = users.find(u => u._id === userId || (u as any).id === userId);
      
      if (user) {
        const newTotalScore = (user.totalScore || 0) + args.score;
        await ctx.db.patch(user._id, { 
          totalScore: newTotalScore,
          updatedAt: Date.now(),
        });
      }
    }

    return { success: true, resultId: result._id };
  },
});
