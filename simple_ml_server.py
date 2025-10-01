#!/usr/bin/env python3
"""
Simple ML Server for Sports Assessment
Runs a basic Flask server for testing video analysis pipeline
"""

import sys
import time
from threading import Thread
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import urllib.parse

class MLHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            response = {
                'status': 'healthy',
                'ml_available': False,
                'message': 'Simple ML Server Running',
                'timestamp': str(int(time.time()))
            }
            self.wfile.write(json.dumps(response).encode())
        else:
            self.send_response(404)
            self.end_headers()
    
    def do_POST(self):
        if self.path == '/analyze_video':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            # Simulate analysis results
            response = {
                'success': True,
                'exercise_type': 'pushup',
                'repetitions': 15,
                'form_score': 85.5,
                'duration': 45.2,
                'analysis': {
                    'good_form_percentage': 85.5,
                    'average_speed': 2.1,
                    'consistency_score': 78.3
                },
                'message': 'Video analysis completed (simulation mode)'
            }
            self.wfile.write(json.dumps(response).encode())
        else:
            self.send_response(404)
            self.end_headers()
    
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
    
    def log_message(self, format, *args):
        print(f"[{time.strftime('%H:%M:%S')}] {format % args}")

def run_server():
    port = 5001
    server = HTTPServer(('localhost', port), MLHandler)
    print(f"🚀 Simple ML Server started on http://localhost:{port}")
    print("Endpoints available:")
    print("  GET  /health - Health check")
    print("  POST /analyze_video - Video analysis (simulation)")
    print("\nPress Ctrl+C to stop the server")
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")
        server.shutdown()

if __name__ == '__main__':
    run_server()