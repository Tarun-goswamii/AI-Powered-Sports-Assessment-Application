// Additional Convex Functions for Community, Store, and Profile

import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

// Community Functions
export const getCommunityPosts = query({
  args: { limit: v.optional(v.number()) },
  handler: async (ctx, args) => {
    const limit = args.limit || 20;
    return await ctx.db
      .query("community_posts")
      .order("desc", "createdAt")
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
      updatedAt: Date.now(),
    });

    return postId;
  },
});

export const getCommunityChallenges = query({
  args: {},
  handler: async (ctx) => {
    return await ctx.db
      .query("challenges")
      .filter((q) => q.eq(q.field("isActive"), true))
      .order("desc", "startDate")
      .collect();
  },
});

export const getCommunityGroups = query({
  args: {},
  handler: async (ctx) => {
    return await ctx.db
      .query("community_groups")
      .filter((q) => q.eq(q.field("isActive"), true))
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
          updatedAt: Date.now(),
        });
      }

      return true; // Joined
    }

    return false; // Already member
  },
});

// Store/Product Functions
export const getProducts = query({
  args: { category: v.optional(v.string()) },
  handler: async (ctx, args) => {
    let query = ctx.db.query("products");
    if (args.category) {
      query = query.filter((q) => q.eq(q.field("category"), args.category));
    }
    return await query
      .filter((q) => q.eq(q.field("isActive"), true))
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
      purchasedAt: Date.now(),
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
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc", "date")
      .take(1)
      .collect();

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
