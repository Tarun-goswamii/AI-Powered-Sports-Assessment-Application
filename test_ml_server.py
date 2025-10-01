from flask import Flask, jsonify
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'healthy',
        'message': 'ML Server is running in test mode'
    }), 200

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        'message': 'Sports Assessment ML Server - Test Version',
        'endpoints': ['/health', '/analyze_video']
    }), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5001))
    print(f"🚀 Starting Test ML Server on port {port}...")
    app.run(host='0.0.0.0', port=port, debug=False)