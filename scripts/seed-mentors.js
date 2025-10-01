// Convex Mentor Seeding Script
// This script can be run to initialize demo mentors in the database

import { ConvexHttpClient } from "convex/browser";

const client = new ConvexHttpClient(process.env.CONVEX_URL || "https://fantastic-ibex-496.convex.site");

async function seedMentors() {
  try {
    console.log("🌱 Starting mentor seeding process...");
    
    const result = await client.mutation("functions_additional:seedDemoMentors", {});
    
    console.log("✅ Mentor seeding completed:");
    console.log(`   Message: ${result.message}`);
    console.log(`   Mentors created: ${result.count}`);
    
    if (result.mentorIds) {
      console.log("   Mentor IDs:", result.mentorIds);
    }
    
  } catch (error) {
    console.error("❌ Error seeding mentors:", error);
  }
}

async function getMentors() {
  try {
    console.log("📋 Fetching current mentors...");
    
    const mentors = await client.query("functions_additional:getMentors", {});
    
    console.log(`✅ Found ${mentors.length} mentors:`);
    mentors.forEach((mentor, index) => {
      console.log(`   ${index + 1}. ${mentor.name} - ${mentor.specialty} (Rating: ${mentor.rating})`);
    });
    
  } catch (error) {
    console.error("❌ Error fetching mentors:", error);
  }
}

async function clearMentors() {
  try {
    console.log("🗑️ Clearing all mentors...");
    
    const result = await client.mutation("functions_additional:clearAllMentors", {});
    
    console.log("✅ Mentors cleared:");
    console.log(`   Message: ${result.message}`);
    console.log(`   Mentors removed: ${result.count}`);
    
  } catch (error) {
    console.error("❌ Error clearing mentors:", error);
  }
}

// Main execution
async function main() {
  const command = process.argv[2];
  
  switch (command) {
    case "seed":
      await seedMentors();
      break;
    case "list":
      await getMentors();
      break;
    case "clear":
      await clearMentors();
      break;
    case "reset":
      await clearMentors();
      await seedMentors();
      break;
    default:
      console.log("📖 Usage:");
      console.log("   npm run seed-mentors seed   - Add demo mentors to database");
      console.log("   npm run seed-mentors list   - List current mentors");
      console.log("   npm run seed-mentors clear  - Remove all mentors");
      console.log("   npm run seed-mentors reset  - Clear and re-seed mentors");
  }
}

if (require.main === module) {
  main().catch(console.error);
}

export { seedMentors, getMentors, clearMentors };