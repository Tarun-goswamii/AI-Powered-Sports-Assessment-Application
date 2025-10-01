#!/usr/bin/env node

const { execSync } = require('child_process');

console.log('🚀 Starting comprehensive demo data seeding...\n');

try {
  // Step 1: Clear existing demo data
  console.log('🧹 Clearing existing demo data...');
  execSync('npx convex run functions_additional:clearAllDemoData', { stdio: 'inherit' });
  
  // Step 2: Seed mentors
  console.log('\n👨‍🏫 Seeding demo mentors...');
  execSync('npx convex run functions_additional:seedDemoMentors', { stdio: 'inherit' });
  
  // Step 3: Seed comprehensive demo data
  console.log('\n📊 Seeding comprehensive demo data...');
  execSync('npx convex run functions_additional:seedComprehensiveDemoData', { stdio: 'inherit' });
  
  console.log('\n✅ Demo data seeding completed successfully!');
  console.log('\n📋 Demo Data Summary:');
  console.log('  • 4 Demo Users with different skill levels');
  console.log('  • 10+ Diverse Mentors with specialties');
  console.log('  • 40+ Test Results across multiple exercises');
  console.log('  • Community Groups & Posts');
  console.log('  • Active Challenges');
  console.log('  • User Achievements');
  console.log('  • Body Tracking Logs');
  console.log('  • Store Products & Purchase History');
  console.log('  • Complete Leaderboard Rankings');
  console.log('\n🎯 Your app is now ready for demonstration!');
  
} catch (error) {
  console.error('❌ Error during seeding:', error.message);
  process.exit(1);
}