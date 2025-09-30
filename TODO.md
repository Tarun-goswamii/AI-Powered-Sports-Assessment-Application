# TODO: Make App Data Completely Dynamic

## Current Status
- Service initialization commented out in main.dart
- Mentor data hardcoded in mentor_screen.dart
- User progress, achievements, communities need to be dynamic

## Tasks

### 1. Enable Service Initialization
- [ ] Uncomment service initialization in lib/main.dart
- [ ] Test app startup with Convex service enabled

### 2. Create Mentor Model and Service
- [ ] Create lib/core/models/mentor_model.dart
- [ ] Create lib/core/services/mentor_service.dart for Convex integration
- [ ] Add mentor functions to convex/functions.ts
- [ ] Add mock mentor data to convex service

### 3. Update Mentor Screen
- [ ] Replace hardcoded mentor data in mentor_screen.dart with dynamic fetching
- [ ] Add loading states and error handling
- [ ] Update mentor cards to use dynamic data

### 4. Make User Progress Dynamic
- [ ] Update home_screen.dart to fetch actual user test results
- [ ] Ensure progress_card shows real completed/total tests
- [ ] Make quick_stats_section display actual user stats

### 5. Dynamic Achievements
- [ ] Update achievements_screen.dart to fetch user achievements from Convex
- [ ] Show locked achievements for new users (no tests completed)
- [ ] Display unlocked achievements based on actual progress

### 6. Dynamic Body Logs
- [ ] Ensure body logs are empty for new users
- [ ] Connect profile screen to update body logs
- [ ] Reflect body log changes throughout the app

### 7. Dynamic Communities
- [ ] Update community_screen.dart to fetch communities from Convex
- [ ] Show communities in community section (not chats for new users)
- [ ] Add community interaction features

### 8. Testing and Verification
- [ ] Test all screens with dynamic data
- [ ] Verify new user experience (0 progress, locked achievements, empty body logs)
- [ ] Confirm mentor data loads from backend
- [ ] Test community features
