import cv2
import pose_detection as pd
from exercise_counter import ExerciseCounter
# Initialize counters
pushup_counter = ExerciseCounter("Pushup", up_threshold=160, down_threshold=90)
pullup_counter = ExerciseCounter("Pullup", up_threshold=160, down_threshold=90)
bicep_curl_counter = ExerciseCounter("Bicep Curl", up_threshold=160, down_threshold=60)
squat_counter = ExerciseCounter("Squat", up_threshold=160, down_threshold=70)
shoulder_press_counter = ExerciseCounter("Shoulder Press", up_threshold=160, down_threshold=90)

def process_video(file_path, counter, relevant_landmarks):
    cap = cv2.VideoCapture(file_path)  # Use file_path instead of uploaded file object
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)  # Adjusted frame width
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)  # Adjusted frame height

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        # Detect pose landmarks
        results = pd.detect_pose(frame)

        if results.pose_landmarks:
            # Draw pose landmarks on frame
            pd.mp_drawing.draw_landmarks(frame, results.pose_landmarks, pd.mp_pose.POSE_CONNECTIONS)
            landmarks = results.pose_landmarks.landmark

            # Extract relevant landmarks for exercise
            body_points = [landmarks[pt.value] for pt in relevant_landmarks]
            body_angle = pd.calculate_angle(*[(point.x, point.y) for point in body_points])

            # Update counter based on the angle
            reps = counter.update(body_angle)

            # Display counter on frame
            cv2.putText(frame, f'{counter.exercise_name} Reps: {reps}', (50, 100),
                        cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2, cv2.LINE_AA)

        # Show frame with pose landmarks and rep counts
        cv2.imshow(f'AI Fitness Trainer - {counter.exercise_name}', frame)

        if cv2.waitKey(10) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()


def process_webcam(counter, relevant_landmarks):
    cap = cv2.VideoCapture(0)  # 0 is the default webcam ID
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        # Detect pose landmarks
        results = pd.detect_pose(frame)

        if results.pose_landmarks:
            pd.mp_drawing.draw_landmarks(frame, results.pose_landmarks, pd.mp_pose.POSE_CONNECTIONS)
            landmarks = results.pose_landmarks.landmark

            body_points = [landmarks[pt.value] for pt in relevant_landmarks]
            body_angle = pd.calculate_angle(*[(point.x, point.y) for point in body_points])

            reps = counter.update(body_angle)

            cv2.putText(frame, f'{counter.exercise_name} Reps: {reps}', (50, 100),
                        cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2, cv2.LINE_AA)

        cv2.imshow(f'AI Fitness Trainer - {counter.exercise_name}', frame)

        if cv2.waitKey(10) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

# Add specific webcam functions for each exercise
def process_pushup_webcam():
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_SHOULDER, pd.mp_pose.PoseLandmark.LEFT_ELBOW, pd.mp_pose.PoseLandmark.LEFT_WRIST]
    process_webcam(pushup_counter, relevant_landmarks)

def process_pullup_webcam():
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_SHOULDER, pd.mp_pose.PoseLandmark.LEFT_ELBOW, pd.mp_pose.PoseLandmark.LEFT_WRIST]
    process_webcam(pullup_counter, relevant_landmarks)

def process_bicep_curl_webcam():
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_SHOULDER, pd.mp_pose.PoseLandmark.LEFT_ELBOW, pd.mp_pose.PoseLandmark.LEFT_WRIST]
    process_webcam(bicep_curl_counter, relevant_landmarks)

def process_squat_webcam():
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_HIP, pd.mp_pose.PoseLandmark.LEFT_KNEE, pd.mp_pose.PoseLandmark.LEFT_ANKLE]
    process_webcam(squat_counter, relevant_landmarks)

def process_shoulder_press_webcam():
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_SHOULDER, pd.mp_pose.PoseLandmark.LEFT_ELBOW, pd.mp_pose.PoseLandmark.LEFT_WRIST]
    process_webcam(shoulder_press_counter, relevant_landmarks)
    
    
def process_shoulder_press_video(uploaded_file):
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_SHOULDER, pd.mp_pose.PoseLandmark.LEFT_ELBOW, pd.mp_pose.PoseLandmark.LEFT_WRIST]
    
    # Ensure we are handling the uploaded file properly
    temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.mp4')
    temp_file.write(uploaded_file.read())
    temp_file.close()

    process_video(temp_file.name, shoulder_press_counter, relevant_landmarks)
    
def process_pushup_video(uploaded_file):
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_SHOULDER, pd.mp_pose.PoseLandmark.LEFT_ELBOW, pd.mp_pose.PoseLandmark.LEFT_WRIST]
    
    # Ensure we are handling the uploaded file properly
    temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.mp4')
    temp_file.write(uploaded_file.read())
    temp_file.close()

    process_video(temp_file.name, pushup_counter, relevant_landmarks)

def process_pullup_video(uploaded_file):
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_SHOULDER, pd.mp_pose.PoseLandmark.LEFT_ELBOW, pd.mp_pose.PoseLandmark.LEFT_WRIST]
    
    # Ensure we are handling the uploaded file properly
    temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.mp4')
    temp_file.write(uploaded_file.read())
    temp_file.close()

    process_video(temp_file.name, pullup_counter, relevant_landmarks)

def process_bicep_curl_video(uploaded_file):
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_SHOULDER, pd.mp_pose.PoseLandmark.LEFT_ELBOW, pd.mp_pose.PoseLandmark.LEFT_WRIST]
    
    # Ensure we are handling the uploaded file properly
    temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.mp4')
    temp_file.write(uploaded_file.read())
    temp_file.close()

    process_video(temp_file.name, bicep_curl_counter, relevant_landmarks)

def process_squat_video(uploaded_file):
    # Squats: Use landmarks for the hips, knees, and ankles
    relevant_landmarks = [pd.mp_pose.PoseLandmark.LEFT_HIP, pd.mp_pose.PoseLandmark.LEFT_KNEE, pd.mp_pose.PoseLandmark.LEFT_ANKLE]
    
    # Ensure we are handling the uploaded file properly
    temp_file = tempfile.NamedTemporaryFile(delete=False, suffix='.mp4')
    temp_file.write(uploaded_file.read())
    temp_file.close()

    process_video(temp_file.name, squat_counter, relevant_landmarks)
