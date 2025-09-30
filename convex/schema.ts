import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    email: v.string(),
    name: v.string(),
    credits: v.number(),
    createdAt: v.number(),
  }).index("by_email", ["email"]),

  test_results: defineTable({
    userId: v.id("users"),
    testId: v.string(),
    score: v.number(),
    completedAt: v.number(),
  }),

  leaderboard: defineTable({
    userId: v.id("users"),
    totalScore: v.number(),
    rank: v.number(),
  }).index("by_score", ["totalScore"]),
});
