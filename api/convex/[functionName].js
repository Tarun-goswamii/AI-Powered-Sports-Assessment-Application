// Vercel API endpoint to proxy Convex requests
// This helps avoid CORS issues and provides a unified API

export default async function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const { query: { functionName }, method, body } = req;

  // Your Convex deployment URL - replace with your actual URL
  const CONVEX_URL = process.env.CONVEX_URL || 'https://grateful-ostrich-123.convex.cloud';

  try {
    const convexEndpoint = `${CONVEX_URL}/functions:${functionName}`;
    
    let convexResponse;
    
    if (method === 'GET') {
      // For GET requests, pass query parameters
      const queryParams = new URLSearchParams(body || {}).toString();
      const url = queryParams ? `${convexEndpoint}?${queryParams}` : convexEndpoint;
      convexResponse = await fetch(url, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });
    } else {
      // For POST requests, pass body as JSON
      convexResponse = await fetch(convexEndpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body || {}),
      });
    }

    const data = await convexResponse.json();

    if (!convexResponse.ok) {
      throw new Error(`Convex API error: ${convexResponse.status}`);
    }

    res.status(200).json(data);
  } catch (error) {
    console.error('Convex proxy error:', error);
    
    // Return mock data for development/fallback
    const mockData = getMockData(functionName, body);
    res.status(200).json(mockData);
  }
}

function getMockData(functionName, args) {
  switch (functionName) {
    case 'getUserStats':
      return {
        totalTests: 15,
        avgScore: 85.5,
        bestScore: 95,
        improvementRate: 12.5,
        weeklyGoal: 3,
        completedThisWeek: 2,
        streak: 7,
      };
    case 'getMentors':
      return {
        mentors: [
          {
            id: 'mentor_1',
            name: 'Sarah Johnson',
            expertise: 'Strength Training',
            rating: 4.8,
            experience: '8 years',
            profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b5e5?w=400',
            bio: 'Certified personal trainer specializing in strength and conditioning.',
            specialties: ['Strength Training', 'Powerlifting', 'Injury Prevention'],
            hourlyRate: 75,
            availability: ['Monday', 'Wednesday', 'Friday'],
            createdAt: new Date().toISOString(),
          },
        ]
      };
    case 'getCommunityPosts':
      return {
        posts: [
          {
            id: 'post_1',
            authorId: 'user_1',
            authorName: 'John Doe',
            content: 'Just completed my first marathon! Training with Mike was incredible.',
            type: 'achievement',
            likes: 24,
            comments: 8,
            createdAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
            tags: ['marathon', 'achievement'],
          },
        ]
      };
    default:
      return { error: `Unknown function: ${functionName}` };
  }
}