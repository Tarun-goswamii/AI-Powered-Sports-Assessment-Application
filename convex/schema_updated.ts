import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  // Existing tables (assuming from original functions)
  users: defineTable({
    email: v.string(),
    name: v.string(),
    credits: v.number(),
    totalScore: v.number(),
    updatedAt: v.number(),
    createdAt: v.number(),
  })
    .index("by_email", ["email"])
    .index("by_totalScore", ["totalScore"]),

  leaderboard: defineTable({
    userId: v.id("users"),
    totalScore: v.number(),
    rank: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_score", ["totalScore"]),

  test_results: defineTable({
    userId: v.id("users"),
    testId: v.string(),
    score: v.number(),
    completedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_score", ["score"]),

  // New tables for mentors
  mentors: defineTable({
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
    createdAt: v.number(),
    updatedAt: v.number(),
  })
    .index("by_category", ["categories"])
    .index("by_rating", ["rating"]),

  mentor_sessions: defineTable({
    mentorId: v.id("mentors"),
    userId: v.id("users"),
    topic: v.string(),
    scheduledAt: v.number(),
    status: v.string(), // upcoming, completed, cancelled
    type: v.string(), // video_call, chat_session
    rating: v.optional(v.number()),
    review: v.optional(v.string()),
    createdAt: v.number(),
    updatedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_mentor", ["mentorId"])
    .index("by_scheduledAt", ["scheduledAt"]),

  mentor_favorites: defineTable({
    userId: v.id("users"),
    mentorId: v.id("mentors"),
    createdAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_mentor", ["mentorId"])
    .index("by_user_mentor", ["userId", "mentorId"]),

  // Achievements
  achievements: defineTable({
    id: v.string(),
    name: v.string(),
    description: v.string(),
    icon: v.string(),
    category: v.string(),
    requiredScore: v.number(),
    isActive: v.boolean(),
    createdAt: v.number(),
  })
    .index("by_category", ["category"]),

  user_achievements: defineTable({
    userId: v.id("users"),
    achievementId: v.string(),
    unlockedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_achievement", ["achievementId"])
    .index("by_user_achievement", ["userId", "achievementId"]),

  // Body logs
  body_logs: defineTable({
    userId: v.id("users"),
    date: v.number(),
    weight: v.optional(v.number()),
    height: v.optional(v.number()),
    bodyFat: v.optional(v.number()),
    muscleMass: v.optional(v.number()),
    notes: v.optional(v.string()),
    createdAt: v.number(),
    updatedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_date", ["date"]),

  // Community tables
  community_posts: defineTable({
    userId: v.id("users"),
    content: v.string(),
    type: v.string(), // 'achievement', 'general', 'question', etc.
    likes: v.number(),
    comments: v.number(),
    createdAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_type", ["type"])
    .index("by_createdAt", ["createdAt"]),

  challenges: defineTable({
    title: v.string(),
    description: v.string(),
    reward: v.number(),
    startDate: v.number(),
    endDate: v.number(),
    isActive: v.boolean(),
    participants: v.number(),
    createdAt: v.number(),
  })
    .index("by_active", ["isActive"])
    .index("by_endDate", ["endDate"]),

  community_groups: defineTable({
    name: v.string(),
    description: v.string(),
    category: v.string(),
    memberCount: v.number(),
    isPublic: v.boolean(),
    createdAt: v.number(),
  })
    .index("by_category", ["category"])
    .index("by_public", ["isPublic"]),

  group_members: defineTable({
    userId: v.id("users"),
    groupId: v.id("community_groups"),
    joinedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_group", ["groupId"])
    .index("by_user_group", ["userId", "groupId"]),
});
