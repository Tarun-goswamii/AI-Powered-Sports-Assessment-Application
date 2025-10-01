const express = require('express');
const cors = require('cors');
const multer = require('multer');
const path = require('path');

const app = express();
const port = 5001;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Configure multer for file uploads
const upload = multer({ 
  dest: 'uploads/',
  limits: { fileSize: 100 * 1024 * 1024 } // 100MB limit
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    ml_available: false,
    message: 'Node.js ML Server Running (Simulation Mode)',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// Video analysis endpoint
app.post('/analyze_video', upload.single('video'), (req, res) => {
  try {
    const exerciseType = req.body.exercise_type || 'pushup';
    
    // Simulate analysis results
    const analysisResult = {
      success: true,
      exercise_type: exerciseType,
      repetitions: Math.floor(Math.random() * 20) + 10, // 10-30 reps
      form_score: Math.round((Math.random() * 30 + 70) * 10) / 10, // 70-100%
      duration: Math.round((Math.random() * 30 + 30) * 10) / 10, // 30-60 seconds
      analysis: {
        good_form_percentage: Math.round((Math.random() * 30 + 70) * 10) / 10,
        average_speed: Math.round((Math.random() * 2 + 1) * 10) / 10,
        consistency_score: Math.round((Math.random() * 30 + 60) * 10) / 10
      },
      message: 'Video analysis completed (simulation mode)',
      timestamp: new Date().toISOString()
    };
    
    // Simulate processing time
    setTimeout(() => {
      res.json(analysisResult);
    }, 1000);
    
  } catch (error) {
    console.error('Analysis error:', error);
    res.status(500).json({
      success: false,
      error: 'Analysis failed',
      message: error.message
    });
  }
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Sports Assessment ML Server - Node.js Version',
    endpoints: {
      'GET /health': 'Health check',
      'POST /analyze_video': 'Video analysis (simulation)'
    },
    status: 'running'
  });
});

// Start server - bind to all interfaces for mobile access
app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Node.js ML Server started on http://0.0.0.0:${port}`);
  console.log('📱 Mobile devices can connect to this server');
  console.log('Endpoints available:');
  console.log('  GET  /health - Health check');
  console.log('  POST /analyze_video - Video analysis (simulation)');
  console.log('\\nPress Ctrl+C to stop the server');
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\\n🛑 Server stopped');
  process.exit(0);
});