import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

// Community Functions
export const getCommunityPosts = query({
  args: {},
  handler: async (ctx) => {
    const posts = await ctx.db
      .query("community_posts")
      .order("desc", "createdAt")
      .take(20)
      .collect();
    return posts;
  },
});

export const createCommunityPost = mutation({
  args: {
    userId: v.id("users"),
    content: v.string(),
    type: v.string(), // 'achievement', 'general', 'question', etc.
  },
  handler: async (ctx, args) => {
    const postId = await ctx.db.insert("community_posts", {
      userId: args.userId,
      content: args.content,
      type: args.type,
      likes: 0,
      comments: 0,
      createdAt: Date.now(),
    });
    return postId;
  },
});

export const getCommunityChallenges = query({
  args: {},
  handler: async (ctx) => {
    const challenges = await ctx.db
      .query("challenges")
      .filter((q) => q.eq("isActive", true))
      .collect();
    return challenges;
  },
});

export const getCommunityGroups = query({
  args: {},
  handler: async (ctx) => {
    const groups = await ctx.db.query("community_groups").collect();
    return groups;
  },
});

export const joinCommunityGroup = mutation({
  args: {
    userId: v.id("users"),
    groupId: v.id("community_groups"),
  },
  handler: async (ctx, args) => {
    // Check if already joined
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
    }

    return true;
  },
});
