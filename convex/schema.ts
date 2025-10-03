import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    email: v.string(),
    name: v.string(),
    credits: v.number(),
    totalScore: v.number(),
    updatedAt: v.number(),
    createdAt: v.number(),
    bio: v.optional(v.string()),
    level: v.optional(v.string()),
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
    status: v.string(), // 'pending', 'in_progress', 'completed'
    rawData: v.optional(v.any()),
    processedData: v.optional(v.any()),
    recommendations: v.optional(v.array(v.string())),
    grade: v.optional(v.string()),
    percentile: v.optional(v.number()),
    feedback: v.optional(v.string()),
    startedAt: v.optional(v.number()),
    mlAnalysis: v.optional(v.object({
      cheatDetected: v.boolean(),
      poseAccuracy: v.number(),
      repetitions: v.number(),
      formScore: v.number(),
      violations: v.array(v.string()),
      keyPoints: v.any(),
      confidenceScore: v.number(),
      recommendations: v.array(v.string()),
    })),
    videoUrl: v.optional(v.string()),
    completedAt: v.number(),
    metadata: v.optional(v.object({
      cheatDetected: v.boolean(),
      poseAccuracy: v.number(),
      repetitions: v.number(),
      formScore: v.number(),
    })),
  })
    .index("by_user", ["userId"])
    .index("by_score", ["score"])
    .index("by_completedAt", ["completedAt"])
    .index("by_status", ["status"]),

  community_posts: defineTable({
    userId: v.id("users"),
    content: v.string(),
    type: v.string(),
    imageUrl: v.optional(v.string()),
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

  user_achievements: defineTable({
    userId: v.id("users"),
    achievementId: v.string(),
    unlockedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_achievement", ["achievementId"])
    .index("by_user_achievement", ["userId", "achievementId"]),

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

  products: defineTable({
    name: v.string(),
    description: v.string(),
    price: v.number(),
    category: v.string(),
    imageUrl: v.optional(v.string()),
    isActive: v.boolean(),
    createdAt: v.number(),
  })
    .index("by_category", ["category"])
    .index("by_active", ["isActive"]),

  purchases: defineTable({
    userId: v.id("users"),
    productId: v.id("products"),
    quantity: v.number(),
    totalCost: v.number(),
    status: v.string(),
    createdAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_product", ["productId"]),

  mentor_sessions: defineTable({
    mentorId: v.id("mentors"),
    userId: v.id("users"),
    topic: v.string(),
    scheduledAt: v.number(),
    status: v.string(), // 'upcoming', 'completed', 'cancelled'
    type: v.string(), // 'video_call', 'chat_session'
    rating: v.optional(v.number()),
    review: v.optional(v.string()),
    completedAt: v.optional(v.number()),
    createdAt: v.number(),
    updatedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_mentor", ["mentorId"])
    .index("by_status", ["status"])
    .index("by_scheduledAt", ["scheduledAt"]),

  mentor_favorites: defineTable({
    userId: v.id("users"),
    mentorId: v.id("mentors"),
    createdAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_mentor", ["mentorId"])
    .index("by_user_mentor", ["userId", "mentorId"]),

  credit_transactions: defineTable({
    userId: v.id("users"),
    amount: v.number(),
    type: v.string(), // 'earned', 'spent', 'bonus', 'reward'
    description: v.string(),
    referenceId: v.optional(v.string()),
    referenceType: v.optional(v.string()), // 'test', 'achievement', 'purchase', 'daily_bonus'
    createdAt: v.number(),
    expiresAt: v.optional(v.number()),
  })
    .index("by_user", ["userId"])
    .index("by_type", ["type"])
    .index("by_createdAt", ["createdAt"]),
});
