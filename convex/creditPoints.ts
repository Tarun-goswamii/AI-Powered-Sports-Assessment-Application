// Credit Points Management Functions for Flutter App Integration
import { query, mutation } from "./_generated/server";
import { v } from "convex/values";

// Get credit points by user (creditPoints:getByUser)
export const getByUser = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    // Get all credit transactions
    const allTransactions = await ctx.db.query("credit_transactions").collect();
    
    // Filter transactions for this user
    const userTransactions = allTransactions.filter(t => 
      String(t.userId) === args.userId || 
      (t.userId as any)?._id === args.userId
    );

    // Calculate total credits
    const totalCredits = userTransactions.reduce((sum, t) => sum + t.amount, 0);

    // Sort by date (newest first)
    const sortedTransactions = userTransactions.sort((a, b) => 
      b.createdAt - a.createdAt
    );

    return {
      transactions: sortedTransactions,
      totalCredits,
    };
  },
});

// Add credit transaction (creditPoints:addTransaction)
export const addTransaction = mutation({
  args: {
    userId: v.string(),
    amount: v.number(),
    type: v.string(),
    description: v.string(),
    referenceId: v.optional(v.string()),
    referenceType: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    // Create transaction
    const transactionId = await ctx.db.insert("credit_transactions", {
      userId: args.userId as any,
      amount: args.amount,
      type: args.type,
      description: args.description,
      referenceId: args.referenceId,
      referenceType: args.referenceType,
      createdAt: Date.now(),
      expiresAt: args.referenceType ? Date.now() + (365 * 24 * 60 * 60 * 1000) : undefined, // 1 year from now
    });

    // Update user's credit balance
    const users = await ctx.db.query("users").collect();
    const user = users.find(u => 
      u._id === args.userId || 
      (u as any).id === args.userId
    );

    if (user) {
      const currentCredits = user.credits || 0;
      const newCredits = currentCredits + args.amount;
      
      await ctx.db.patch(user._id, {
        credits: newCredits,
        updatedAt: Date.now(),
      });
    }

    return { 
      success: true, 
      transactionId,
      message: `${args.amount > 0 ? 'Added' : 'Spent'} ${Math.abs(args.amount)} credits`
    };
  },
});

// Get user's current credit balance
export const getBalance = query({
  args: { userId: v.string() },
  handler: async (ctx, args) => {
    const users = await ctx.db.query("users").collect();
    const user = users.find(u => 
      u._id === args.userId || 
      (u as any).id === args.userId
    );

    if (!user) {
      return { credits: 0 };
    }

    return { 
      credits: user.credits || 0,
      userId: user._id,
    };
  },
});
