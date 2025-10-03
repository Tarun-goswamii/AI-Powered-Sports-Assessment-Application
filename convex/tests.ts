// Test Management Functions for Flutter App Integration
import { query } from "./_generated/server";
import { v } from "convex/values";

// Get list of all available tests (tests:list)
export const list = query({
  args: {},
  handler: async (ctx) => {
    // Return hardcoded tests since there's no tests table in schema
    // In production, this would query from a tests collection
    const tests = [
      {
        id: "sit-ups",
        name: "Sit-Ups Test",
        description: "Core strength assessment",
        duration: "60 seconds",
        difficulty: "Beginner",
        category: "Core Strength",
        isActive: true,
        createdAt: Date.now(),
      },
      {
        id: "push-ups",
        name: "Push-Ups Test",
        description: "Upper body strength assessment",
        duration: "60 seconds",
        difficulty: "Beginner",
        category: "Upper Body",
        isActive: true,
        createdAt: Date.now(),
      },
      {
        id: "vertical-jump",
        name: "Vertical Jump Test",
        description: "Explosive power assessment",
        duration: "3 attempts",
        difficulty: "Intermediate",
        category: "Power",
        isActive: true,
        createdAt: Date.now(),
      },
      {
        id: "shuttle-run",
        name: "Shuttle Run Test",
        description: "Agility and speed assessment",
        duration: "2 minutes",
        difficulty: "Intermediate",
        category: "Agility",
        isActive: true,
        createdAt: Date.now(),
      },
      {
        id: "squats",
        name: "Squats Test",
        description: "Lower body strength assessment",
        duration: "60 seconds",
        difficulty: "Beginner",
        category: "Lower Body",
        isActive: true,
        createdAt: Date.now(),
      },
      {
        id: "plank",
        name: "Plank Hold Test",
        description: "Core endurance assessment",
        duration: "Max time",
        difficulty: "Intermediate",
        category: "Core Endurance",
        isActive: true,
        createdAt: Date.now(),
      },
    ];

    return tests;
  },
});

// Get test by ID
export const getById = query({
  args: { testId: v.string() },
  handler: async (ctx, args) => {
    // Return test details (hardcoded for now)
    const testsMap: Record<string, any> = {
      "sit-ups": {
        id: "sit-ups",
        name: "Sit-Ups Test",
        description: "Core strength assessment",
        instructions: [
          "Lie on your back with knees bent",
          "Place hands behind your head",
          "Lift your torso to your knees",
          "Lower back down with control",
          "Repeat for 60 seconds"
        ],
        duration: "60 seconds",
        difficulty: "Beginner",
        category: "Core Strength",
        isActive: true,
      },
      "push-ups": {
        id: "push-ups",
        name: "Push-Ups Test",
        description: "Upper body strength assessment",
        instructions: [
          "Start in plank position",
          "Lower body until chest nearly touches ground",
          "Push back up to starting position",
          "Keep body straight throughout",
          "Repeat for 60 seconds"
        ],
        duration: "60 seconds",
        difficulty: "Beginner",
        category: "Upper Body",
        isActive: true,
      },
    };

    const test = testsMap[args.testId];
    if (!test) {
      throw new Error(`Test not found with ID: ${args.testId}`);
    }
    return test;
  },
});
