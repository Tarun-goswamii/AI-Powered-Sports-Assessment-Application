// Authentication Functions for Flutter App Integration
import { mutation, internalMutation } from "./_generated/server";
import { v } from "convex/values";
import { internal } from "./_generated/api";

// Sign in user (auth:signIn)
export const signIn = mutation({
  args: {
    email: v.string(),
    password: v.string(),
  },
  handler: async (ctx, args) => {
    // Find user by email
    const users = await ctx.db.query("users").collect();
    const user = users.find(u => 
      (u as any).email?.toLowerCase() === args.email.toLowerCase()
    );

    if (!user) {
      throw new Error("User not found with this email");
    }

    // In production, verify password hash
    // For now, return success with userId
    return {
      userId: user._id,
      email: user.email || args.email,
      name: user.name || "User",
      success: true,
    };
  },
});

// Sign up user (auth:signUp)
export const signUp = mutation({
  args: {
    email: v.string(),
    password: v.string(),
    name: v.string(),
  },
  handler: async (ctx, args) => {
    // Check if user already exists
    const users = await ctx.db.query("users").collect();
    const existingUser = users.find(u => 
      (u as any).email?.toLowerCase() === args.email.toLowerCase()
    );

    if (existingUser) {
      throw new Error("User already exists with this email");
    }

    // Create new user
    const userId = await ctx.db.insert("users", {
      email: args.email,
      name: args.name,
      credits: 100, // Starting credits
      totalScore: 0,
      createdAt: Date.now(),
      updatedAt: Date.now(),
    });

    // Create initial leaderboard entry
    await ctx.db.insert("leaderboard", {
      userId: userId,
      totalScore: 0,
      rank: 0,
    });

    // Send welcome email to user (async, don't wait for it)
    ctx.scheduler.runAfter(0, internal.emailService.sendWelcomeEmail, {
      userEmail: args.email,
      userName: args.name,
    });

    // Send admin notification (async, don't wait for it)
    ctx.scheduler.runAfter(0, internal.emailService.sendAdminNotification, {
      userEmail: args.email,
      userName: args.name,
      userId: userId,
    });

    return {
      userId,
      email: args.email,
      name: args.name,
      success: true,
    };
  },
});
