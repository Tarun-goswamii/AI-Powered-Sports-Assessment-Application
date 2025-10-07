// User Management Functions for Flutter App Integration
import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

// Get user by ID (users:getById)
export const getById = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    // Try to find user by ID field first (for backward compatibility)
    const users = await ctx.db.query("users").collect();
    const user = users.find(u => u._id === args.userId || (u as any).id === args.userId);
    
    if (!user) {
      throw new Error(`User not found with ID: ${args.userId}`);
    }
    return user;
  },
});

// Update user profile (users:update)
export const update = mutation({
  args: {
    userId: v.string(),
    name: v.optional(v.string()),
    phone: v.optional(v.string()),
    dateOfBirth: v.optional(v.string()),
    gender: v.optional(v.string()),
    height: v.optional(v.number()),
    weight: v.optional(v.number()),
    sport: v.optional(v.string()),
    level: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    // Find the user
    const users = await ctx.db.query("users").collect();
    const user = users.find(u => u._id === args.userId || (u as any).id === args.userId);
    
    if (!user) {
      throw new Error(`User not found with ID: ${args.userId}`);
    }

    // Prepare update data
    const updateData: any = {
      updatedAt: Date.now(),
    };

    if (args.name !== undefined) updateData.name = args.name;
    if (args.phone !== undefined) updateData.phone = args.phone;
    if (args.dateOfBirth !== undefined) updateData.dateOfBirth = args.dateOfBirth;
    if (args.gender !== undefined) updateData.gender = args.gender;
    if (args.height !== undefined) updateData.height = args.height;
    if (args.weight !== undefined) updateData.weight = args.weight;
    if (args.sport !== undefined) updateData.sport = args.sport;
    if (args.level !== undefined) updateData.level = args.level;

    // Update the user
    await ctx.db.patch(user._id, updateData);

    return { success: true, userId: user._id };
  },
});

// Create new user (users:create)
export const createUser = mutation({
  args: {
    email: v.string(),
    displayName: v.string(),
    password: v.string(),
    // Add other fields as necessary
  },
  handler: async (ctx, args) => {
    // Check if the user already exists
    const existingUsers = await ctx.db.query("users").collect();
    const existingUser = existingUsers.find(u => u.email === args.email);
    
    if (existingUser) {
      throw new Error(`User already exists with email: ${args.email}`);
    }

    try {
      // Create user in database
      const userId = await ctx.db.insert("users", {
        email: args.email,
        displayName: args.displayName,
        passwordHash: await hashPassword(args.password), // Ensure to hash the password
        createdAt: Date.now(),
      });

      console.log(`✅ User created successfully: ${userId}`);

      // 📧 SEND WELCOME EMAIL (non-blocking)
      try {
        await ctx.runMutation(api.emails.sendWelcomeEmail, {
          userEmail: args.email,
          displayName: args.displayName,
        });
        console.log('✅ Welcome email triggered successfully');
      } catch (emailError) {
        console.error('⚠️ Email sending failed (non-critical):', emailError);
        // Don't throw - user registration still succeeds even if email fails
      }

      return {
        userId,
        success: true,
        message: 'User created successfully',
      };

    } catch (error) {
      console.error('❌ Error creating user:', error);
      throw error;
    }
  },
});

// Utility function to hash passwords
async function hashPassword(password: string): Promise<string> {
  // Implement password hashing logic here (e.g., using bcrypt)
  return password; // Placeholder - replace with hashed password
}
