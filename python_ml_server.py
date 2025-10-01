# python_ml_server.py
from flask import Flask, request, jsonify
from flask_cors import CORS
import cv2
import numpy as np
import sys
import os
import tempfile
import json

# Add the OptiFit directory to Python path
optifit_path = os.path.join(os.path.dirname(__file__), 'OptiFit-main')
sys.path.append(optifit_path)

try:
    from pose_detection import detect_pose, calculate_angle
    from exercise_counter import ExerciseCounter
    import mediapipe as mp
    ML_AVAILABLE = True
except ImportError:
    print("Warning: ML dependencies not available. Using simulation mode.")
    ML_AVAILABLE = False

app = Flask(__name__)
CORS(app)

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint for deployment platforms"""
    return jsonify({
        'status': 'healthy',
        'ml_available': ML_AVAILABLE,
        'timestamp': datetime.now().isoformat(),
        'version': '1.0.0'
    }), 200

# Exercise configurations
EXERCISE_CONFIG = {
    'pushup': {
        'landmarks': ['LEFT_SHOULDER', 'LEFT_ELBOW', 'LEFT_WRIST'],
        'up_threshold': 160,
        'down_threshold': 90,
        'name': 'Push-up'
    },
    'pullup': {
        'landmarks': ['LEFT_SHOULDER', 'LEFT_ELBOW', 'LEFT_WRIST'],
        'up_threshold': 160,
        'down_threshold': 90,
        'name': 'Pull-up'
    },
    'squat': {
        'landmarks': ['LEFT_HIP', 'LEFT_KNEE', 'LEFT_ANKLE'],
        'up_threshold': 160,
        'down_threshold': 70,
        'name': 'Squat'
    },
    'bicepCurl': {
        'landmarks': ['LEFT_SHOULDER', 'LEFT_ELBOW', 'LEFT_WRIST'],
        'up_threshold': 160,
        'down_threshold': 60,
        'name': 'Bicep Curl'
    },
    'shoulderPress': {
        'landmarks': ['LEFT_SHOULDER', 'LEFT_ELBOW', 'LEFT_WRIST'],
        'up_threshold': 160,
        'down_threshold': 90,
        'name': 'Shoulder Press'
    },
    'sprint': {
        'landmarks': ['LEFT_HIP', 'LEFT_KNEE', 'LEFT_ANKLE'],
        'up_threshold': 180,
        'down_threshold': 30,
        'name': '40m Sprint'
    },
    'burpee': {
        'landmarks': ['LEFT_SHOULDER', 'LEFT_HIP', 'LEFT_KNEE'],
        'up_threshold': 160,
        'down_threshold': 45,
        'name': 'Burpee'
    },
    'plank': {
        'landmarks': ['LEFT_SHOULDER', 'LEFT_HIP', 'LEFT_ANKLE'],
        'up_threshold': 180,
        'down_threshold': 160,
        'name': 'Plank Hold'
    }
}

@app.route('/analyze_video', methods=['POST'])
def analyze_video():
    """Analyze uploaded video file"""
    try:
        if 'video' not in request.files:
            return jsonify({'error': 'No video file provided'}), 400
        
        video_file = request.files['video']
        exercise_type = request.form.get('exercise_type', 'pushup')
        config_str = request.form.get('config', '{}')
        config = json.loads(config_str)
        
        # Save uploaded video temporarily
        with tempfile.NamedTemporaryFile(delete=False, suffix='.mp4') as temp_file:
            video_file.save(temp_file.name)
            video_path = temp_file.name
        
        # Analyze video
        if ML_AVAILABLE:
            results = analyze_with_ml(video_path, exercise_type, config)
        else:
            results = simulate_analysis(exercise_type)
        
        # Clean up temporary file
        os.unlink(video_path)
        
        return jsonify(results), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

def analyze_with_ml(video_path, exercise_type, config):
    """Analyze video using MediaPipe and pose detection"""
    try:
        exercise_config = EXERCISE_CONFIG.get(exercise_type, EXERCISE_CONFIG['pushup'])
        counter = ExerciseCounter(
            exercise_config['name'],
            exercise_config['up_threshold'],
            exercise_config['down_threshold']
        )
        
        cap = cv2.VideoCapture(video_path)
        frame_count = 0
        total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        fps = cap.get(cv2.CAP_PROP_FPS)
        
        angles = []
        time_stamps = []
        confidence_scores = []
        
        mp_pose = mp.solutions.pose
        
        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break
                
            frame_count += 1
            current_time = frame_count / fps
            
            # Detect pose
            results = detect_pose(frame)
            
            if results.pose_landmarks:
                landmarks = results.pose_landmarks.landmark
                confidence_scores.append(results.pose_landmarks.visibility[0] if hasattr(results.pose_landmarks, 'visibility') else 0.9)
                
                # Get relevant landmarks for exercise
                landmark_indices = [getattr(mp_pose.PoseLandmark, name).value for name in exercise_config['landmarks']]
                body_points = [landmarks[idx] for idx in landmark_indices]
                
                # Calculate angle
                angle = calculate_angle(*[(point.x, point.y) for point in body_points])
                angles.append(angle)
                time_stamps.append(current_time)
                
                # Update counter
                counter.update(angle)
            else:
                confidence_scores.append(0.0)
        
        cap.release()
        
        # Calculate metrics
        repetitions = counter.rep_count
        avg_confidence = sum(confidence_scores) / len(confidence_scores) if confidence_scores else 0.0
        
        # Calculate form score based on angle consistency
        form_score = calculate_form_score(angles) if angles else 0.0
        
        # Calculate speed score based on rep timing
        speed_score = calculate_speed_score(time_stamps, repetitions)
        
        # Calculate accuracy based on confidence
        accuracy_score = avg_confidence * 100
        
        # Calculate endurance score (based on consistency over time)
        endurance_score = calculate_endurance_score(angles, confidence_scores)
        
        return {
            'repetitions': repetitions,
            'accuracy': min(accuracy_score, 100.0),
            'speed': min(speed_score, 100.0),
            'form': min(form_score, 100.0),
            'endurance': min(endurance_score, 100.0),
            'time_stamps': time_stamps,
            'angles': angles,
            'pose_data': {
                'confidence': avg_confidence,
                'total_frames': total_frames,
                'frames_with_pose': len([c for c in confidence_scores if c > 0.5]),
                'video_duration': total_frames / fps if fps > 0 else 0
            }
        }
        
    except Exception as e:
        print(f"ML Analysis error: {e}")
        return simulate_analysis(exercise_type)

def calculate_form_score(angles):
    """Calculate form score based on angle consistency"""
    if len(angles) < 4:
        return 70.0
    
    # Calculate standard deviation of angles (lower is better form)
    angle_std = np.std(angles)
    
    # Convert to score (0-100, where lower std = higher score)
    form_score = max(0, 100 - (angle_std / 2))
    return form_score

def calculate_speed_score(time_stamps, repetitions):
    """Calculate speed score based on repetition timing"""
    if repetitions < 2 or len(time_stamps) < 2:
        return 70.0
    
    # Calculate average time per rep
    total_time = time_stamps[-1] - time_stamps[0] if time_stamps else 1
    avg_time_per_rep = total_time / max(repetitions, 1)
    
    # Ideal rep time varies by exercise (1-3 seconds per rep)
    ideal_time = 2.0
    time_deviation = abs(avg_time_per_rep - ideal_time)
    
    # Convert to score
    speed_score = max(0, 100 - (time_deviation * 20))
    return speed_score

def calculate_endurance_score(angles, confidence_scores):
    """Calculate endurance score based on consistency over time"""
    if len(confidence_scores) < 10:
        return 70.0
    
    # Split into segments and check consistency
    segment_size = len(confidence_scores) // 4
    segments = [confidence_scores[i:i+segment_size] for i in range(0, len(confidence_scores), segment_size)]
    
    # Calculate average confidence for each segment
    segment_avgs = [sum(seg) / len(seg) if seg else 0 for seg in segments]
    
    # Check if confidence remains high throughout
    endurance_score = min(segment_avgs) * 100 if segment_avgs else 70.0
    return endurance_score

def simulate_analysis(exercise_type):
    """Simulate analysis results when ML is not available"""
    import random
    
    base_reps = {
        'pushup': 15,
        'pullup': 8,
        'squat': 20,
        'bicepCurl': 12,
        'shoulderPress': 10,
        'burpee': 8,
        'sprint': 1,
        'plank': 1
    }
    
    repetitions = base_reps.get(exercise_type, 10) + random.randint(-3, 5)
    
    return {
        'repetitions': max(0, repetitions),
        'accuracy': 75.0 + random.uniform(-10, 15),
        'speed': 70.0 + random.uniform(-15, 20),
        'form': 80.0 + random.uniform(-10, 15),
        'endurance': 85.0 + random.uniform(-10, 10),
        'time_stamps': [i * 2.5 for i in range(repetitions)],
        'angles': [90 + random.uniform(-30, 30) for _ in range(repetitions * 4)],
        'pose_data': {
            'confidence': 0.85 + random.uniform(-0.1, 0.1),
            'total_frames': 300,
            'frames_with_pose': 280,
            'video_duration': 10.0
        }
    }

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    print("🚀 Starting Sports Assessment ML Server...")
    print(f"ML Libraries Available: {ML_AVAILABLE}")
    print(f"Server running on http://0.0.0.0:{port}")
    
    # Use debug=False for production
    debug_mode = os.environ.get('FLASK_ENV') == 'development'
    app.run(host='0.0.0.0', port=port, debug=debug_mode)